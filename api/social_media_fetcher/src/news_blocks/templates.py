"""Unified template engine for code generation."""

from typing import Dict, Any, List, Optional
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, BaseLoader, Template
from dataclasses import dataclass, asdict
import os


@dataclass
class TemplateContext:
    """Context data for template rendering."""
    class_name: str
    fields: List[Dict[str, Any]]
    imports: List[str]
    base_class: str = "NewsBlock"
    identifier: Optional[str] = None
    extends: Optional[str] = None
    implements: List[str] = None
    metadata: Dict[str, Any] = None
    
    def __post_init__(self):
        if self.implements is None:
            self.implements = []
        if self.metadata is None:
            self.metadata = {}


class TemplateEngine:
    """Unified template engine for generating code."""
    
    # Default templates
    DEFAULT_TEMPLATES = {
        'base_model': '''"""Base classes for news blocks."""

from abc import ABC, abstractmethod
from datetime import datetime
from typing import Any, Dict, List, Optional, ClassVar
from enum import Enum

from pydantic import BaseModel, Field, ConfigDict


class NewsBlock(BaseModel, ABC):
    """Base class for all news blocks."""
    
    model_config = ConfigDict(
        populate_by_name=True,
        use_enum_values=True
    )
    
    type: str = Field(..., description="Block type identifier")
    
    @classmethod
    @abstractmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        pass


class PostBlock(NewsBlock, ABC):
    """Base class for post blocks."""
    
    id: str = Field(..., description="Post ID")
    category_id: str = Field(..., alias="category_id", description="Category ID")
    author: str = Field(..., description="Author name")
    published_at: datetime = Field(..., alias="published_at", description="Publication date")
    title: str = Field(..., description="Post title")
    image_url: Optional[str] = Field(None, alias="image_url", description="Image URL")
    description: Optional[str] = Field(None, description="Post description")
    action: Optional[Dict[str, Any]] = Field(None, description="Block action")
    is_content_overlaid: bool = Field(False, alias="is_content_overlaid", description="Content overlay flag")


# Enums from Dart
class BannerSize(str, Enum):
    """Banner size enumeration."""
    NORMAL = "normal"
    LARGE = "large"
    EXTRA_LARGE = "extraLarge"
    ANCHORED_ADAPTIVE = "anchoredAdaptive"


class Spacing(str, Enum):
    """Spacing enumeration."""
    EXTRA_SMALL = "extraSmall"
    SMALL = "small"
    MEDIUM = "medium"
    LARGE = "large"
    VERY_LARGE = "veryLarge"
    EXTRA_LARGE = "extraLarge"


class TextCaptionColor(str, Enum):
    """Text caption color enumeration."""
    NORMAL = "normal"
    LIGHT = "light"


class BlockActionType(str, Enum):
    """Block action type enumeration."""
    NAVIGATION = "navigation"
    UNKNOWN = "unknown"


# Block action classes
class BlockAction(BaseModel, ABC):
    """Base class for block actions."""
    
    model_config = ConfigDict(populate_by_name=True)
    
    type: str = Field(..., description="Action type")
    action_type: BlockActionType = Field(..., description="Action type enum")


class UnknownBlock(NewsBlock):
    """Unknown block type."""
    
    IDENTIFIER: ClassVar[str] = "__unknown__"
    
    type: str = Field(default="__unknown__", description="Block type")
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
''',

        'model_class': '''class {{ class_name }}({{ base_class }}):
    """Python model for {{ class_name }}."""
    
    {% if identifier -%}
    IDENTIFIER: ClassVar[str] = "{{ identifier }}"
    
    {% endif -%}
    {% for field in fields -%}
    {{ field.name }}: {{ field.type }} = Field({{ field.default }}, alias="{{ field.json_key }}"{% if field.description %}, description="{{ field.description }}"{% endif %})
    {% endfor %}
    
    {% if identifier -%}
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    {% endif -%}
    model_config = ConfigDict(populate_by_name=True)
''',

        'models_file': '''"""Generated Python models for news blocks."""

# This file is auto-generated. Do not edit manually.
# Generated on: {{ generation_timestamp }}

from __future__ import annotations

from datetime import datetime
from typing import ClassVar
{% for import_line in imports -%}
{{ import_line }}
{% endfor %}

from .base import *


{% for class_code in classes -%}
{{ class_code }}


{% endfor -%}

# Factory function
def create_news_block_from_json(data: Dict[str, Any]) -> NewsBlock:
    """Create a news block instance from JSON data."""
    block_type = data.get("type")
    
    {% for class_name, identifier in class_identifiers -%}
    if block_type == "{{ identifier }}":
        return {{ class_name }}(**data)
    {% endfor %}
    
    # Return unknown block for unrecognized types
    return UnknownBlock(type=block_type or "__unknown__")


# Registry mapping
BLOCK_TYPE_REGISTRY = {
    {% for class_name, identifier in class_identifiers -%}
    "{{ identifier }}": {{ class_name }},
    {% endfor %}
}
''',

        'init_file': '''"""Auto-generated news blocks package."""

# This file is auto-generated. Do not edit manually.

from .base import *
from .models import *

__version__ = "{{ version }}"

__all__ = [
    # Base classes
    "NewsBlock",
    "PostBlock",
    "UnknownBlock",
    
    # Enums
    "BannerSize",
    "Spacing", 
    "TextCaptionColor",
    "BlockActionType",
    
    # Utility classes
    "Category",
    "BlockAction",
    
    # Factory functions
    "create_news_block_from_json",
    "BLOCK_TYPE_REGISTRY",
    
    # Generated models
    {% for class_name in class_names -%}
    "{{ class_name }}",
    {% endfor %}
]
''',

        'adapter': '''"""News blocks adapter for social media fetcher integration."""

from typing import List, Dict, Any, Optional
from datetime import datetime

from .models import NewsBlock, create_news_block_from_json


class NewsBlockAdapter:
    """Adapter for converting social media posts to news blocks."""
    
    @staticmethod
    def news_blocks_to_json(blocks: List[NewsBlock]) -> List[Dict[str, Any]]:
        """Convert news blocks to JSON format."""
        return [block.dict(by_alias=True) for block in blocks]
    
    @staticmethod
    def json_to_news_blocks(json_data: List[Dict[str, Any]]) -> List[NewsBlock]:
        """Convert JSON data to news blocks."""
        return [create_news_block_from_json(item) for item in json_data]
'''
    }
    
    def __init__(self, template_dir: Optional[str] = None):
        """Initialize template engine."""
        if template_dir and Path(template_dir).exists():
            self.env = Environment(loader=FileSystemLoader(template_dir))
            self.custom_templates = True
        else:
            self.env = Environment(loader=BaseLoader())
            self.custom_templates = False
        
        # Register filters
        self.env.filters['snake_case'] = self._snake_case_filter
        self.env.filters['pascal_case'] = self._pascal_case_filter
        
    def render_template(self, template_name: str, context: Dict[str, Any]) -> str:
        """Render template with context."""
        if self.custom_templates:
            template = self.env.get_template(f"{template_name}.j2")
        else:
            template_source = self.DEFAULT_TEMPLATES.get(template_name)
            if not template_source:
                raise ValueError(f"Template '{template_name}' not found")
            template = self.env.from_string(template_source)
        
        return template.render(**context)
    
    def render_model_class(self, context: TemplateContext) -> str:
        """Render a model class."""
        return self.render_template('model_class', asdict(context))
    
    def render_base_model(self) -> str:
        """Render base model file."""
        return self.render_template('base_model', {})
    
    def render_models_file(self, 
                          classes: List[str], 
                          imports: List[str],
                          class_identifiers: List[tuple],
                          generation_timestamp: str) -> str:
        """Render main models file."""
        return self.render_template('models_file', {
            'classes': classes,
            'imports': imports,
            'class_identifiers': class_identifiers,
            'generation_timestamp': generation_timestamp
        })
    
    def render_init_file(self, class_names: List[str], version: str = "1.0.0") -> str:
        """Render __init__.py file."""
        return self.render_template('init_file', {
            'class_names': sorted(class_names),
            'version': version
        })
    
    def render_adapter(self) -> str:
        """Render adapter file."""
        return self.render_template('adapter', {})
    
    @staticmethod
    def _snake_case_filter(value: str) -> str:
        """Jinja2 filter for snake_case conversion."""
        import re
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', value)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    @staticmethod
    def _pascal_case_filter(value: str) -> str:
        """Jinja2 filter for PascalCase conversion."""
        return ''.join(word.capitalize() for word in value.split('_'))

    def _get_default_model_template(self) -> str:
        """Get default template for model classes."""
        return '''
class {{ class_name }}({{ base_class }}):
    """Python model for {{ class_name }}."""
    
    {% if identifier %}IDENTIFIER: ClassVar[str] = "{{ identifier }}"{% endif %}
    
    {% for field in fields %}
    {{ field.name }}: {{ field.python_type }} = Field(
        {%- if field.is_optional %}None{% else %}...{% endif %},
        {%- if field.json_key %} alias="{{ field.json_key }}",{% endif %}
        description="{{ field.name | title }} - {{ field.dart_type }}"
    )
    {% endfor %}
    
    {% if identifier %}
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    {% endif %}
    
    model_config = ConfigDict(populate_by_name=True)
''' 