#!/usr/bin/env python3
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
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
