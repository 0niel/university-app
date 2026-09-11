# One-time setup for the MIREA schedule relay on this machine.
# Installs the binaries, generates the shared secret, uploads it to GitHub as the
# SCHEDULE_SOURCE_AUTHORIZATION secret, and registers a per-user scheduled task
# that keeps the proxy + Cloudflare quick tunnel alive and self-publishes the URL.
#
# Requires: node on PATH, an authenticated `gh` CLI with access to the repo.
param(
  [string]$InstallDir = 'C:\ProgramData\mirea-schedule-relay',
  [string]$Repo = '0niel/university-app'
)

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force $InstallDir | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'local_proxy.mjs') (Join-Path $InstallDir 'local_proxy.mjs') -Force
Copy-Item (Join-Path $PSScriptRoot 'relay-supervisor.ps1') (Join-Path $InstallDir 'relay-supervisor.ps1') -Force

$cloudflared = Join-Path $InstallDir 'cloudflared.exe'
if (-not (Test-Path $cloudflared)) {
  Invoke-WebRequest 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe' -OutFile $cloudflared
}

$envFile = Join-Path $InstallDir 'relay.env'
if (-not (Test-Path $envFile)) {
  $bytes = [byte[]]::new(32)
  [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
  $token = 'Bearer ' + [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
  "RELAY_AUTHORIZATION=$token`nRELAY_PORT=8787" | Set-Content $envFile -NoNewline
}
$authorization = (Get-Content $envFile | Where-Object { $_ -like 'RELAY_AUTHORIZATION=*' }).Substring('RELAY_AUTHORIZATION='.Length)
$authorization | & gh secret set SCHEDULE_SOURCE_AUTHORIZATION --repo $Repo

$supervisor = Join-Path $InstallDir 'relay-supervisor.ps1'
# The supervisor targets PowerShell 7; fall back to Windows PowerShell only if 7 is absent.
$pwsh = 'C:\Program Files\PowerShell\7\pwsh.exe'
if (-not (Test-Path $pwsh)) { $pwsh = 'powershell.exe' }
$action = New-ScheduledTaskAction -Execute $pwsh `
  -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$supervisor`" -Repo `"$Repo`"" `
  -WorkingDirectory $InstallDir
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1) `
  -ExecutionTimeLimit ([TimeSpan]::Zero) -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName 'MireaScheduleRelay' -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
Start-ScheduledTask -TaskName 'MireaScheduleRelay'

Write-Host 'Relay task registered and started.'
Write-Host 'It publishes the tunnel URL to the SCHEDULE_SOURCE_BASE_URL Actions variable automatically.'
