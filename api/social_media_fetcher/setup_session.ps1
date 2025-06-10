# Telegram user session setup script for Windows

Write-Host "=== Telegram User Session Setup ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will run interactive Telegram session setup."
Write-Host "Make sure .env file contains correct TELEGRAM_API_ID and TELEGRAM_API_HASH"
Write-Host ""

if (-not (Test-Path "docker-compose.social-media.yml")) {
    Write-Host "❌ Error: Run script from api/ directory" -ForegroundColor Red
    Write-Host "cd api && .\social_media_fetcher\setup_session.ps1"
    exit 1
}

if (-not (Test-Path ".env")) {
    Write-Host "❌ Error: .env file not found" -ForegroundColor Red
    Write-Host "Create .env file with Telegram settings"
    exit 1
}

Write-Host "Starting interactive setup..." -ForegroundColor Yellow
Write-Host ""

$currentDir = (Get-Location).Path
$dockerPath = $currentDir -replace '\\', '/' -replace '^([A-Z]):', '/c'

docker-compose -f docker-compose.social-media.yml run --rm `
    -v "${dockerPath}/social_media_fetcher:/app" `
    -w /app `
    --entrypoint python `
    social-media-fetcher setup_telegram_session.py

Write-Host ""
Write-Host "Setup completed. If session was created successfully, restart the service:" -ForegroundColor Green
Write-Host "docker-compose -f docker-compose.social-media.yml restart social-media-fetcher" -ForegroundColor Cyan 
