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
  [int]$Port = 8787,
  # How often to re-check that the Actions variable still matches the live URL.
  [int]$VerifyIntervalSeconds = 600
)

$ErrorActionPreference = 'Continue'
$node = (Get-Command node.exe).Source
$cloudflared = Join-Path $InstallDir 'cloudflared.exe'
$proxy = Join-Path $InstallDir 'local_proxy.mjs'
$envFile = Join-Path $InstallDir 'relay.env'
$tunnelLog = Join-Path $InstallDir 'tunnel.log'
$urlState = Join-Path $InstallDir 'current-url.txt'
$supervisorLog = Join-Path $InstallDir 'supervisor.log'

# The task runs in a hidden window, so Write-Host output is lost; keep a file.
function Write-Log([string]$message) {
  $line = "$(Get-Date -Format o) $message"
  Write-Host $line
  Add-Content -Path $supervisorLog -Value $line
}

# Resolve gh once: the task's PATH may differ from an interactive shell's.
$gh = (Get-Command gh.exe -ErrorAction SilentlyContinue).Source
if (-not $gh) {
  $candidates = @(
    'C:\Program Files\GitHub CLI\gh.exe',
    (Join-Path $env:LOCALAPPDATA 'Programs\GitHub CLI\gh.exe')
  )
  $gh = $candidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
}
if (-not $gh) { Write-Log 'gh.exe not found; tunnel URL will not be published' }

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

function Get-PublishedUrl {
  if (-not $gh) { return $null }
  $value = & $gh variable get SCHEDULE_SOURCE_BASE_URL --repo $Repo 2>$null
  if ($LASTEXITCODE -ne 0) { return $null }
  return "$value".Trim()
}

# Returns $true once the Actions variable holds $url. gh can fail right after
# logon (network/VPN not up yet), so the caller keeps retrying until it does.
function Publish-Url([string]$url) {
  if (-not $gh) { return $false }
  $output = & $gh variable set SCHEDULE_SOURCE_BASE_URL --repo $Repo --body $url 2>&1
  if ($LASTEXITCODE -eq 0) {
    Set-Content $urlState $url -NoNewline
    Write-Log "published tunnel URL $url"
    return $true
  }
  Write-Log "failed to publish tunnel URL $url : $output"
  return $false
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
  Write-Log "started cloudflared (pid $($tunnel.Id))"

  $url = $null
  $published = $false
  $nextPublishAttempt = Get-Date
  $nextVerify = Get-Date
  while (-not $tunnel.HasExited) {
    if (-not $url -and (Test-Path $tunnelLog)) {
      $match = Select-String -Path $tunnelLog -Pattern 'https://[a-z0-9-]+\.trycloudflare\.com' | Select-Object -First 1
      if ($match) {
        $url = $match.Matches[0].Value
        Write-Log "tunnel URL is $url"
      }
    }

    $now = Get-Date
    if ($url -and -not $published -and $now -ge $nextPublishAttempt) {
      $published = Publish-Url $url
      if ($published) { $nextVerify = $now.AddSeconds($VerifyIntervalSeconds) }
      else { $nextPublishAttempt = $now.AddSeconds(60) }
    }

    # Periodically confirm the variable still points here (someone may have
    # overwritten it, or the earlier set only appeared to succeed).
    if ($url -and $published -and $now -ge $nextVerify) {
      $remote = Get-PublishedUrl
      if ($remote -and $remote -ne $url) {
        Write-Log "variable holds $remote, republishing"
        $published = $false
        $nextPublishAttempt = $now
      }
      $nextVerify = $now.AddSeconds($VerifyIntervalSeconds)
    }

    Start-Sleep -Seconds 5
  }

  Write-Log "tunnel exited (code $($tunnel.ExitCode)); restarting in 10s"
  Start-Sleep -Seconds 10
}
