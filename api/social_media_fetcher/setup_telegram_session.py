"""
Telegram user session setup script.
Run this script to authorize user and create session.
"""

import asyncio
import os
import sys
from pathlib import Path

from loguru import logger
from pyrogram import Client
from pyrogram.errors import SessionPasswordNeeded

# Add src path for config import
sys.path.append(os.path.join(os.path.dirname(__file__), "src"))

from config import Settings


async def setup_user_session():
    """Setup Telegram user session."""

    settings = Settings()

    if not settings.telegram_configured:
        logger.error(
            "Telegram not configured. Check TELEGRAM_API_ID and TELEGRAM_API_HASH in .env"
        )
        return False

    logger.info("Setting up Telegram user session...")
    logger.info(f"API ID: {settings.TELEGRAM_API_ID}")
    logger.info(f"Working directory: {settings.TELEGRAM_WORKDIR}")

    os.makedirs(settings.TELEGRAM_WORKDIR, exist_ok=True)

    client = Client(
        name=settings.TELEGRAM_SESSION_NAME,
        api_id=settings.TELEGRAM_API_ID,
        api_hash=settings.TELEGRAM_API_HASH,
        workdir=settings.TELEGRAM_WORKDIR,
        proxy=settings.get_proxy_dict(),
    )

    try:
        logger.info("Starting client for authorization...")
        await client.start()

        me = await client.get_me()
        logger.success(
            f"Successfully authorized as: {me.first_name} {me.last_name or ''} (@{me.username or 'no username'})"
        )
        logger.success(f"User ID: {me.id}")
        logger.success(f"Phone: {me.phone_number}")

        # Test channel access
        test_channel = "durov"
        try:
            chat = await client.get_chat(test_channel)
            logger.success(f"Channel access test @{test_channel}: ✅ Success")
            logger.info(f"Channel: {chat.title}")

            messages_count = 0
            async for message in client.get_chat_history(test_channel, limit=5):
                if not message.empty:
                    messages_count += 1

            logger.success(f"Retrieved {messages_count} messages from test channel")

        except Exception as e:
            logger.warning(f"Could not access test channel: {e}")

        await client.stop()

        session_file = os.path.join(
            settings.TELEGRAM_WORKDIR, f"{settings.TELEGRAM_SESSION_NAME}.session"
        )
        if os.path.exists(session_file):
            logger.success(f"Session file created: {session_file}")
            logger.info("You can now restart the service to use user session")
            return True
        else:
            logger.error("Session file was not created")
            return False

    except SessionPasswordNeeded:
        logger.error("Two-factor authentication (2FA) required")
        logger.info("Enter your 2FA password:")
        password = input("2FA password: ")

        try:
            await client.check_password(password)
            me = await client.get_me()
            logger.success(
                f"Successfully authorized with 2FA as: {me.first_name} (@{me.username})"
            )
            await client.stop()
            return True
        except Exception as e:
            logger.error(f"Error with 2FA password: {e}")
            await client.stop()
            return False

    except Exception as e:
        logger.error(f"Error setting up session: {e}")
        try:
            await client.stop()
        except:
            pass
        return False


def main():
    """Main function."""
    logger.info("=== Telegram User Session Setup ===")
    logger.info("")
    logger.info(
        "This script will help you setup user session for Telegram channel access."
    )
    logger.info("You will need:")
    logger.info("1. Phone number linked to Telegram")
    logger.info("2. Verification code from Telegram")
    logger.info("3. Two-factor authentication password (if enabled)")
    logger.info("")

    if not os.path.exists("src/config.py"):
        logger.error("Run script from social_media_fetcher directory")
        logger.error("cd api/social_media_fetcher && python setup_telegram_session.py")
        return

    try:
        success = asyncio.run(setup_user_session())
        if success:
            logger.success("✅ Setup completed successfully!")
            logger.info("Now restart the service:")
            logger.info(
                "docker-compose -f docker-compose.social-media.yml restart social-media-fetcher"
            )
        else:
            logger.error("❌ Setup failed")

    except KeyboardInterrupt:
        logger.info("Setup interrupted by user")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")


if __name__ == "__main__":
    main()
