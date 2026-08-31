alter table core.group_notes
  add column if not exists revision bigint not null default 0;

alter table core.group_notes
  drop constraint if exists group_notes_revision_nonnegative;
alter table core.group_notes
  add constraint group_notes_revision_nonnegative check (revision >= 0);

create or replace function core.can_edit_group_note(
  p_note_id uuid,
  p_user_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from core.group_notes note
    where note.id = p_note_id
      and (
        (
          note.visibility = 'personal'
          and note.owner_id = p_user_id
          and exists (
            select 1
            from core.user_academic_profiles profile
            where profile.user_id = p_user_id
              and profile.organization_id = note.organization_id
          )
        )
        or (
          note.visibility = 'group'
          and (
            (
              note.group_id is not null
              and exists (
                select 1
                from core.study_group_members membership
                join core.study_groups group_row
                  on group_row.id = membership.group_id
                where membership.user_id = p_user_id
                  and membership.group_id = note.group_id
                  and group_row.organization_id = note.organization_id
              )
            )
            or (
              note.group_id is null
              and exists (
                select 1
                from core.user_academic_profiles profile
                where profile.user_id = p_user_id
                  and profile.organization_id = note.organization_id
                  and profile.academic_group = note.academic_group
              )
            )
          )
        )
      )
  );
$$;

revoke all on function core.can_edit_group_note(uuid, uuid)
  from public, anon;
grant execute on function core.can_edit_group_note(uuid, uuid)
  to authenticated, service_role;

create or replace function core.group_note_id_from_realtime_topic(
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
      '^group-note:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}'
      || '-[0-9a-f]{4}-[0-9a-f]{12}$'
    ) then split_part(p_topic, ':', 2)::uuid
  end;
$$;

revoke all on function core.group_note_id_from_realtime_topic(text)
  from public, anon;
grant execute on function core.group_note_id_from_realtime_topic(text)
  to authenticated, service_role;

drop policy if exists "group note members read presence"
  on realtime.messages;
drop policy if exists "group note members track presence"
  on realtime.messages;

