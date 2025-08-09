#!/usr/bin/env python3
"""
Interactive CLI for generating Python news_blocks models from the Dart package.
"""

import sys
from pathlib import Path

from rich.console import Console
from rich.panel import Panel
from rich.markdown import Markdown
from rich.prompt import Confirm, Prompt

# Make src importable
sys.path.insert(0, str(Path(__file__).parent / "src"))

from src.news_blocks.codegen import CodeGenerator

console = Console()

def print_header() -> None:
    title = "🧩 News Blocks Generator"
    subtitle = "Generate Python models from the Dart news_blocks package"
    console.print(Panel.fit(title, subtitle=subtitle, border_style="bright_blue"))


def ask_options() -> dict:
    script_dir = Path(__file__).parent
    defaults = {
        "dart_path": "../packages/news_blocks",
        "output": "./src/news_blocks",
        "template_dir": "",
        "version": "1.0.0",
        "force": False,
        "test": False,
        "dry_run": False,
        "verbose": False,
    }

    console.print(Panel("Configure generation options", border_style="blue"))

    dart_path = Prompt.ask(
        "Dart package path",
        default=defaults["dart_path"],
        show_default=True,
    )
    output = Prompt.ask(
        "Output directory",
        default=defaults["output"],
        show_default=True,
    )
    template_dir = Prompt.ask(
        "Template directory (optional)",
        default=defaults["template_dir"],
        show_default=True,
    )
    version = Prompt.ask("Version", default=defaults["version"], show_default=True)

    force = Confirm.ask("Force regeneration if exists?", default=defaults["force"])
    test = Confirm.ask("Run tests after generation?", default=defaults["test"])
    dry_run = Confirm.ask("Dry-run (no write)?", default=defaults["dry_run"])
    verbose = Confirm.ask("Verbose output?", default=defaults["verbose"])

    dart_path = Path(dart_path)
    output = Path(output)
    if not dart_path.is_absolute():
        dart_path = (script_dir / dart_path).resolve()
    if not output.is_absolute():
        output = (script_dir / output).resolve()

    template_path = None
    if template_dir.strip():
        p = Path(template_dir)
        template_path = p if p.is_absolute() else (script_dir / p).resolve()

    return {
        "dart_path": dart_path,
        "output": output,
        "template_path": template_path,
        "version": version,
        "force": force,
        "test": test,
        "dry_run": dry_run,
        "verbose": verbose,
    }


def validate_paths(dart_path: Path) -> bool:
    if not dart_path.exists():
        console.print(f"❌ Dart package path does not exist: {dart_path}", style="bold red")
        return False
    dart_src_path = dart_path / "lib" / "src"
    if not dart_src_path.exists():
        console.print(f"❌ Dart source directory not found: {dart_src_path}", style="bold red")
        return False
    return True


def list_dart_files(dart_path: Path) -> None:
    dart_src_path = dart_path / "lib" / "src"
    dart_files = sorted(dart_src_path.glob("*.dart"))
    console.print(f"📄 Found {len(dart_files)} Dart files to process:")
    for f in dart_files:
        console.print(f"  - {f.name}")


def run_tests(output_path: Path, verbose: bool = False) -> bool:
    try:
        import sys as _sys
        _sys.path.insert(0, str(output_path.parent))
        from news_blocks import NewsBlock, create_news_block_from_json, BLOCK_TYPE_REGISTRY  # noqa: F401

        test_data = {
            "type": "__post_large__",
            "id": "test_123",
            "category_id": "technology",
            "author": "Test Author",
            "published_at": "2024-01-01T00:00:00Z",
            "title": "Test Title",
            "image_url": "https://example.com/image.jpg",
        }
        block = create_news_block_from_json(test_data)
        if not hasattr(block, "get_identifier"):
            console.print("❌ Factory function test failed", style="bold red")
            return False
        if len(BLOCK_TYPE_REGISTRY) <= 0:
            console.print("❌ Block registry test failed", style="bold red")
            return False
        console.print("✅ Tests passed", style="bold green")
        return True
    except Exception as e:  # noqa: BLE001
        if verbose:
            console.print(f"❌ Test failed: {e}", style="bold red")
        return False
    finally:
        if str(output_path.parent) in sys.path:
            sys.path.remove(str(output_path.parent))


def generate(opts: dict) -> int:
    dart_path: Path = opts["dart_path"]
    output_path: Path = opts["output"]
    force: bool = opts["force"]
    dry_run: bool = opts["dry_run"]
    do_tests: bool = opts["test"]
    verbose: bool = opts["verbose"]

    console.print(Panel.fit("🚀 Starting generation", border_style="green"))
    console.print(f"📁 Dart package: {dart_path}")
    console.print(f"📁 Output directory: {output_path}")

    if not validate_paths(dart_path):
        return 1

    if dry_run:
        console.print(Markdown("**Dry run** - nothing will be generated."))
        list_dart_files(dart_path)
        return 0

    if output_path.exists() and (output_path / "models.py").exists() and not force:
        console.print(f"ℹ️  Models already exist at {output_path}")
        console.print("💡 Use Force to regenerate or delete the directory.")
        return 0

    try:
        generator = CodeGenerator()
        result = generator.generate_from_dart_package(
            dart_package_path=str(dart_path),
            output_dir=str(output_path),
            force_regenerate=force,
        )
        if not result:
            console.print("❌ Generation failed!", style="bold red")
            return 1

        console.print("✅ Generation completed successfully!", style="bold green")

        if output_path.exists():
            console.print(f"📁 Generated files in {output_path}:")
            for file_path in sorted(output_path.rglob("*.py")):
                size = file_path.stat().st_size
                console.print(f"  📄 {file_path.name} ({size} bytes)")

        if do_tests:
            console.print("\n🧪 Running tests...")
            if not run_tests(output_path, verbose):
                return 1

        console.print("🎉 Done!", style="bold green")
        console.print("Import example:")
        console.print("from src.news_blocks import NewsBlock, PostLargeBlock, create_news_block_from_json", style="cyan")
        return 0
    except Exception as e:  # noqa: BLE001
        console.print(f"❌ Error: {e}", style="bold red")
        if verbose:
            import traceback
            traceback.print_exc()
        return 1


def main() -> None:
    print_header()
    details = """
- Dart package path (e.g., ../packages/news_blocks)
- Output directory (e.g., ./src/news_blocks)
- Optional: custom template directory
- Flags: force, test, dry-run, verbose
    """
    console.print(Panel(Markdown(details), title="Options", border_style="yellow"))

    if not Confirm.ask("Proceed?", default=True):
        console.print("Cancelled", style="yellow")
        return

    opts = ask_options()
    exit_code = generate(opts)
    raise SystemExit(exit_code)


if __name__ == "__main__":
    main() 
