create or replace function core.group_space_id_from_realtime_topic(
  p_topic text
)
returns uuid
language sql
immutable
security definer
set search_path = ''
as $$
  select case
    when p_topic ~* (
      '^group-presence:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}'
      || '-[0-9a-f]{4}-[0-9a-f]{12}$'
    ) then split_part(p_topic, ':', 2)::uuid
  end;
$$;

revoke all on function core.group_space_id_from_realtime_topic(text)
from public, anon;
grant execute on function core.group_space_id_from_realtime_topic(text)
to authenticated, service_role;

drop policy if exists "group space members read presence"
on realtime.messages;
drop policy if exists "group space members track presence"
on realtime.messages;

create policy "group space members read presence"
on realtime.messages
for select
to authenticated
using (
  extension = 'presence'
  and core.is_study_group_member(
    core.group_space_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);

create policy "group space members track presence"
on realtime.messages
for insert
to authenticated
with check (
  extension = 'presence'
  and core.is_study_group_member(
    core.group_space_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);
