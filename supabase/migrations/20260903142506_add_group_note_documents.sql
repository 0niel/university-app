alter table core.group_notes
  add column if not exists document jsonb;
alter table core.group_notes
  add column if not exists document_revision bigint not null default 0;
alter table core.group_notes
  add column if not exists last_editor_id uuid references auth.users(id)
    on delete set null;
alter table core.group_notes
  add column if not exists collaborator_ids uuid[] not null default '{}'::uuid[];

alter table core.group_notes
  drop constraint if exists group_notes_document_revision_nonnegative;
alter table core.group_notes
  add constraint group_notes_document_revision_nonnegative
  check (document_revision >= 0);

create or replace function core.plain_text_from_delta(p_document jsonb)
returns text
language plpgsql
immutable
set search_path = ''
as $$
declare
  v_op jsonb;
  v_insert jsonb;
  v_text text := '';
begin
  if p_document is null or jsonb_typeof(p_document) is distinct from 'array' then
    return '';
  end if;
  for v_op in select * from jsonb_array_elements(p_document)
  loop
    v_insert := v_op -> 'insert';
    if jsonb_typeof(v_insert) = 'string' then
      v_text := v_text || (v_insert #>> '{}');
    end if;
  end loop;
  return v_text;
end;
$$;

revoke all on function core.plain_text_from_delta(jsonb) from public, anon;
grant execute on function core.plain_text_from_delta(jsonb)
  to authenticated, service_role;

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
          'document', note.document,
          'documentRevision', note.document_revision,
          'updatedByName', coalesce(
            (
              select split_part(profile.full_name, ' ', 1)
              from core.user_academic_profiles profile
              where profile.user_id = note.updated_by
                and profile.organization_id = note.organization_id
            ),
            ''
          ),
          'collaboratorNames', coalesce(
            (
              select jsonb_agg(
                distinct split_part(profile.full_name, ' ', 1)
                order by split_part(profile.full_name, ' ', 1)
              )
              from core.user_academic_profiles profile
              where profile.user_id = any(note.collaborator_ids)
                and profile.organization_id = note.organization_id
            ),
            '[]'::jsonb
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

create or replace function app_api_v1.save_group_note_document(
  p_note_id uuid,
  p_document jsonb,
  p_revision bigint
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_content text;
  v_result jsonb;
  v_current jsonb;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_revision < 0 then
    raise exception 'Invalid revision' using errcode = '22023';
  end if;
  if jsonb_typeof(p_document) is distinct from 'array' then
    raise exception 'Invalid document' using errcode = '22023';
  end if;
  if pg_column_size(p_document) > 2000000 then
    raise exception 'Document too large' using errcode = '22001';
  end if;
  if not core.can_edit_group_note(p_note_id, v_user_id) then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;
  perform core.enforce_rate_limit(
    'save_group_note_document',
    600,
    interval '1 hour'
  );

  v_content := left(core.plain_text_from_delta(p_document), 20000);

  update core.group_notes
  set document = p_document,
      document_revision = document_revision + 1,
      content = v_content,
      last_editor_id = v_user_id,
      updated_by = v_user_id,
      updated_at = clock_timestamp(),
      collaborator_ids = array_remove(collaborator_ids, v_user_id)
        || array[v_user_id]
  where id = p_note_id
    and document_revision = p_revision
  returning jsonb_build_object(
    'revision', document_revision,
    'updatedAt', updated_at,
    'conflict', false,
    'document', document,
    'content', content
  ) into v_result;

  if v_result is not null then
    return v_result;
  end if;

  select jsonb_build_object(
    'revision', note.document_revision,
    'updatedAt', note.updated_at,
    'conflict', true,
    'document', coalesce(note.document, '[]'::jsonb),
    'content', note.content
  )
  into v_current
  from core.group_notes note
  where note.id = p_note_id;

  if v_current is null then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;
  return v_current;
end;
$$;

create or replace function app_api_v1.rename_group_note(
  p_id uuid,
  p_title text
)
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
  perform core.enforce_rate_limit('rename_group_note', 60, interval '1 hour');
  update core.group_notes
  set title = core.validate_text(p_title, 'Название', 200, true),
      updated_by = v_user_id,
      updated_at = clock_timestamp()
  where id = p_id
    and owner_id = v_user_id;
  if not found then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;
end;
$$;

create or replace function app_api_v1.set_group_note_visibility(
  p_id uuid,
  p_visibility text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_org text;
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  if p_visibility not in ('group', 'personal') then
    raise exception 'Invalid note visibility' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit(
    'set_group_note_visibility',
    60,
    interval '1 hour'
  );

  select organization_id
  into v_org
  from core.group_notes
  where id = p_id and owner_id = v_user_id;
  if v_org is null then
    raise exception 'Note is unavailable' using errcode = '42501';
  end if;

  if p_visibility = 'group' then
    select group_row.id
    into v_group_id
    from core.study_group_members membership
    join core.study_groups group_row on group_row.id = membership.group_id
    where membership.user_id = v_user_id
      and group_row.organization_id = v_org;
    if v_group_id is null then
      raise exception 'Not in a group' using errcode = '42501';
    end if;
  end if;

  update core.group_notes
  set visibility = p_visibility,
      group_id = case when p_visibility = 'group' then v_group_id end,
      updated_by = v_user_id,
      updated_at = clock_timestamp()
  where id = p_id and owner_id = v_user_id;
end;
$$;

revoke all on function app_api_v1.get_group_notes(text) from public, anon;
revoke all on function app_api_v1.save_group_note_document(uuid, jsonb, bigint)
  from public, anon;
revoke all on function app_api_v1.rename_group_note(uuid, text)
  from public, anon;
revoke all on function app_api_v1.set_group_note_visibility(uuid, text)
  from public, anon;

grant execute on function app_api_v1.get_group_notes(text)
  to authenticated, service_role;
grant execute on function app_api_v1.save_group_note_document(uuid, jsonb, bigint)
  to authenticated, service_role;
grant execute on function app_api_v1.rename_group_note(uuid, text)
  to authenticated, service_role;
grant execute on function app_api_v1.set_group_note_visibility(uuid, text)
  to authenticated, service_role;

drop policy if exists "group note members read broadcast" on realtime.messages;
drop policy if exists "group note members send broadcast" on realtime.messages;

create policy "group note members read broadcast"
on realtime.messages
for select
to authenticated
using (
  extension = 'broadcast'
  and core.can_edit_group_note(
    core.group_note_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);

create policy "group note members send broadcast"
on realtime.messages
for insert
to authenticated
with check (
  extension = 'broadcast'
  and core.can_edit_group_note(
    core.group_note_id_from_realtime_topic((select realtime.topic())),
    (select auth.uid())
  )
);

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'core'
      and tablename = 'group_notes'
  ) then
    alter publication supabase_realtime add table core.group_notes;
  end if;
end
$$;

alter table core.group_notes replica identity full;

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
) values (
  'note-media',
  'note-media',
  true,
  20971520,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "public read note media" on storage.objects;
drop policy if exists "users upload own note media" on storage.objects;
drop policy if exists "users delete own note media" on storage.objects;

create policy "public read note media"
on storage.objects for select to public
using (bucket_id = 'note-media');

create policy "users upload own note media"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'note-media'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and name ~ (
    '^' || (select auth.uid())::text
    || '/[0-9a-f-]{36}\.(jpe?g|png|webp)$'
  )
);

create policy "users delete own note media"
on storage.objects for delete to authenticated
using (
  bucket_id = 'note-media'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);
