import argparse
import asyncio
import json
import os
from pathlib import Path

from telethon import TelegramClient
from telethon.errors import PhoneCodeExpiredError, SessionPasswordNeededError
from telethon.sessions import StringSession

from src.config import Settings

_DATA_DIR = Path(__file__).resolve().parent / "data"


async def create_session(output: Path) -> None:
    client = _client()
    try:
        await client.start()
        await _save_session(client, output)
    finally:
        await client.disconnect()


async def request_code(phone: str, state_file: Path) -> None:
    client = _client()
    try:
        await client.connect()
        sent_code = await client.send_code_request(phone)
        await asyncio.to_thread(
            _write_json,
            state_file,
            {
                "phone": phone,
                "phone_code_hash": sent_code.phone_code_hash,
                "session": client.session.save(),
            },
        )
    finally:
        await client.disconnect()

    print("Telegram sent a sign-in code. Provide it to complete verification.")


async def verify_code(code: str, state_file: Path, output: Path) -> None:
    state = await asyncio.to_thread(_read_auth_state, state_file)
    client = _client(state["session"])
    try:
        await client.connect()
        try:
            await client.sign_in(
                phone=state["phone"],
                code=code,
                phone_code_hash=state["phone_code_hash"],
            )
        except PhoneCodeExpiredError as error:
            await asyncio.to_thread(state_file.unlink, missing_ok=True)
            raise RuntimeError(
                "Telegram confirmation code expired. Request a new code."
            ) from error
        except SessionPasswordNeededError as error:
            raise RuntimeError(
                "Telegram two-step verification password is required."
            ) from error
        await _save_session(client, output)
    finally:
        await client.disconnect()

    await asyncio.to_thread(state_file.unlink, missing_ok=True)


async def verify_password(password: str, state_file: Path, output: Path) -> None:
    state = await asyncio.to_thread(_read_auth_state, state_file)
    client = _client(state["session"])
    try:
        await client.connect()
        await client.sign_in(password=password)
        await _save_session(client, output)
    finally:
        await client.disconnect()

    await asyncio.to_thread(state_file.unlink, missing_ok=True)


async def check_session(session_file: Path) -> None:
    try:
        session = await asyncio.to_thread(session_file.read_text, encoding="utf-8")
    except OSError as error:
        raise RuntimeError("Telegram session file is missing or unreadable") from error
    client = _client(session.strip())
    try:
        await client.connect()
        if not await client.is_user_authorized():
            raise RuntimeError("Telegram session is not authorized")
    finally:
        await client.disconnect()

    print("Telegram session is authorized.")


def _client(session: str | None = None) -> TelegramClient:
    settings = Settings()
    if settings.TELEGRAM_API_ID is None or not settings.TELEGRAM_API_HASH:
        raise RuntimeError("TELEGRAM_API_ID and TELEGRAM_API_HASH are required")
    return TelegramClient(
        StringSession(session),
        settings.TELEGRAM_API_ID,
        settings.TELEGRAM_API_HASH,
    )


async def _save_session(client: TelegramClient, output: Path) -> None:
    await asyncio.to_thread(_write_session, output, client.session.save())
    print(f"Session saved to {output}.")
    print("Store it as a secret and delete this file after import.")


def _write_session(output: Path, session: str) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(session, encoding="utf-8")
    os.chmod(output, 0o600)


def _write_json(output: Path, value: dict[str, str]) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(value), encoding="utf-8")
    os.chmod(output, 0o600)


def _read_auth_state(state_file: Path) -> dict[str, str]:
    try:
        state = json.loads(state_file.read_text(encoding="utf-8"))
        phone = state["phone"]
        phone_code_hash = state["phone_code_hash"]
        session = state["session"]
    except (KeyError, OSError, TypeError, json.JSONDecodeError) as error:
        raise RuntimeError("Telegram login request is missing or invalid") from error
    if not all(isinstance(value, str) for value in (phone, phone_code_hash, session)):
        raise RuntimeError("Telegram login request is missing or invalid")
    return {"phone": phone, "phone_code_hash": phone_code_hash, "session": session}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=_DATA_DIR / "telegram.session-string",
    )
    parser.add_argument(
        "--auth-state",
        type=Path,
        default=_DATA_DIR / "telegram-login.json",
    )
    parser.add_argument("--phone")
    parser.add_argument("--request-code", action="store_true")
    parser.add_argument("--verify", action="store_true")
    parser.add_argument("--verify-password", action="store_true")
    parser.add_argument("--check-session", action="store_true")
    parser.add_argument("--code-env", default="TELEGRAM_LOGIN_CODE")
    parser.add_argument("--password-env", default="TELEGRAM_2FA_PASSWORD")
    args = parser.parse_args()
    try:
        if args.request_code:
            if not args.phone:
                parser.error("--phone is required with --request-code")
            asyncio.run(request_code(args.phone, args.auth_state))
            return
        if args.verify:
            code = os.getenv(args.code_env)
            if not code:
                parser.error(f"{args.code_env} must be set with --verify")
            asyncio.run(verify_code(code, args.auth_state, args.output))
            return
        if args.verify_password:
            password = os.getenv(args.password_env)
            if not password:
                parser.error(f"{args.password_env} must be set with --verify-password")
            asyncio.run(verify_password(password, args.auth_state, args.output))
            return
        if args.check_session:
            asyncio.run(check_session(args.output))
            return
        asyncio.run(create_session(args.output))
    except RuntimeError as error:
        parser.exit(1, f"Error: {error}\n")


if __name__ == "__main__":
    main()
