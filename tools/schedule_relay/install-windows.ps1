#Requires -RunAsAdministrator
param(
  [string]$InstallDir = 'C:\ProgramData\mirea-schedule-relay',
  [string]$Hostname = 'schedule-relay.mirea.ninja',
  [string]$TunnelName = 'mirea-schedule-relay'
)

$ErrorActionPreference = 'Stop'
$node = (Get-Command node.exe).Source
$cloudflared = Join-Path $InstallDir 'cloudflared.exe'
$proxy = Join-Path $InstallDir 'local_proxy.mjs'
$envFile = Join-Path $InstallDir 'relay.env'
$config = Join-Path $InstallDir 'config.yml'

New-Item -ItemType Directory -Force $InstallDir | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'local_proxy.mjs') $proxy -Force
if (-not (Test-Path $cloudflared)) {
  Invoke-WebRequest 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe' -OutFile $cloudflared
}
if (-not (Test-Path $envFile)) {
  $token = [Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }) -as [byte[]]).TrimEnd('=').Replace('+', '-').Replace('/', '_')
  "RELAY_AUTHORIZATION=Bearer $token`nRELAY_PORT=8787" | Set-Content $envFile -NoNewline
}

$tunnelList = & $cloudflared tunnel list --name $TunnelName --output json | ConvertFrom-Json
if (-not $tunnelList) {
  & $cloudflared tunnel create $TunnelName | Out-Host
  $tunnelList = & $cloudflared tunnel list --name $TunnelName --output json | ConvertFrom-Json
}
$tunnelId = $tunnelList[0].id
$credentials = Join-Path $InstallDir "$tunnelId.json"
if (-not (Test-Path $credentials)) {
  Copy-Item (Join-Path $env:USERPROFILE ".cloudflared\$tunnelId.json") $credentials
}
& $cloudflared tunnel route dns --overwrite-dns $TunnelName $Hostname | Out-Host

@"
tunnel: $tunnelId
credentials-file: $credentials
ingress:
  - hostname: $Hostname
    service: http://127.0.0.1:8787
  - service: http_status:404
"@ | Set-Content $config

$proxyCmd = "`$env:RELAY_AUTHORIZATION=(Get-Content '$envFile' | Where-Object { `$_ -like 'RELAY_AUTHORIZATION=*' }).Substring(20); `$env:RELAY_PORT='8787'; & '$node' '$proxy'"
$proxyAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -WindowStyle Hidden -Command `"$proxyCmd`"" -WorkingDirectory $InstallDir
$tunnelAction = New-ScheduledTaskAction -Execute $cloudflared -Argument "--config `"$config`" tunnel run" -WorkingDirectory $InstallDir
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1) -ExecutionTimeLimit ([TimeSpan]::Zero) -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest

Register-ScheduledTask -TaskName 'MireaScheduleRelayProxy' -Action $proxyAction -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Register-ScheduledTask -TaskName 'MireaScheduleRelayTunnel' -Action $tunnelAction -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
Start-ScheduledTask -TaskName 'MireaScheduleRelayProxy'
Start-ScheduledTask -TaskName 'MireaScheduleRelayTunnel'

Write-Host "Relay hostname: https://$Hostname"
Write-Host "Authorization header value is stored in $envFile"
