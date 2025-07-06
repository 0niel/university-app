"""
Telegram session setup script for Telethon.
Run this script to create a session string for the bot.
"""

import asyncio
import os
import sys
from telethon import TelegramClient
from telethon.sessions import StringSession
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.progress import Progress, SpinnerColumn, TextColumn, TimeElapsedColumn
from rich.table import Table
from rich.markdown import Markdown
from rich.prompt import Confirm

# Add src path for config import
sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

from src.config import Settings

console = Console()


def print_header():
    """Print a beautiful header."""
    title = Text("🚀 Telegram Session Setup", style="bold magenta")
    subtitle = Text("Setting up Telethon session for social media fetching", style="dim")
    
    console.print()
    console.print(Panel.fit(title, subtitle=subtitle, border_style="bright_blue"))
    console.print()


def print_requirements():
    """Print setup requirements."""
    requirements = """
## 📋 Requirements

You will need the following:

1. **Phone number** linked to Telegram
2. **Verification code** from Telegram (sent via SMS/app)
3. **Two-factor authentication password** (if enabled on your account)

Make sure you have access to your phone to receive the verification code.
    """
    
    console.print(Panel(Markdown(requirements), title="📋 Setup Requirements", border_style="yellow"))
    console.print()


def print_step(step_num: int, title: str, description: str = None):
    """Print a setup step."""
    step_text = Text(f"Step {step_num}: {title}", style="bold cyan")
    if description:
        step_text.append(f"\n{description}", style="dim")
    
    console.print(f"📍 {step_text}")


def print_success(message: str):
    """Print success message."""
    console.print(f"✅ {message}", style="bold green")


def print_error(message: str):
    """Print error message."""
    console.print(f"❌ {message}", style="bold red")


def print_warning(message: str):
    """Print warning message."""
    console.print(f"⚠️  {message}", style="bold yellow")


def print_info(message: str):
    """Print info message."""
    console.print(f"ℹ️  {message}", style="cyan")


def print_user_info(user):
    """Print user information in a nice table."""
    table = Table(title="👤 User Information", show_header=True, header_style="bold blue")
    table.add_column("Field", style="cyan", width=12)
    table.add_column("Value", style="white")
    
    table.add_row("Name", f"{user.first_name} {user.last_name or ''}")
    table.add_row("Username", f"@{user.username or 'no username'}")
    table.add_row("User ID", str(user.id))
    table.add_row("Phone", user.phone or "Not available")
    
    console.print(table)
    console.print()


def print_session_result(session_string: str):
    """Print the final session string with instructions."""
    console.print()
    console.print("🎉 Session created successfully!", style="bold green")
    console.print()
    
    # Session string without borders for easy copy-paste
    console.print("\n🔑 Session String:\n", style="bold blue")
    console.print(f"TELEGRAM_SESSION_STRING={session_string}", style="bold green")
    console.print()
    
    # Instructions
    instructions = """
## 🔧 Next Steps

1. **Copy** the session string above
2. **Add** it to your `.env` file
3. **Restart** your application

The session string contains your authentication credentials and will allow 
the bot to access Telegram on your behalf.
    """
    
    console.print(Panel(Markdown(instructions), title="📝 Instructions", border_style="blue"))


async def setup_telethon_session():
    """Setup Telegram session using Telethon."""
    
    settings = Settings()

    if not settings.TELEGRAM_API_ID or not settings.TELEGRAM_API_HASH:
        print_error("Telegram not configured. Check TELEGRAM_API_ID and TELEGRAM_API_HASH in .env")
        return None

    print_step(1, "Initializing Telegram client")
    print_info(f"API ID: {settings.TELEGRAM_API_ID}")

    # Create a new client with StringSession
    client = TelegramClient(StringSession(), settings.TELEGRAM_API_ID, settings.TELEGRAM_API_HASH)

    try:
        print_step(2, "Starting authorization process")
        print_info("You will be prompted for your phone number and verification code...")
        console.print()

        # Start client without progress bar to allow interactive input
        await client.start()

        print_success("Connected successfully!")

        # Get user info
        me = await client.get_me()
        print_success("Successfully authorized!")
        print_user_info(me)

        # Get the session string
        session_string = client.session.save()

        # Test channel access
        print_step(3, "Testing channel access")
        test_channel = "sumirea"  # Using the channel from your sources
        try:
            print_info(f"Testing access to @{test_channel}...")
            entity = await client.get_entity(test_channel)

            print_success(f"Channel access test @{test_channel}: Success")
            print_info(f"Channel: {entity.title}")

            # Try to get a few messages
            messages_count = 0
            async for message in client.iter_messages(entity, limit=5):
                if message.text:
                    messages_count += 1

            print_success(f"Retrieved {messages_count} messages from test channel")

        except Exception as e:
            print_warning(f"Could not access test channel: {e}")

        await client.disconnect()

        return session_string

    except Exception as e:
        print_error(f"Error setting up session: {e}")
        try:
            await client.disconnect()
        except:
            pass
        return None


def main():
    """Main function."""
    print_header()
    print_requirements()
    
    if not Confirm.ask("🚀 Ready to start setup?", default=True):
        console.print("Setup cancelled by user", style="yellow")
        return
    
    console.print()
    
    try:
        session_string = asyncio.run(setup_telethon_session())
        
        if session_string:
            print_session_result(session_string)
        else:
            print_error("Session creation failed")
            
    except KeyboardInterrupt:
        console.print("\n⚠️  Setup interrupted by user", style="yellow")
    except Exception as e:
        print_error(f"Unexpected error: {e}")


if __name__ == "__main__":
    main()
