create table core.promo_banner_dismissals (
  user_id uuid not null references auth.users(id) on delete cascade,
  banner_id uuid not null references core.promo_banners(id) on delete cascade,
  banner_version integer not null check (banner_version >= 1),
  hidden boolean not null default false,
  snoozed_until timestamptz,
  updated_at timestamptz not null default now(),
  primary key (user_id, banner_id, banner_version),
  check (hidden or snoozed_until is not null)
);

create index promo_banner_dismissals_banner_idx
on core.promo_banner_dismissals (banner_id);

insert into core.promo_banner_dismissals (
  user_id, banner_id, banner_version, hidden, snoozed_until
)
select e.user_id, b.id, b.version,
  bool_or(e.event = 'hide'),
  max(e.created_at + make_interval(hours => b.snooze_hours))
    filter (where e.event = 'snooze')
from core.promo_banner_events e
join core.promo_banners b on b.id = e.banner_id
where e.user_id is not null
  and e.event in ('hide', 'snooze')
  and e.created_at >= b.updated_at
group by e.user_id, b.id, b.version;

alter table core.promo_banner_dismissals enable row level security;
revoke all on core.promo_banner_dismissals from public, anon, authenticated;

create policy promo_banner_dismissals_owner_read
on core.promo_banner_dismissals for select to authenticated
using ((select auth.uid()) = user_id);

create or replace function app_api_v1.get_promo_banner_dismissals(
  p_expected_user_id uuid
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null
    or p_expected_user_id is distinct from (select auth.uid()) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  return (
    select coalesce(jsonb_agg(jsonb_build_object(
      'bannerId', d.banner_id,
      'version', d.banner_version,
      'hidden', d.hidden,
      'snoozedUntil', d.snoozed_until
    )), '[]'::jsonb)
    from core.promo_banner_dismissals d
    where d.user_id = (select auth.uid())
  );
end;
$$;

create or replace function app_api_v1.save_promo_banner_dismissal(
  p_expected_user_id uuid,
  p_banner_id uuid,
  p_banner_version integer,
  p_hidden boolean default false,
  p_snoozed_until timestamptz default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null
    or p_expected_user_id is distinct from (select auth.uid()) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_banner_version is null or p_banner_version < 1
    or p_hidden is null
    or (not p_hidden and p_snoozed_until is null)
    or p_snoozed_until > now() + interval '31 days' then
    raise exception 'Invalid promo dismissal' using errcode = '22023';
  end if;
  if not exists (
    select 1 from core.promo_banners b
    where b.id = p_banner_id and b.version >= p_banner_version
  ) then
    return;
  end if;
  insert into core.promo_banner_dismissals (
    user_id, banner_id, banner_version, hidden, snoozed_until
  ) values (
    (select auth.uid()), p_banner_id, p_banner_version,
    p_hidden, p_snoozed_until
  )
  on conflict (user_id, banner_id, banner_version) do update
  set hidden = core.promo_banner_dismissals.hidden or excluded.hidden,
      snoozed_until = greatest(
        core.promo_banner_dismissals.snoozed_until, excluded.snoozed_until
      ),
      updated_at = now();
end;
$$;

create or replace function public.get_promo_banner_dismissals(
  p_expected_user_id uuid
)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_promo_banner_dismissals(p_expected_user_id);
$$;

create or replace function public.save_promo_banner_dismissal(
  p_expected_user_id uuid,
  p_banner_id uuid,
  p_banner_version integer,
  p_hidden boolean default false,
  p_snoozed_until timestamptz default null
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.save_promo_banner_dismissal(
    p_expected_user_id, p_banner_id, p_banner_version,
    p_hidden, p_snoozed_until
  );
$$;

revoke all on function app_api_v1.get_promo_banner_dismissals(uuid)
from public, anon;
revoke all on function app_api_v1.save_promo_banner_dismissal(
  uuid, uuid, integer, boolean, timestamptz
) from public, anon;
revoke all on function public.get_promo_banner_dismissals(uuid)
from public, anon;
revoke all on function public.save_promo_banner_dismissal(
  uuid, uuid, integer, boolean, timestamptz
) from public, anon;

grant execute on function app_api_v1.get_promo_banner_dismissals(uuid)
to authenticated, service_role;
grant execute on function app_api_v1.save_promo_banner_dismissal(
  uuid, uuid, integer, boolean, timestamptz
) to authenticated, service_role;
grant execute on function public.get_promo_banner_dismissals(uuid)
to authenticated, service_role;
grant execute on function public.save_promo_banner_dismissal(
  uuid, uuid, integer, boolean, timestamptz
) to authenticated, service_role;
