create temp table _organization_function_defs as
select
  p.oid,
  n.nspname as function_schema,
  p.proname as function_name,
  case
    when n.nspname = 'core' then 1
    when n.nspname = 'ingest_v1' and p.proname <> 'upsert_schedule_payload' then 2
    when n.nspname = 'ingest_v1' then 3
    when n.nspname = 'app_api_v1' then 4
    when n.nspname = 'public' then 5
    else 9
  end as create_order,
  replace(
    replace(pg_get_functiondef(p.oid), 'institutions', 'organizations'),
    'institution',
    'organization'
  ) as definition
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where p.prokind = 'f'
  and n.nspname in ('app_api_v1', 'public', 'ingest_v1', 'core')
  and pg_get_functiondef(p.oid) ~ 'institution|institutions';

drop trigger if exists set_schedule_occurrence_calendar_fields
on core.schedule_occurrences;

do $$
declare
  r record;
begin
  for r in
    select
      n.nspname as function_schema,
      p.proname as function_name,
      pg_get_function_identity_arguments(p.oid) as function_args
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where p.oid in (select oid from _organization_function_defs)
  loop
    execute format(
      'drop function %I.%I(%s)',
      r.function_schema,
      r.function_name,
      r.function_args
    );
  end loop;
end $$;

alter table core.institutions rename to organizations;

alter table core.organizations
  add column if not exists organization_type text not null default 'university',
  add column if not exists parent_id text references core.organizations(id) on delete set null,
  add constraint organizations_type_not_empty
    check (length(trim(organization_type)) > 0),
  add constraint organizations_parent_not_self
    check (parent_id is null or parent_id <> id);

do $$
declare
  r record;
begin
  for r in
    select table_schema, table_name
    from information_schema.columns
    where column_name = 'institution_id'
      and table_schema in ('core', 'internal')
  loop
    execute format(
      'alter table %I.%I rename column institution_id to organization_id',
      r.table_schema,
      r.table_name
    );
  end loop;
end $$;

alter trigger set_institutions_updated_at
on core.organizations
rename to set_organizations_updated_at;

do $$
declare
  r record;
  v_new_name text;
begin
  for r in
    select
      n.nspname as table_schema,
      c.relname as table_name,
      con.conrelid,
      con.conname
    from pg_constraint con
    join pg_class c on c.oid = con.conrelid
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname in ('core', 'internal')
      and con.conname ~ 'institution|institutions'
  loop
    v_new_name := replace(
      replace(r.conname, 'institutions', 'organizations'),
      'institution',
      'organization'
    );

    if v_new_name <> r.conname
      and not exists (
        select 1
        from pg_constraint existing
        where existing.conrelid = r.conrelid
          and existing.conname = v_new_name
      )
    then
      execute format(
        'alter table %I.%I rename constraint %I to %I',
        r.table_schema,
        r.table_name,
        r.conname,
        v_new_name
      );
    end if;
  end loop;
end $$;

do $$
declare
  r record;
  v_new_name text;
begin
  for r in
    select n.nspname as index_schema, c.relname as index_name
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where c.relkind = 'i'
      and n.nspname in ('core', 'internal')
      and c.relname ~ 'institution|institutions'
  loop
    v_new_name := replace(
      replace(r.index_name, 'institutions', 'organizations'),
      'institution',
      'organization'
    );

    if v_new_name <> r.index_name
      and not exists (
        select 1
        from pg_class existing
        join pg_namespace existing_schema on existing_schema.oid = existing.relnamespace
        where existing_schema.nspname = r.index_schema
          and existing.relname = v_new_name
      )
    then
      execute format(
        'alter index %I.%I rename to %I',
        r.index_schema,
        r.index_name,
        v_new_name
      );
    end if;
  end loop;
end $$;

do $$
declare
  r record;
  v_new_name text;
begin
  for r in
    select n.nspname as table_schema, c.relname as table_name, p.polname
    from pg_policy p
    join pg_class c on c.oid = p.polrelid
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname in ('core', 'internal')
      and p.polname ~ 'institution|institutions'
  loop
    v_new_name := replace(
      replace(r.polname, 'institutions', 'organizations'),
      'institution',
      'organization'
    );

    if v_new_name <> r.polname then
      execute format(
        'alter policy %I on %I.%I rename to %I',
        r.polname,
        r.table_schema,
        r.table_name,
        v_new_name
      );
    end if;
  end loop;
end $$;

do $$
declare
  r record;
begin
  for r in
    select definition
    from _organization_function_defs
    order by create_order, function_schema, function_name
  loop
    execute r.definition;
  end loop;
end $$;

create trigger set_schedule_occurrence_calendar_fields
before insert or update on core.schedule_occurrences
for each row
execute function core.set_schedule_occurrence_calendar_fields();

grant select on core.organizations to anon, authenticated;

grant usage on schema app_api_v1 to anon, authenticated;
grant execute on all functions in schema app_api_v1 to anon, authenticated;

grant execute on function public.get_news_feed(text, integer, integer) to anon, authenticated;
grant execute on function public.search_schedule_targets(text, text, text, integer) to anon, authenticated;
grant execute on function public.search_schedule_entities(text, text, text, integer) to anon, authenticated;
grant execute on function public.get_schedule_for_target(text, text, text) to anon, authenticated;
grant execute on function public.get_schedule_for_entity(text, text, date, date, text) to anon, authenticated;
grant execute on function public.get_schedule_occurrences_for_entity(text, text, timestamptz, timestamptz, text) to anon, authenticated;

revoke execute on function public.ingest_news_items(text, jsonb, jsonb, uuid) from public, anon, authenticated;
revoke execute on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid) from public, anon, authenticated;
grant execute on function public.ingest_news_items(text, jsonb, jsonb, uuid) to service_role;
grant execute on function public.ingest_schedule_payload(text, jsonb, jsonb, uuid) to service_role;

drop table _organization_function_defs;
