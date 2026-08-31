-- Mini apps platform: first-party "service" source kind.
--
-- A service mini app is owned by the platform (not a user) and its screens
-- are produced by a dedicated edge function named `miniapp-svc-<slug>`. The
-- proxy recognises source_kind = 'service' and routes the request to that
-- function internally (service-role auth) instead of fetching an external
-- origin — so first-party features (free rooms, etc.) live in edge functions
-- under the `miniapp-svc-` prefix while reusing the whole catalog/runner.
--
-- This migration only opens the source kind, relaxes ownership and seeds the
-- free-rooms app. The proxy routing and the function ship separately.

-- ---------------------------------------------------------------------------
-- Allow the new source kind; service apps have no human owner.
-- ---------------------------------------------------------------------------

alter table core.mini_apps drop constraint if exists mini_apps_source_kind_valid;
alter table core.mini_apps add constraint mini_apps_source_kind_valid check (
  source_kind in ('hosted', 'remote', 'service')
);

alter table core.mini_apps alter column owner_id drop not null;

-- ---------------------------------------------------------------------------
-- Only the platform (service_role, auth.uid() is null) may mark an app as a
-- service app. Authenticated users (incl. moderators) can still manage an
-- existing service app, but cannot create one or convert an app into one —
-- this keeps the `submit_mini_app` RPC safe without touching its signature.
-- ---------------------------------------------------------------------------

create or replace function core.mini_apps_guard_service_kind()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.source_kind = 'service'
    and (select auth.uid()) is not null
    and (tg_op = 'INSERT' or old.source_kind is distinct from 'service')
  then
    raise exception 'service mini apps are reserved for the platform';
  end if;
  return new;
end;
$$;

drop trigger if exists guard_mini_apps_service_kind on core.mini_apps;
create trigger guard_mini_apps_service_kind
before insert or update on core.mini_apps
for each row execute function core.mini_apps_guard_service_kind();

-- ---------------------------------------------------------------------------
-- Seed: free rooms as a first-party service app. Served by the
-- `miniapp-svc-free-rooms` edge function. No owner, published immediately.
-- ---------------------------------------------------------------------------

insert into core.mini_apps (
  organization_id, owner_id, slug, name, description,
  icon_emoji, accent_color, category, tags,
  source_kind, status, published_at
)
select
  'mirea', null, 'free-rooms', 'Свободные аудитории',
  'Аудитории, свободные прямо сейчас — по корпусам, с временем до ближайшей пары.',
  '🚪', '#1FB872', 'campus', array['аудитории', 'корпуса', 'кампус'],
  'service', 'published', now()
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id, slug) do nothing;
