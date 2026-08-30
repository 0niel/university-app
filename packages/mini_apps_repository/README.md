# mini_apps_repository

Repository for the mini apps (BDUI/Stac) platform: catalog with search,
authoring (hosted JSON / remote origin), reports, per-user hiding, ratings,
moderation and screen fetching through the `miniapp-proxy` edge function.

All network calls are wrapped into typed failures
(`GetMiniAppsFailure`, `SubmitMiniAppFailure`, ...) so blocs never see raw
Supabase exceptions.
