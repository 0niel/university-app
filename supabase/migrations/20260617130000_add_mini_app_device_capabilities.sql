-- Device capabilities for mini apps: geolocation, camera photo + code scan.
--
-- Two new consent scopes (location, camera) extend the existing permission
-- model, a public bucket receives mini-app photo uploads (per-user folder,
-- like mini-app-icons / lost-found-images), and the three new host actions are
-- registered so server-side screen validation does not flag them as unknown.
-- Capture itself runs client-side (the proxy forwards no device data); these
-- scopes only gate the in-app capability and surface in the consent sheet.
-- Applied remotely as: add_mini_app_device_capabilities.

-- ---------------------------------------------------------------------------
-- Consent scopes: add location + camera.
-- ---------------------------------------------------------------------------

alter table core.mini_apps drop constraint mini_apps_permissions_valid;
alter table core.mini_apps add constraint mini_apps_permissions_valid check (
  requested_permissions <@ array[
    'identity', 'email', 'profile', 'group', 'notifications',
    'location', 'camera'
  ]::text[]
);

alter table core.mini_app_consents drop constraint mini_app_consents_scopes_valid;
alter table core.mini_app_consents add constraint mini_app_consents_scopes_valid check (
  scopes <@ array[
    'identity', 'email', 'profile', 'group', 'notifications',
    'location', 'camera'
  ]::text[]
);

-- ---------------------------------------------------------------------------
-- Uploads bucket: photos captured by mini apps, served by public URL.
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'mini-app-uploads', 'mini-app-uploads', true, 5242880,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do nothing;

-- Public bucket, served by URL — no SELECT policy on purpose (a broad SELECT
-- would only enable bucket listing). Writes are scoped to the user's own
-- top-level folder, mirroring mini-app-icons.
create policy "users upload mini app files into own folder"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'mini-app-uploads'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "users replace mini app files in own folder"
on storage.objects for update to authenticated
using (
  bucket_id = 'mini-app-uploads'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "users delete mini app files in own folder"
on storage.objects for delete to authenticated
using (
  bucket_id = 'mini-app-uploads'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

-- ---------------------------------------------------------------------------
-- Register the new actions so validate_mini_app_screens stays quiet.
-- ---------------------------------------------------------------------------

insert into core.mini_app_known_types (kind, name) values
  ('action', 'getLocation'),
  ('action', 'pickImage'),
  ('action', 'scanCode')
on conflict do nothing;
