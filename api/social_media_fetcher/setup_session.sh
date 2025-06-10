#!/bin/bash

# Telegram user session setup script for Unix/Linux

echo "=== Telegram User Session Setup ==="
echo ""
echo "This script will run interactive Telegram session setup."
echo "Make sure .env file contains correct TELEGRAM_API_ID and TELEGRAM_API_HASH"
echo ""

if [ ! -f "docker-compose.social-media.yml" ]; then
    echo "❌ Error: Run script from api/ directory"
    echo "cd api && ./social_media_fetcher/setup_session.sh"
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo "Create .env file with Telegram settings"
    exit 1
fi

echo "Starting interactive setup..."
echo ""

docker-compose -f docker-compose.social-media.yml run --rm \
    -v "$(pwd)/social_media_fetcher:/app" \
    -w /app \
    --entrypoint python \
    social-media-fetcher setup_telegram_session.py

echo ""
echo "Setup completed. If session was created successfully, restart the service:"
echo "docker-compose -f docker-compose.social-media.yml restart social-media-fetcher"
