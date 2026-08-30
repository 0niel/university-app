alter table user_private.user_preferences
  add column revision bigint not null default 1;

alter table user_private.user_preferences
  add constraint user_preferences_revision_positive
  check (revision > 0);

create or replace function app_api_v1.get_user_preferences()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'key', preference.key,
        'value', preference.value,
        'revision', preference.revision,
        'updatedAt', preference.updated_at
      ) order by preference.key
    ),
    '[]'::jsonb
  )
  from user_private.user_preferences preference
  where preference.user_id = (select auth.uid());
$$;

create or replace function app_api_v1.get_user_preference(p_key text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select jsonb_build_object(
    'key', preference.key,
    'value', preference.value,
    'revision', preference.revision,
    'updatedAt', preference.updated_at
  )
  from user_private.user_preferences preference
  where preference.user_id = (select auth.uid())
    and preference.key = p_key;
$$;

drop function public.set_user_preference(text, jsonb);
drop function app_api_v1.set_user_preference(text, jsonb);

create function app_api_v1.set_user_preference(
  p_key text,
  p_value jsonb,
  p_expected_revision bigint default null
)
returns bigint
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_revision bigint;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit(
    'set_user_preference', 120, interval '1 hour'
  );
  if char_length(coalesce(p_key, '')) = 0 or char_length(p_key) > 100 then
    raise exception 'Preference key is invalid' using errcode = '22023';
  end if;
  if pg_column_size(coalesce(p_value, '{}'::jsonb)) > 262144 then
    raise exception 'Preference value is too large' using errcode = '22023';
  end if;

  if p_expected_revision is null then
    insert into user_private.user_preferences as current_preference (
      user_id, key, value, revision
    ) values (
      v_user_id, p_key, coalesce(p_value, '{}'::jsonb), 1
    )
    on conflict (user_id, key) do update set
      value = excluded.value,
      revision = current_preference.revision + 1
    returning revision into v_revision;
  elsif p_expected_revision = 0 then
    insert into user_private.user_preferences (
      user_id, key, value, revision
    ) values (
      v_user_id, p_key, coalesce(p_value, '{}'::jsonb), 1
    )
    on conflict (user_id, key) do nothing
    returning revision into v_revision;
  else
    update user_private.user_preferences preference
    set value = coalesce(p_value, '{}'::jsonb),
        revision = preference.revision + 1
    where preference.user_id = v_user_id
      and preference.key = p_key
      and preference.revision = p_expected_revision
    returning revision into v_revision;
  end if;

  if v_revision is null then
    raise exception 'Preference revision conflict' using errcode = 'PT409';
  end if;
  return v_revision;
end;
$$;

create or replace function public.get_user_preference(p_key text)
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$ select app_api_v1.get_user_preference(p_key); $$;

create function public.set_user_preference(
  p_key text,
  p_value jsonb,
  p_expected_revision bigint default null
)
returns bigint
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_user_preference(
    p_key, p_value, p_expected_revision
  );
$$;

revoke all on function app_api_v1.get_user_preferences()
from public, anon;
revoke all on function app_api_v1.get_user_preference(text)
from public, anon;
revoke all on function app_api_v1.set_user_preference(text, jsonb, bigint)
from public, anon;
revoke all on function app_api_v1.delete_user_preference(text)
from public, anon;
grant execute on function app_api_v1.get_user_preferences()
to authenticated, service_role;
grant execute on function app_api_v1.get_user_preference(text)
to authenticated, service_role;
grant execute on function app_api_v1.set_user_preference(
  text, jsonb, bigint
) to authenticated, service_role;
grant execute on function app_api_v1.delete_user_preference(text)
to authenticated, service_role;

revoke all on function public.get_user_preferences()
from public, anon;
revoke all on function public.get_user_preference(text)
from public, anon;
revoke all on function public.set_user_preference(text, jsonb, bigint)
from public, anon;
revoke all on function public.delete_user_preference(text)
from public, anon;
grant execute on function public.get_user_preferences()
to authenticated, service_role;
grant execute on function public.get_user_preference(text)
to authenticated, service_role;
grant execute on function public.set_user_preference(
  text, jsonb, bigint
) to authenticated, service_role;
grant execute on function public.delete_user_preference(text)
to authenticated, service_role;
