-- Per-user key/value preferences: a generic store for client-side feature
-- settings (schedule filters, hidden subjects, custom schedules, notes,
-- selected schedule) so a user restores their setup after reinstalling.
-- Mirrors the user_settings slice: user_private table + owner RLS +
-- app_api_v1 functions behind thin public wrappers.

create table user_private.user_preferences (
  user_id uuid not null references auth.users(id) on delete cascade,
  key text not null,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, key),
  constraint user_preferences_key_not_empty check (length(trim(key)) > 0),
  constraint user_preferences_key_length check (length(key) <= 128),
  constraint user_preferences_value_size
    check (pg_column_size(value) <= 262144)
);

create trigger set_user_preferences_updated_at
before update on user_private.user_preferences
for each row execute function core.set_updated_at();

alter table user_private.user_preferences enable row level security;

create policy "users can read own preferences"
on user_private.user_preferences
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can insert own preferences"
on user_private.user_preferences
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own preferences"
on user_private.user_preferences
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own preferences"
on user_private.user_preferences
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete
on user_private.user_preferences to authenticated;
grant all on user_private.user_preferences to service_role;

-- ── app_api_v1 implementation ────────────────────────────────────────────────

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
        'key', p.key,
        'value', p.value,
        'updatedAt', p.updated_at
      )
      order by p.key
    ),
    '[]'::jsonb
  )
  from user_private.user_preferences p
  where p.user_id = (select auth.uid());
$$;

create or replace function app_api_v1.set_user_preference(
  p_key text,
  p_value jsonb
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  insert into user_private.user_preferences (user_id, key, value)
  values (v_user_id, p_key, coalesce(p_value, '{}'::jsonb))
  on conflict (user_id, key)
  do update set value = excluded.value;
end;
$$;

create or replace function app_api_v1.delete_user_preference(p_key text)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;

  delete from user_private.user_preferences
  where user_id = v_user_id and key = p_key;
end;
$$;

-- ── public wrappers ──────────────────────────────────────────────────────────

create or replace function public.get_user_preferences()
returns jsonb
language sql
stable
security invoker
set search_path = ''
as $$
  select app_api_v1.get_user_preferences();
$$;

create or replace function public.set_user_preference(
  p_key text,
  p_value jsonb
)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.set_user_preference(p_key, p_value);
$$;

create or replace function public.delete_user_preference(p_key text)
returns void
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.delete_user_preference(p_key);
$$;

revoke all on function public.get_user_preferences() from public;
grant execute on function public.get_user_preferences() to authenticated;

revoke all on function public.set_user_preference(text, jsonb) from public;
grant execute on function public.set_user_preference(text, jsonb)
to authenticated;

revoke all on function public.delete_user_preference(text) from public;
grant execute on function public.delete_user_preference(text) to authenticated;
