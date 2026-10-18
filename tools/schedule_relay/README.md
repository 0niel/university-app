# MIREA schedule relay

The relay forwards authenticated `GET` and `HEAD` requests under
`/schedule/api/` to `https://schedule-of.mirea.ru`. It uses a fixed upstream,
does not follow redirects, and never forwards the relay credential upstream.
`GET /healthz` checks the local process; the source selector separately validates
search results and an actual calendar before starting a sync.

## Production

The relay runs on `89.169.2.37` under `/opt/mirea-schedule-relay` as a separate
Docker Compose project, `mirea-schedule-relay`. The existing Traefik installation
provides HTTPS at `https://app-api.mirea.ninja/schedule/api/` on the external
`application` network. Existing `/api` routes belong to the original backend.
The relay has no published host ports and restarts automatically with Docker.

Deploy `Dockerfile`, `.dockerignore`, `compose.yaml`, `local_proxy.mjs`, and
`server.mjs` to that directory. Keep `relay.env` readable only by root and set
`RELAY_AUTHORIZATION` to the same bearer value as the repository's
`SCHEDULE_SOURCE_AUTHORIZATION` Actions secret. Never commit that file.

```sh
cd /opt/mirea-schedule-relay
docker compose -p mirea-schedule-relay config --quiet
docker compose -p mirea-schedule-relay up --build -d
docker compose -p mirea-schedule-relay ps
```

Set the Actions variable `SCHEDULE_SOURCE_BASE_URL` to
`https://app-api.mirea.ninja`. The fetcher probes the official origin first,
then the authenticated relay. Transient relay failures retry within a shared
90-second search/calendar budget; authentication and invalid payloads fail
immediately. Diagnostics contain only the source, stage, error category and
HTTP status.

## Local checks

```sh
node --test tools/schedule_relay/server.test.mjs
```

For standalone hosting, `local_proxy.mjs` accepts `PORT` or `RELAY_PORT` and
`RELAY_HOST` (default `127.0.0.1`). It requires `RELAY_AUTHORIZATION`.

## Legacy Windows tunnel

`setup-relay.ps1` and `relay-supervisor.ps1` support the old residential relay.
The `MireaScheduleRelay` scheduled task is disabled after the fixed-host cutover.
Do not enable it alongside production: it publishes a temporary
`trycloudflare.com` address into the same Actions variable.
