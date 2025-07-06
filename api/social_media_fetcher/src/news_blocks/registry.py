"""Unified type registry for Dart to Python code generation."""

from typing import Dict, Any, Optional, Callable, List, Set
from dataclasses import dataclass, field
from abc import ABC, abstractmethod
import re


@dataclass
class TypeMapping:
    """Represents a type mapping from Dart to Python."""
    dart_type: str
    python_type: str
    import_statement: Optional[str] = None
    converter: Optional[Callable] = None
    is_generic: bool = False
    generic_pattern: Optional[str] = None


@dataclass 
class FieldMapping:
    """Represents field-specific mapping rules."""
    field_name: str
    dart_type: str
    python_type: str
    json_key: Optional[str] = None
    default_value: Optional[Any] = None
    validators: List[str] = field(default_factory=list)
    description: Optional[str] = None


class TypeRegistry:
    """Unified registry for type mappings and conversion rules."""
    
    def __init__(self):
        """Initialize with default mappings."""
        self._type_mappings: Dict[str, TypeMapping] = {}
        self._field_mappings: Dict[str, FieldMapping] = {}
        self._import_statements: Set[str] = set()
        self._custom_converters: Dict[str, Callable] = {}
        
        self._register_default_mappings()
    
    def _register_default_mappings(self) -> None:
        """Register default Dart to Python type mappings."""
        self._setup_type_mappings()
    
    def _setup_type_mappings(self):
        """Setup type mappings from Dart to Python."""
        # Basic types
        basic_mappings = {
            'String': 'str',
            'int': 'int', 
            'double': 'float',
            'bool': 'bool',
            'DateTime': 'datetime',
            'dynamic': 'Any',
            'Object': 'Any',
            'void': 'None',
            'Map<String, dynamic>': 'Dict[str, Any]',
            'Map<String, Object?>': 'Dict[str, Any]',
            'List<dynamic>': 'List[Any]',
        }
        
        for dart_type, python_type in basic_mappings.items():
            import_stmt = None
            if python_type == 'datetime':
                import_stmt = "from datetime import datetime"
            elif 'Dict' in python_type or 'List' in python_type or 'Any' in python_type:
                import_stmt = "from typing import Dict, List, Any"
            
            mapping = TypeMapping(
                dart_type=dart_type,
                python_type=python_type,
                import_statement=import_stmt
            )
            self._type_mappings[dart_type] = mapping
        
        # Generic List types
        for dart_type, mapping in list(self._type_mappings.items()):
            if not dart_type.startswith('List<'):
                list_type = f'List<{dart_type}>'
                list_mapping = TypeMapping(
                    dart_type=list_type,
                    python_type=f'List[{mapping.python_type}]',
                    import_statement="from typing import List"
                )
                self._type_mappings[list_type] = list_mapping
        
        # Optional types
        for dart_type, mapping in list(self._type_mappings.items()):
            if not dart_type.endswith('?'):
                optional_type = f'{dart_type}?'
                optional_mapping = TypeMapping(
                    dart_type=optional_type,
                    python_type=f'Optional[{mapping.python_type}]',
                    import_statement="from typing import Optional"
                )
                self._type_mappings[optional_type] = optional_mapping
    
    def register_type_mapping(self, mapping: TypeMapping) -> None:
        """Register a type mapping."""
        self._type_mappings[mapping.dart_type] = mapping
        if mapping.import_statement:
            self._import_statements.add(mapping.import_statement)
    
    def register_field_mapping(self, mapping: FieldMapping) -> None:
        """Register field-specific mapping."""
        key = f"{mapping.field_name}:{mapping.dart_type}"
        self._field_mappings[key] = mapping
    
    def register_converter(self, dart_type: str, converter: Callable) -> None:
        """Register custom converter function."""
        self._custom_converters[dart_type] = converter
    
    def map_dart_type(self, dart_type: str) -> str:
        """Map Dart type to Python type."""
        # Clean the type
        clean_type = dart_type.strip().rstrip('?')
        is_optional = dart_type.endswith('?')
        
        # Special handling for List types
        if clean_type.startswith('List<') and clean_type.endswith('>'):
            inner_type = clean_type[5:-1].strip()  # Extract type between List< and >
            mapped_inner = self.map_dart_type(inner_type)
            python_type = f"List[{mapped_inner}]"
            self._import_statements.add("from typing import List")
        # Direct mapping
        elif clean_type in self._type_mappings:
            python_type = self._type_mappings[clean_type].python_type
        else:
            # Try generic mappings
            python_type = self._try_generic_mapping(clean_type)
            if not python_type:
                python_type = clean_type  # Fallback to original type
        
        # Apply optional wrapper
        if is_optional and not python_type.startswith('Optional['):
            self._import_statements.add("from typing import Optional")
            python_type = f"Optional[{python_type}]"
        
        return python_type
    
    def _try_generic_mapping(self, dart_type: str) -> Optional[str]:
        """Try to map using generic type patterns."""
        for mapping in self._type_mappings.values():
            if not mapping.is_generic or not mapping.generic_pattern:
                continue
                
            match = re.match(mapping.generic_pattern, dart_type)
            if match:
                python_template = mapping.python_type
                for i, group in enumerate(match.groups(), 1):
                    mapped_group = self.map_dart_type(group.strip())
                    python_template = python_template.replace(f"{{{group}}}", mapped_group)
                    python_template = python_template.replace(f"{{T}}", mapped_group)
                    if i == 1:
                        python_template = python_template.replace(f"{{K}}", mapped_group)
                    elif i == 2:
                        python_template = python_template.replace(f"{{V}}", mapped_group)
                
                if mapping.import_statement:
                    self._import_statements.add(mapping.import_statement)
                
                return python_template
        
        return None
    
    def get_field_mapping(self, field_name: str, dart_type: str) -> Optional[FieldMapping]:
        """Get field-specific mapping if exists."""
        key = f"{field_name}:{dart_type}"
        return self._field_mappings.get(key)
    
    def get_required_imports(self) -> List[str]:
        """Get all required import statements."""
        return sorted(list(self._import_statements))
    
    def convert_value(self, dart_type: str, value: Any) -> Any:
        """Convert value using registered converter."""
        if dart_type in self._custom_converters:
            return self._custom_converters[dart_type](value)
        return value
    
    def snake_case(self, camel_case: str) -> str:
        """Convert camelCase to snake_case."""
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', camel_case)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    def convert_dart_default(self, dart_value: str) -> str:
        """Convert Dart default value to Python."""
        if dart_value == "true":
            return "True"
        elif dart_value == "false":
            return "False"
        elif dart_value == "null":
            return "None"
        elif dart_value.startswith('"') and dart_value.endswith('"'):
            return dart_value
        elif dart_value.startswith("'") and dart_value.endswith("'"):
            return dart_value.replace("'", '"')
        elif dart_value.isdigit() or (dart_value.startswith('-') and dart_value[1:].isdigit()):
            return dart_value
        elif '.' in dart_value and dart_value.replace('.', '').replace('-', '').isdigit():
            return dart_value
        else:
            return f'"{dart_value}"'


