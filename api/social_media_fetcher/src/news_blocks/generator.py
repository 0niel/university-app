"""Generator for Python news_blocks models from Dart definitions."""

import os
from typing import Dict, List, Optional, Set
from datetime import datetime
from pathlib import Path

from .dart_parser import DartNewsBlockParser, DartClass, DartField


class PythonModelGenerator:
    """Generates Python models from Dart news_blocks definitions."""
    
    # Mapping from Dart types to Python types
    TYPE_MAPPING = {
        'String': 'str',
        'int': 'int', 
        'double': 'float',
        'bool': 'bool',
        'DateTime': 'datetime',
        'List<String>': 'List[str]',
        'List<NewsBlock>': 'List[NewsBlock]',
        'List<PostGridTileBlock>': 'List[PostGridTileBlock]',
        'List<SlideBlock>': 'List[SlideBlock]',
        'BlockAction': 'BlockAction',
        'Category': 'Category',
        'SlideshowBlock': 'SlideshowBlock',
        'PostSmallBlock': 'PostSmallBlock',
        'BannerSize': 'BannerSize',
        'Spacing': 'Spacing',
        'TextCaptionColor': 'TextCaptionColor',
        'BlockActionType': 'BlockActionType',
    }
    
    def __init__(self, dart_package_path: str, output_dir: str):
        """Initialize generator."""
        self.dart_package_path = dart_package_path
        self.output_dir = Path(output_dir)
        self.parser = DartNewsBlockParser(dart_package_path)
        
    def generate_all_models(self) -> None:
        """Generate all Python models from Dart news_blocks."""
        # Parse all Dart classes
        dart_classes = self.parser.parse_all_blocks()
        
        # Create output directory
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate base classes first
        self._generate_base_classes()
        
        # Generate models
        generated_classes = []
        for dart_class in dart_classes:
            if not dart_class.is_abstract:
                python_code = self._generate_model_class(dart_class)
                if python_code:
                    generated_classes.append((dart_class.name, python_code))
        
        # Generate models.py file
        self._generate_models_file(generated_classes)
        
        # Generate __init__.py
        self._generate_init_file([cls_name for cls_name, _ in generated_classes])
        
        print(f"Generated {len(generated_classes)} Python models in {self.output_dir}")
    
    def _generate_base_classes(self) -> None:
        """Generate base classes and enums."""
        base_code = '''"""Base classes and enums for news blocks."""

from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, List, Optional, Union
from enum import Enum

from pydantic import BaseModel, Field


class NewsBlock(BaseModel, ABC):
    """Base class for all news blocks."""
    
    type: str = Field(..., description="Block type identifier")
    
    @abstractmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        pass
    
    class Config:
        """Pydantic configuration."""
        json_encoders = {
            datetime: lambda v: v.isoformat()
        }


class PostBlock(NewsBlock):
    """Base class for post blocks."""
    
    id: str = Field(..., description="Post identifier")
    category_id: str = Field(..., description="Category identifier")
    author: str = Field(..., description="Post author")
    published_at: datetime = Field(..., description="Publication date")
    title: str = Field(..., description="Post title")
    image_url: Optional[str] = Field(None, description="Image URL")
    description: Optional[str] = Field(None, description="Post description")
    action: Optional[Dict[str, Any]] = Field(None, description="Block action")
    is_content_overlaid: bool = Field(False, description="Content overlay flag")


class BannerSize(str, Enum):
    """Banner ad sizes."""
    NORMAL = "normal"
    LARGE = "large"
    EXTRA_LARGE = "extraLarge"
    ANCHORED_ADAPTIVE = "anchoredAdaptive"


class Spacing(str, Enum):
    """Spacer block spacing options."""
    EXTRA_SMALL = "extraSmall"
    SMALL = "small"
    MEDIUM = "medium"
    LARGE = "large"
    VERY_LARGE = "veryLarge"
    EXTRA_LARGE = "extraLarge"


class TextCaptionColor(str, Enum):
    """Text caption color options."""
    NORMAL = "normal"
    LIGHT = "light"


class BlockActionType(str, Enum):
    """Block action types."""
    NAVIGATION = "navigation"
    UNKNOWN = "unknown"


class Category(BaseModel):
    """News category model."""
    id: str
    name: str


class BlockAction(BaseModel):
    """Base block action model."""
    type: str
    action_type: BlockActionType

'''
        
        with open(self.output_dir / "base.py", "w", encoding="utf-8") as f:
            f.write(base_code)
    
    def _generate_model_class(self, dart_class: DartClass) -> Optional[str]:
        """Generate Python class code from Dart class."""
        if not dart_class.fields and not dart_class.identifier:
            return None
            
        # Determine base class
        base_class = "NewsBlock"
        if dart_class.extends == "PostBlock":
            base_class = "PostBlock"
        elif dart_class.implements and "NewsBlock" in dart_class.implements:
            base_class = "NewsBlock"
            
        # Generate class definition
        lines = []
        lines.append(f'class {dart_class.name}({base_class}):')
        lines.append(f'    """Python model for {dart_class.name}."""')
        lines.append('')
        
        # Add identifier constant
        if dart_class.identifier:
            lines.append(f'    IDENTIFIER = "{dart_class.identifier}"')
            lines.append('')
        
        # Generate fields
        field_lines = []
        for field in dart_class.fields:
            if field.name == 'type':  # Skip type field as it's in base class
                continue
                
            python_type = self._map_dart_type_to_python(field.type)
            if field.is_optional:
                python_type = f"Optional[{python_type}]"
                
            json_key = field.json_key or self._snake_case(field.name)
            default = "None" if field.is_optional else "..."
            
            if field.default_value:
                default = self._convert_dart_default(field.default_value)
            
            field_line = f'    {field.name}: {python_type} = Field({default}, alias="{json_key}")'
            field_lines.append(field_line)
        
        if field_lines:
            lines.extend(field_lines)
            lines.append('')
        
        # Add identifier method
        if dart_class.identifier:
            lines.append('    @classmethod')
            lines.append('    def get_identifier(cls) -> str:')
            lines.append('        """Get the block type identifier."""')
            lines.append(f'        return cls.IDENTIFIER')
            lines.append('')
        
        # Add model config
        lines.append('    class Config:')
        lines.append('        """Pydantic model configuration."""')
        lines.append('        allow_population_by_field_name = True')
        
        return '\n'.join(lines)
    
    def _map_dart_type_to_python(self, dart_type: str) -> str:
        """Map Dart type to Python type."""
        # Handle generic types
        if dart_type.startswith('List<') and dart_type.endswith('>'):
            inner_type = dart_type[5:-1]
            python_inner = self._map_dart_type_to_python(inner_type)
            return f"List[{python_inner}]"
        
        return self.TYPE_MAPPING.get(dart_type, dart_type)
    
    def _snake_case(self, camel_case: str) -> str:
        """Convert camelCase to snake_case."""
        import re
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', camel_case)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    def _convert_dart_default(self, dart_default: str) -> str:
        """Convert Dart default value to Python."""
        if dart_default == "true":
            return "True"
        elif dart_default == "false":
            return "False"
        elif dart_default == "null":
            return "None"
        elif dart_default.startswith('"') and dart_default.endswith('"'):
            return dart_default
        else:
            return f'"{dart_default}"'
    
    def _generate_models_file(self, generated_classes: List[tuple]) -> None:
        """Generate the main models.py file."""
        lines = []
        lines.append('"""Generated Python models for news blocks."""')
        lines.append('')
        lines.append('# This file is auto-generated. Do not edit manually.')
        lines.append(f'# Generated on: {datetime.now().isoformat()}')
        lines.append('')
        lines.append('from datetime import datetime')
        lines.append('from typing import Any, Dict, List, Optional')
        lines.append('from pydantic import BaseModel, Field')
        lines.append('')
        lines.append('from .base import NewsBlock, PostBlock, BannerSize, Spacing, TextCaptionColor, Category, BlockAction')
        lines.append('')
        lines.append('')
        
        # Add all generated classes
        for class_name, class_code in generated_classes:
            lines.append(class_code)
            lines.append('')
            lines.append('')
        
        # Add factory function
        lines.extend(self._generate_factory_function(generated_classes))
        
        with open(self.output_dir / "models.py", "w", encoding="utf-8") as f:
            f.write('\n'.join(lines))
    
    def _generate_factory_function(self, generated_classes: List[tuple]) -> List[str]:
        """Generate factory function for creating news blocks from JSON."""
        lines = []
        lines.append('def create_news_block_from_json(data: Dict[str, Any]) -> NewsBlock:')
        lines.append('    """Create a news block instance from JSON data."""')
        lines.append('    block_type = data.get("type")')
        lines.append('    ')
        
        for class_name, _ in generated_classes:
            lines.append(f'    if block_type == {class_name}.IDENTIFIER:')
            lines.append(f'        return {class_name}(**data)')
        
        lines.append('    ')
        lines.append('    # Return unknown block for unrecognized types')
        lines.append('    from .base import UnknownBlock')
        lines.append('    return UnknownBlock(type=block_type or "__unknown__")')
        
        return lines
    
    def _generate_init_file(self, class_names: List[str]) -> None:
        """Generate __init__.py file."""
        lines = []
        lines.append('"""Auto-generated news blocks package."""')
        lines.append('')
        lines.append('# This file is auto-generated. Do not edit manually.')
        lines.append('')
        lines.append('from .base import *')
        lines.append('from .models import *')
        lines.append('')
        lines.append('__all__ = [')
        lines.append('    "NewsBlock",')
        lines.append('    "PostBlock",')
        lines.append('    "BannerSize",')
        lines.append('    "Spacing",')
        lines.append('    "TextCaptionColor",')
        lines.append('    "Category",')
        lines.append('    "BlockAction",')
        lines.append('    "create_news_block_from_json",')
        
        for class_name in sorted(class_names):
            lines.append(f'    "{class_name}",')
        
        lines.append(']')
        
        # Update main __init__.py
        with open(self.output_dir / "__init__.py", "w", encoding="utf-8") as f:
            f.write('\n'.join(lines))


def generate_news_blocks_models(dart_package_path: str, output_dir: str) -> None:
    """Main function to generate Python models from Dart news_blocks."""
    generator = PythonModelGenerator(dart_package_path, output_dir)
    generator.generate_all_models()


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) != 3:
        print("Usage: python generator.py <dart_package_path> <output_dir>")
        sys.exit(1)
    
    dart_path = sys.argv[1]
    output_path = sys.argv[2]
    
    generate_news_blocks_models(dart_path, output_path) 