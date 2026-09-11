# Supervises the MIREA schedule relay on a Russian residential machine.
#
# The official schedule-of.mirea.ru API blocks datacenter and foreign IPs, so
# GitHub Actions cannot reach it directly. This machine can, so it runs a small
# authenticated HTTP proxy and exposes it through a Cloudflare quick tunnel. The
# tunnel URL is ephemeral, so whenever it changes this script pushes the new URL
# into the repo's SCHEDULE_SOURCE_BASE_URL Actions variable via the gh CLI.
#
# Run it as a per-user scheduled task ("run only when user is logged on") so gh
# uses the user's stored credentials and no token is written to disk.
param(
  [string]$InstallDir = 'C:\ProgramData\mirea-schedule-relay',
  [string]$Repo = '0niel/university-app',
  [int]$Port = 8787
)

$ErrorActionPreference = 'Continue'
$node = (Get-Command node.exe).Source
$cloudflared = Join-Path $InstallDir 'cloudflared.exe'
$proxy = Join-Path $InstallDir 'local_proxy.mjs'
$envFile = Join-Path $InstallDir 'relay.env'
$tunnelLog = Join-Path $InstallDir 'tunnel.log'
$urlState = Join-Path $InstallDir 'current-url.txt'

$authorization = (Get-Content $envFile | Where-Object { $_ -like 'RELAY_AUTHORIZATION=*' }).Substring('RELAY_AUTHORIZATION='.Length)

function Start-Proxy {
  $running = Get-CimInstance Win32_Process -Filter "Name='node.exe'" |
    Where-Object { $_.CommandLine -like "*local_proxy.mjs*" }
  if ($running) { return }
  $env:RELAY_AUTHORIZATION = $authorization
  $env:RELAY_PORT = "$Port"
  Start-Process -FilePath $node -ArgumentList $proxy -WorkingDirectory $InstallDir -WindowStyle Hidden
  Start-Sleep -Seconds 2
}

function Publish-Url([string]$url) {
  $previous = ''
  if (Test-Path $urlState) { $previous = (Get-Content $urlState -Raw).Trim() }
  if ($url -eq $previous) { return }
  & gh variable set SCHEDULE_SOURCE_BASE_URL --repo $Repo --body $url 2>&1 | Out-Host
  if ($LASTEXITCODE -eq 0) {
    Set-Content $urlState $url -NoNewline
    Write-Host "$(Get-Date -Format o) published tunnel URL $url"
  } else {
    Write-Host "$(Get-Date -Format o) failed to publish tunnel URL"
  }
}

while ($true) {
  Start-Proxy
  if (Test-Path $tunnelLog) { Remove-Item $tunnelLog -Force }

  # http2 (TCP 443) instead of the default QUIC/UDP: residential + RU links drop
  # UDP, and cloudflared's QUIC stream stalls silently without reconnecting.
  $tunnel = Start-Process -FilePath $cloudflared `
    -ArgumentList @('tunnel', '--no-autoupdate', '--protocol', 'http2', '--url', "http://127.0.0.1:$Port") `
    -WorkingDirectory $InstallDir -WindowStyle Hidden -PassThru `
    -RedirectStandardError $tunnelLog -RedirectStandardOutput (Join-Path $InstallDir 'tunnel.out.log')

  $published = $false
  while (-not $tunnel.HasExited) {
    if (-not $published -and (Test-Path $tunnelLog)) {
      $match = Select-String -Path $tunnelLog -Pattern 'https://[a-z0-9-]+\.trycloudflare\.com' | Select-Object -First 1
      if ($match) {
        Publish-Url ($match.Matches[0].Value)
        $published = $true
      }
    }
    Start-Sleep -Seconds 5
  }

  Write-Host "$(Get-Date -Format o) tunnel exited; restarting in 10s"
  Start-Sleep -Seconds 10
}