class NamingConverter:
    """Unified naming convention converter."""
    
    @staticmethod
    def to_snake_case(camel_case: str) -> str:
        """Convert camelCase to snake_case."""
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', camel_case)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    @staticmethod
    def to_pascal_case(snake_case: str) -> str:
        """Convert snake_case to PascalCase."""
        return ''.join(word.capitalize() for word in snake_case.split('_'))
    
    @staticmethod
    def to_camel_case(snake_case: str) -> str:
        """Convert snake_case to camelCase."""
        words = snake_case.split('_')
        return words[0] + ''.join(word.capitalize() for word in words[1:])


class ValidationRegistry:
    """Registry for field validation rules."""
    
    def __init__(self):
        """Initialize validation registry."""
        self._validators: Dict[str, List[str]] = {}
        self._type_validators: Dict[str, List[str]] = {}
    
    def register_field_validator(self, field_name: str, validator: str) -> None:
        """Register validator for specific field."""
        if field_name not in self._validators:
            self._validators[field_name] = []
        self._validators[field_name].append(validator)
    
    def register_type_validator(self, type_name: str, validator: str) -> None:
        """Register validator for specific type."""
        if type_name not in self._type_validators:
            self._type_validators[type_name] = []
        self._type_validators[type_name].append(validator)
    
    def get_field_validators(self, field_name: str) -> List[str]:
        """Get validators for field."""
        return self._validators.get(field_name, [])
    
    def get_type_validators(self, type_name: str) -> List[str]:
        """Get validators for type."""
        return self._type_validators.get(type_name, []) 