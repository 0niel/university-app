#!/bin/bash

# Telegram user session setup script for Unix/Linux

echo "=== Telegram User Session Setup ==="
echo ""
echo "This script will run interactive Telegram session setup."
echo "Make sure .env.social-media contains correct TELEGRAM_API_ID and TELEGRAM_API_HASH"
echo ""

if [ ! -f "docker-compose.social-media.yml" ]; then
    echo "❌ Error: Run script from repository root"
    echo "./tools/social_media_fetcher/setup_session.sh"
    exit 1
fi

if [ ! -f ".env.social-media" ]; then
    echo "❌ Error: .env.social-media file not found"
    echo "Create .env.social-media file with Telegram settings"
    exit 1
fi

echo "Starting interactive setup..."
echo ""

docker compose --env-file .env.social-media -f docker-compose.social-media.yml run --rm \
    -v "$(pwd)/tools/social_media_fetcher:/app" \
    -w /app \
    --entrypoint python \
    social-media-fetcher setup_telegram_session.py

echo ""
echo "Setup completed. If session was created successfully, restart the service:"
echo "docker compose --env-file .env.social-media -f docker-compose.social-media.yml restart social-media-fetcher"
