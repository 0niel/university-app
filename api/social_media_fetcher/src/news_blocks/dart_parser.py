"""Parser for Dart news_blocks files to extract model definitions."""

import re
import os
from typing import Dict, List, Optional, Any
from dataclasses import dataclass
from pathlib import Path


@dataclass
class DartField:
    """Represents a field in a Dart class."""
    name: str
    type: str
    is_optional: bool = False
    is_final: bool = False
    json_key: Optional[str] = None
    default_value: Optional[str] = None


@dataclass
class DartClass:
    """Represents a Dart class definition."""
    name: str
    fields: List[DartField]
    extends: Optional[str] = None
    implements: List[str] = None
    identifier: Optional[str] = None
    is_abstract: bool = False


class DartNewsBlockParser:
    """Parser for Dart news_blocks to extract class definitions."""
    
    def __init__(self, dart_package_path: str):
        """Initialize parser with path to Dart package."""
        self.dart_package_path = Path(dart_package_path)
        self.lib_path = self.dart_package_path / "lib" / "src"
        
    def parse_all_blocks(self) -> List[DartClass]:
        """Parse all news block classes from Dart files."""
        classes = []
        
        if not self.lib_path.exists():
            raise FileNotFoundError(f"Dart package path not found: {self.lib_path}")
            
        for dart_file in self.lib_path.glob("*.dart"):
            if dart_file.name.endswith("_test.dart") or dart_file.name.startswith("."):
                continue
                
            try:
                parsed_class = self._parse_dart_file(dart_file)
                if parsed_class:
                    classes.append(parsed_class)
            except Exception as e:
                print(f"Warning: Failed to parse {dart_file}: {e}")
                
        return classes
    
    def _parse_dart_file(self, file_path: Path) -> Optional[DartClass]:
        """Parse a single Dart file and extract class definition."""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Remove comments and imports
        content = self._clean_dart_content(content)
        
        # Find class definition
        class_match = re.search(
            r'(?:abstract\s+)?class\s+(\w+)(?:\s+extends\s+(\w+))?(?:\s+(?:with\s+\w+(?:,\s*\w+)*\s+)?implements\s+([\w\s,]+))?\s*\{',
            content,
            re.MULTILINE
        )
        
        if not class_match:
            return None
            
        class_name = class_match.group(1)
        extends = class_match.group(2)
        implements_str = class_match.group(3)
        
        implements = []
        if implements_str:
            implements = [impl.strip() for impl in implements_str.split(',')]
        
        # Extract fields
        fields = self._extract_fields(content)
        
        # Extract identifier constant
        identifier = self._extract_identifier(content)
        
        # Check if abstract
        is_abstract = 'abstract class' in content
        
        return DartClass(
            name=class_name,
            fields=fields,
            extends=extends,
            implements=implements,
            identifier=identifier,
            is_abstract=is_abstract
        )
    
    def _clean_dart_content(self, content: str) -> str:
        """Remove comments and clean up Dart content."""
        # Remove single-line comments
        content = re.sub(r'//.*$', '', content, flags=re.MULTILINE)
        
        # Remove multi-line comments
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        
        # Remove imports and exports
        content = re.sub(r'^(?:import|export|part)\s+.*?;', '', content, flags=re.MULTILINE)
        
        return content
    
    def _extract_fields(self, class_content: str) -> List[DartField]:
        """Extract fields from class content."""
        fields = []
        
        # Pattern for field declarations - only final fields with proper types
        field_pattern = r'final\s+((?:String|int|double|bool|DateTime|List<[^>]+>|Map<[^>]+>|[A-Z][a-zA-Z0-9_]*)\??)\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*;'
        
        for match in re.finditer(field_pattern, class_content, re.MULTILINE):
            field_type = match.group(1).strip()
            field_name = match.group(2).strip()
            
            # Skip certain fields that are not data fields
            if field_name in ['type', 'identifier', 'props'] or field_type in ['const', 'get']:
                continue
            
            # Determine if field is optional
            is_optional = field_type.endswith('?')
            if is_optional:
                field_type = field_type[:-1]  # Remove the ?
            
            fields.append(DartField(
                name=field_name,
                type=field_type,
                is_optional=is_optional,
                is_final=True
            ))
        
        return fields
    
    def _extract_json_key(self, field_declaration: str) -> Optional[str]:
        """Extract JSON key from field annotations."""
        json_key_match = re.search(r'@JsonKey\([^)]*name:\s*[\'"]([^\'"]+)[\'"]', field_declaration)
        if json_key_match:
            return json_key_match.group(1)
        return None
    
    def _extract_identifier(self, content: str) -> Optional[str]:
        """Extract the identifier constant from class."""
        identifier_match = re.search(r'static\s+const\s+identifier\s*=\s*[\'"]([^\'"]+)[\'"]', content)
        if identifier_match:
            return identifier_match.group(1)
        return None 