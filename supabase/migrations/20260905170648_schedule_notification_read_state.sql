create table user_private.schedule_notification_reads (
  user_id uuid not null references auth.users(id) on delete cascade,
  change_id bigint not null check (change_id > 0),
  read_at timestamptz not null default now(),
  primary key (user_id, change_id)
);

alter table user_private.schedule_notification_reads enable row level security;

create policy schedule_notification_reads_owner_select
on user_private.schedule_notification_reads for select to authenticated
using (user_id = (select auth.uid()));

create policy schedule_notification_reads_owner_insert
on user_private.schedule_notification_reads for insert to authenticated
with check (
  user_id = (select auth.uid())
  and exists (
    select 1 from core.schedule_item_change change
    where change.id = change_id
  )
);

revoke all on user_private.schedule_notification_reads from public, anon, authenticated;
grant select, insert on user_private.schedule_notification_reads to authenticated;
grant all on user_private.schedule_notification_reads to service_role;

create or replace function public.get_schedule_notification_read_ids(p_expected_user_id uuid)
returns jsonb
language plpgsql
stable
security invoker
set search_path = ''
as $$
begin
  if (select auth.uid()) is null
    or p_expected_user_id is distinct from (select auth.uid()) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  return (
    select coalesce(jsonb_agg(marker.change_id::text order by marker.change_id), '[]'::jsonb)
    from user_private.schedule_notification_reads marker
    where marker.user_id = (select auth.uid())
  );
end;
$$;

create or replace function public.mark_schedule_notifications_read(p_expected_user_id uuid, p_ids bigint[])
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if (select auth.uid()) is null
    or p_expected_user_id is distinct from (select auth.uid()) then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if coalesce(cardinality(p_ids), 0) > 200 then
    raise exception 'Too many schedule notification identities' using errcode = '22023';
  end if;

  insert into user_private.schedule_notification_reads (user_id, change_id)
  select (select auth.uid()), ids.id
  from (select distinct unnest(p_ids) as id) ids
  where ids.id > 0
    and exists (
      select 1 from core.schedule_item_change change
      where change.id = ids.id
    )
  on conflict (user_id, change_id) do nothing;
end;
$$;

revoke all on function public.get_schedule_notification_read_ids(uuid) from public, anon;
revoke all on function public.mark_schedule_notifications_read(uuid,bigint[]) from public, anon;
grant execute on function public.get_schedule_notification_read_ids(uuid) to authenticated, service_role;
grant execute on function public.mark_schedule_notifications_read(uuid,bigint[]) to authenticated, service_role;
