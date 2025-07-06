"""Unified code generator for Dart to Python news blocks."""

import os
import re
from typing import Dict, List, Optional, Any
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass

from .dart_parser import DartNewsBlockParser, DartClass, DartField
from .registry import TypeRegistry, NamingConverter, ValidationRegistry
from .templates import TemplateEngine, TemplateContext


@dataclass
class GenerationConfig:
    """Configuration for code generation."""
    dart_package_path: str
    output_path: str
    template_dir: Optional[str] = None
    custom_mappings: Optional[Dict[str, str]] = None
    include_validation: bool = True
    include_adapter: bool = True
    base_class_override: Optional[Dict[str, str]] = None
    version: str = "1.0.0"


class CodeGenerator:
    """Unified code generator for creating Python models from Dart news_blocks."""
    
    def __init__(self, 
                 dart_package_path: str,
                 output_path: str,
                 template_dir: Optional[str] = None,
                 custom_mappings: Optional[Dict[str, str]] = None):
        """Initialize code generator."""
        self.config = GenerationConfig(
            dart_package_path=dart_package_path,
            output_path=output_path,
            template_dir=template_dir,
            custom_mappings=custom_mappings or {}
        )
        
        # Initialize components
        self.parser = DartNewsBlockParser(dart_package_path)
        self.type_registry = TypeRegistry()
        self.template_engine = TemplateEngine(template_dir)
        self.validation_registry = ValidationRegistry()
        self.naming = NamingConverter()
        
        # Apply custom mappings
        self._apply_custom_mappings()
        
        # Output directory
        self.output_dir = Path(output_path)
        self.output_dir.mkdir(parents=True, exist_ok=True)
    
    def _apply_custom_mappings(self) -> None:
        """Apply custom type mappings."""
        for dart_type, python_type in self.config.custom_mappings.items():
            from .registry import TypeMapping
            mapping = TypeMapping(dart_type=dart_type, python_type=python_type)
            self.type_registry.register_type_mapping(mapping)
    
    def generate_all(self) -> None:
        """Generate all Python models and supporting files."""
        print(f"Starting code generation from {self.config.dart_package_path}")
        
        # Parse Dart classes
        dart_classes = self.parser.parse_all_blocks()
        print(f"Parsed {len(dart_classes)} Dart classes")
        
        # Filter and process classes
        processable_classes = [cls for cls in dart_classes if self._should_process_class(cls)]
        print(f"Processing {len(processable_classes)} classes")
        
        # Generate base classes
        self._generate_base_file()
        
        # Generate model classes
        generated_classes = []
        class_identifiers = []
        
        for dart_class in processable_classes:
            python_code = self._generate_python_class(dart_class)
            if python_code:
                generated_classes.append(python_code)
                if dart_class.identifier:
                    class_identifiers.append((dart_class.name, dart_class.identifier))
        
        # Generate main models file
        self._generate_models_file(generated_classes, class_identifiers)
        
        # Generate __init__.py
        class_names = [cls.name for cls in processable_classes if not cls.is_abstract]
        self._generate_init_file(class_names)
        
        # Generate adapter if enabled
        if self.config.include_adapter:
            self._generate_adapter_file()
        
        # Generate CLI tool
        self._generate_cli_tool()
        
        print(f"✅ Generated {len(generated_classes)} Python models in {self.output_dir}")
        print(f"📁 Output structure:")
        for file_path in self.output_dir.rglob("*.py"):
            print(f"   {file_path.relative_to(self.output_dir)}")
    
    def _should_process_class(self, dart_class: DartClass) -> bool:
        """Determine if a Dart class should be processed."""
        # Skip abstract classes without concrete implementation
        if dart_class.is_abstract and not dart_class.fields:
            return False
            
        # Skip utility classes
        if dart_class.name in ['UnknownBlock', 'NewsBlocksConverter', 'BlockActionConverter']:
            return False
            
        # Skip if no identifier and no meaningful fields
        if not dart_class.identifier and len(dart_class.fields) < 2:
            return False
            
        return True
    
    def _generate_python_class(self, dart_class: DartClass) -> Optional[str]:
        """Generate Python class code from Dart class."""
        if dart_class.is_abstract:
            return None
            
        # Determine base class
        base_class = self._determine_base_class(dart_class)
        
        # Process fields
        fields = self._process_fields(dart_class.fields)
        
        # Get required imports for this class
        class_imports = self._get_class_imports(dart_class)
        
        # Create template context
        context = TemplateContext(
            class_name=dart_class.name,
            fields=fields,
            imports=class_imports,
            base_class=base_class,
            identifier=dart_class.identifier,
            extends=dart_class.extends,
            implements=dart_class.implements or []
        )
        
        return self.template_engine.render_model_class(context)
    
    def _determine_base_class(self, dart_class: DartClass) -> str:
        """Determine appropriate base class for Python model."""
        # Check config overrides
        if self.config.base_class_override:
            override = self.config.base_class_override.get(dart_class.name)
            if override:
                return override
        
        # Check Dart inheritance
        if dart_class.extends == "PostBlock":
            return "PostBlock"
        elif dart_class.implements and "NewsBlock" in dart_class.implements:
            return "NewsBlock"
        elif "Block" in dart_class.name:
            return "NewsBlock"
        else:
            return "NewsBlock"
    
    def _process_fields(self, dart_fields: List[DartField]) -> List[Dict[str, Any]]:
        """Process Dart fields into Python field definitions."""
        processed_fields = []
        
        for field in dart_fields:
            # Skip type field as it's handled by base class
            if field.name == 'type':
                continue
            
            # Map type
            python_type = self.type_registry.map_dart_type(field.type)
            
            # Determine JSON key
            json_key = field.json_key or self.naming.to_snake_case(field.name)
            
            # Determine default value
            default_value = self._determine_default_value(field)
            
            # Get validators if validation is enabled
            validators = []
            if self.config.include_validation:
                validators.extend(self.validation_registry.get_field_validators(field.name))
                validators.extend(self.validation_registry.get_type_validators(python_type))
            
            processed_fields.append({
                'name': field.name,
                'type': python_type,
                'json_key': json_key,
                'default': default_value,
                'description': self._generate_field_description(field),
                'validators': validators
            })
        
        return processed_fields
    
    def _determine_default_value(self, field: DartField) -> str:
        """Determine default value for field."""
        if field.default_value:
            return self.type_registry.convert_dart_default(field.default_value)
        elif field.is_optional:
            return "None"
        else:
            return "..."
    
    def _generate_field_description(self, field: DartField) -> str:
        """Generate description for field."""
        type_desc = field.type.replace('<', ' of ').replace('>', '').replace('?', ' (optional)')
        return f"{field.name.replace('_', ' ').title()} - {type_desc}"
    
    def _get_class_imports(self, dart_class: DartClass) -> List[str]:
        """Get required imports for a specific class."""
        imports = set()
        
        for field in dart_class.fields:
            python_type = self.type_registry.map_dart_type(field.type)
            if 'List[' in python_type:
                imports.add("from typing import List")
            if 'Dict[' in python_type:
                imports.add("from typing import Dict")
            if 'Optional[' in python_type:
                imports.add("from typing import Optional")
            if 'datetime' in python_type:
                imports.add("from datetime import datetime")
        
        return sorted(list(imports))
    
    def _generate_base_file(self) -> None:
        """Generate base.py file with base classes and enums."""
        base_content = self.template_engine.render_base_model()
        
        with open(self.output_dir / "base.py", "w", encoding="utf-8") as f:
            f.write(base_content)
        
        print("✅ Generated base.py")
    
    def _generate_models_file(self, classes: List[str], class_identifiers: List[tuple]) -> None:
        """Generate main models.py file."""
        # Get all required imports
        all_imports = self.type_registry.get_required_imports()
        
        models_content = self.template_engine.render_models_file(
            classes=classes,
            imports=all_imports,
            class_identifiers=class_identifiers,
            generation_timestamp=datetime.now().isoformat()
        )
        
        with open(self.output_dir / "models.py", "w", encoding="utf-8") as f:
            f.write(models_content)
        
        print("✅ Generated models.py")
    
    def _generate_init_file(self, class_names: List[str]) -> None:
        """Generate __init__.py file."""
        init_content = self.template_engine.render_init_file(
            class_names=class_names,
            version=self.config.version
        )
        
        with open(self.output_dir / "__init__.py", "w", encoding="utf-8") as f:
            f.write(init_content)
        
        print("✅ Generated __init__.py")
    
    def _generate_adapter_file(self) -> None:
        """Generate adapter.py file for integration."""
        adapter_content = self.template_engine.render_adapter()
        
        with open(self.output_dir / "adapter.py", "w", encoding="utf-8") as f:
            f.write(adapter_content)
        
        print("✅ Generated adapter.py")
    
    def _generate_cli_tool(self) -> None:
        """Generate CLI tool for running code generation."""
        cli_content = f'''#!/usr/bin/env python3
"""CLI tool for generating news blocks models."""

import argparse
import sys
from pathlib import Path

from .codegen import CodeGenerator


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description="Generate Python models from Dart news_blocks"
    )
    parser.add_argument(
        "dart_package_path",
        help="Path to Dart news_blocks package"
    )
    parser.add_argument(
        "output_path", 
        help="Output directory for generated Python models"
    )
    parser.add_argument(
        "--template-dir",
        help="Custom template directory"
    )
    parser.add_argument(
        "--version",
        default="1.0.0",
        help="Version for generated package"
    )
    
    args = parser.parse_args()
    
    try:
        generator = CodeGenerator(
            dart_package_path=args.dart_package_path,
            output_path=args.output_path,
            template_dir=args.template_dir
        )
        generator.config.version = args.version
        generator.generate_all()
        
        print("🎉 Code generation completed successfully!")
        
    except Exception as e:
        print(f"❌ Error: {{e}}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
'''
        
        with open(self.output_dir / "cli.py", "w", encoding="utf-8") as f:
            f.write(cli_content)
        
        print("✅ Generated cli.py")


# Convenience function for external usage
def generate_news_blocks(
    dart_package_path: str,
    output_path: str,
    **kwargs
) -> None:
    """
    Convenience function for generating news blocks models.
    
    Args:
        dart_package_path: Path to Dart news_blocks package
        output_path: Output directory
        **kwargs: Additional configuration options
    """
    generator = CodeGenerator(
        dart_package_path=dart_package_path,
        output_path=output_path,
        **kwargs
    )
    generator.generate_all()


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 3:
        print("Usage: python codegen.py <dart_package_path> <output_path>")
        sys.exit(1)
    
    generate_news_blocks(sys.argv[1], sys.argv[2]) 