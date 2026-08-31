-- Mini apps device capabilities, wave 2: files, calendar, biometrics, local
-- reminders, clipboard read, date/time picker.
--
-- Two more consent scopes (files, calendar); the uploads bucket widens to
-- accept non-image files (pickFile); and the six new actions are registered
-- so screen validation stays quiet. Like wave 1, capture is client-side — the
-- scopes only gate the in-app capability.
-- Applied remotely as: add_mini_app_capabilities_wave2.

-- ---------------------------------------------------------------------------
-- Consent scopes: add files + calendar.
-- ---------------------------------------------------------------------------

alter table core.mini_apps drop constraint mini_apps_permissions_valid;
alter table core.mini_apps add constraint mini_apps_permissions_valid check (
  requested_permissions <@ array[
    'identity', 'email', 'profile', 'group', 'notifications',
    'location', 'camera', 'files', 'calendar'
  ]::text[]
);

alter table core.mini_app_consents drop constraint mini_app_consents_scopes_valid;
alter table core.mini_app_consents add constraint mini_app_consents_scopes_valid check (
  scopes <@ array[
    'identity', 'email', 'profile', 'group', 'notifications',
    'location', 'camera', 'files', 'calendar'
  ]::text[]
);

-- ---------------------------------------------------------------------------
-- Uploads bucket now accepts documents too (pickFile), not just images.
-- Curated allowlist keeps executables/html out of the public bucket.
-- ---------------------------------------------------------------------------

update storage.buckets
set allowed_mime_types = array[
  'image/png', 'image/jpeg', 'image/webp', 'image/gif',
  'application/pdf', 'text/plain', 'text/csv', 'application/zip',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
]
where id = 'mini-app-uploads';

-- ---------------------------------------------------------------------------
-- Register the new actions so validate_mini_app_screens stays quiet.
-- ---------------------------------------------------------------------------

insert into core.mini_app_known_types (kind, name) values
  ('action', 'readClipboard'),
  ('action', 'pickDateTime'),
  ('action', 'pickFile'),
  ('action', 'authenticate'),
  ('action', 'scheduleReminder'),
  ('action', 'addCalendarEvent')
on conflict do nothing;