create policy "group note members read presence"
on realtime.messages
for select
to authenticated
using (
  extension = 'presence'
  and core.can_edit_group_note(
    core.group_note_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);

create policy "group note members track presence"
on realtime.messages
for insert
to authenticated
with check (
  extension = 'presence'
  and core.can_edit_group_note(
    core.group_note_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);

drop policy if exists "study group members read notes" on core.group_notes;
drop policy if exists "study group members create notes" on core.group_notes;
drop policy if exists "study group members edit notes" on core.group_notes;
drop policy if exists "study group note owners delete notes" on core.group_notes;
drop policy if exists "organization members read notes" on core.group_notes;

create policy "organization members read notes"
on core.group_notes for select to authenticated
using (core.can_edit_group_note(id, (select auth.uid())));

revoke insert, update, delete on core.group_notes from authenticated;

create or replace function app_api_v1.get_group_notes(
  p_organization_id text
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  return coalesce(
    (
      select jsonb_agg(
        jsonb_build_object(
          'id', note.id,
          'title', note.title,
          'content', note.content,
          'createdAt', note.created_at,
          'updatedAt', note.updated_at,
          'revision', note.revision,
          'isMine', note.owner_id = v_user_id,
          'isPersonal', note.visibility = 'personal',
          'updatedByName', coalesce(
            (
              select split_part(profile.full_name, ' ', 1)
              from core.user_academic_profiles profile
              where profile.user_id = note.updated_by
                and profile.organization_id = note.organization_id
            ),
            ''
          )
        )
        order by note.updated_at desc
      )
      from core.group_notes note
      where note.organization_id = p_organization_id
        and core.can_edit_group_note(note.id, v_user_id)
    ),
    '[]'::jsonb
  );
end;
$$;

create or replace function app_api_v1.create_group_note(
  p_organization_id text,
  p_title text,
  p_visibility text default 'group'::text
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_visibility text := coalesce(p_visibility, 'group');
  v_academic_group text;
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  select profile.academic_group
  into v_academic_group
  from core.user_academic_profiles profile
  where profile.user_id = v_user_id
    and profile.organization_id = p_organization_id;
  if not found then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;
  if v_visibility not in ('group', 'personal') then
    raise exception 'Invalid note visibility' using errcode = '22023';
  end if;

  if v_visibility = 'group' then
    select group_row.id
    into v_group_id
    from core.study_group_members membership
    join core.study_groups group_row on group_row.id = membership.group_id
    where membership.user_id = v_user_id
      and group_row.organization_id = p_organization_id;
    if v_group_id is null then
      raise exception 'Not in a group' using errcode = '42501';
    end if;
  end if;

  perform core.enforce_rate_limit(
    'create_group_note',
    30,
    interval '1 hour'
  );
  insert into core.group_notes (
    organization_id,
    academic_group,
    group_id,
    owner_id,
    visibility,
    title,
    created_by,
    updated_by
  )
  values (
    p_organization_id,
    v_academic_group,
    case when v_visibility = 'group' then v_group_id end,
    v_user_id,
    v_visibility,
    core.validate_text(p_title, 'Название', 200, true),
    v_user_id,
    v_user_id
  )
  returning id into v_id;
  return v_id;
end;
$$;

drop function if exists public.save_group_note(uuid, text, text);
drop function if exists app_api_v1.save_group_note(uuid, text, text);

create or replace function app_api_v1.save_group_note(
  p_id uuid,
  p_title text,
  p_content text,
  p_expected_revision bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_expected_revision < 0 then
    raise exception 'Invalid revision' using errcode = '22023';
  end if;
  if not core.can_edit_group_note(p_id, v_user_id) then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit('save_group_note', 120, interval '1 hour');
  update core.group_notes
  set title = core.validate_text(p_title, 'Название', 200, true),
      content = core.validate_text(p_content, 'Содержимое', 20000, false),
      updated_by = v_user_id,
      updated_at = clock_timestamp(),
      revision = revision + 1
  where id = p_id
    and revision = p_expected_revision
  returning jsonb_build_object(
    'revision', revision,
    'updatedAt', updated_at
  ) into v_result;
  if v_result is null then
    raise sqlstate 'PT409'
      using message = 'Group note was modified by another editor';
  end if;
  return v_result;
end;
$$;

create or replace function app_api_v1.delete_group_note(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  delete from core.group_notes note
  where note.id = p_id
    and note.owner_id = v_user_id
    and exists (
      select 1
      from core.user_academic_profiles profile
      where profile.user_id = v_user_id
        and profile.organization_id = note.organization_id
    );
  if not found then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function public.save_group_note(
  p_id uuid,
  p_title text,
  p_content text,
  p_expected_revision bigint
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.save_group_note(
    p_id,
    p_title,
    p_content,
    p_expected_revision
  );
$$;

revoke all on function app_api_v1.get_group_notes(text) from public, anon;
revoke all on function app_api_v1.create_group_note(text, text, text)
  from public, anon;
revoke all on function app_api_v1.save_group_note(uuid, text, text, bigint)
  from public, anon;
revoke all on function app_api_v1.delete_group_note(uuid) from public, anon;
grant execute on function app_api_v1.get_group_notes(text)
  to authenticated, service_role;
grant execute on function app_api_v1.create_group_note(text, text, text)
  to authenticated, service_role;
grant execute on function app_api_v1.save_group_note(uuid, text, text, bigint)
  to authenticated, service_role;
grant execute on function app_api_v1.delete_group_note(uuid)
  to authenticated, service_role;

revoke all on function public.save_group_note(uuid, text, text, bigint)
  from public, anon;
grant execute on function public.save_group_note(uuid, text, text, bigint)
  to authenticated, service_role;
