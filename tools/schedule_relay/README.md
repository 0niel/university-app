# MIREA schedule relay

`schedule-of.mirea.ru` (the official schedule API) refuses requests from
datacenter and non‑Russian IP addresses, so the GitHub Actions runner that
runs `sync-schedule.yml` cannot reach it. The relay bridges that gap: it runs
on a machine on a Russian residential connection, proxies the handful of
`/schedule/api/**` endpoints the fetcher needs, and exposes them through a
Cloudflare tunnel that the runner can reach.

## Pieces

- **`local_proxy.mjs`** — a tiny Node HTTP server (127.0.0.1:8787). It only
  forwards `GET /schedule/api/**` to `https://schedule-of.mirea.ru`, requires
  the `Authorization` header to equal `RELAY_AUTHORIZATION`, and strips
  everything else.
- **`relay-supervisor.ps1`** — keeps the proxy and a Cloudflare **quick tunnel**
  alive. A quick tunnel's `*.trycloudflare.com` URL changes every restart, so
  whenever it changes the supervisor pushes it into the repo's
  `SCHEDULE_SOURCE_BASE_URL` Actions variable via `gh`. This is what makes the
  sync self‑healing — a reboot no longer strands the workflow on a dead URL.
- **`setup-relay.ps1`** — one‑time install: downloads `cloudflared`, generates
  the shared secret, uploads it as the `SCHEDULE_SOURCE_AUTHORIZATION` GitHub
  secret, and registers the `MireaScheduleRelay` per‑user scheduled task.

## Install (on the relay machine)

```powershell
gh auth status          # must be logged in with access to the repo
pwsh -File tools/schedule_relay/setup-relay.ps1 -Repo 0niel/university-app
```

The task runs only while the user is logged on, so `gh` uses the stored
credentials and no token is written to disk. Confirm it works:

```powershell
Get-ScheduledTask MireaScheduleRelay
gh variable get SCHEDULE_SOURCE_BASE_URL --repo 0niel/university-app
```

## How the fetcher uses it

`sync_mirea_schedule.dart` (via `select_schedule_source.dart`) always probes the
official origin first and only falls back to the relay when the official probe
fails — which it does from GitHub's runners. The relay is therefore transparent:
if MIREA ever stops blocking the runner, the sync uses the official API directly
and the relay is ignored.

## More stable option

A quick tunnel is convenient but unofficial. For a fixed hostname, create a
named tunnel bound to a Cloudflare zone you control and point
`SCHEDULE_SOURCE_BASE_URL` at it permanently; then the supervisor's URL
publishing is unnecessary.
