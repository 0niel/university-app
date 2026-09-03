begin;

do $$
declare
  v_definition text;
  v_policy_count integer;
begin
  if to_regprocedure(
    'public.save_group_note(uuid,text,text,bigint)'
  ) is null then
    raise exception 'Revision-aware note save RPC is missing';
  end if;
  if to_regprocedure('public.save_group_note(uuid,text,text)') is not null then
    raise exception 'Blind legacy note save RPC is still exposed';
  end if;
  if has_function_privilege(
    'anon',
    'public.save_group_note(uuid,text,text,bigint)',
    'EXECUTE'
  ) then
    raise exception 'Anonymous role can save group notes';
  end if;
  if not has_function_privilege(
    'authenticated',
    'public.save_group_note(uuid,text,text,bigint)',
    'EXECUTE'
  ) then
    raise exception 'Authenticated revision save contract is missing';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.save_group_note(uuid,text,text,bigint)'::regprocedure
  );
  if position('revision = revision + 1' in v_definition) = 0 then
    raise exception 'Note revision is not incremented atomically';
  end if;
  if position('raise sqlstate ''PT409''' in v_definition) = 0 then
    raise exception 'Stable note conflict contract is missing';
  end if;

  v_definition := pg_get_functiondef(
    'app_api_v1.get_group_notes(text)'::regprocedure
  );
  if position('''revision'', note.revision' in v_definition) = 0 then
    raise exception 'Note reads do not expose the revision';
  end if;

  select count(*)
  into v_policy_count
  from pg_policies policy
  where policy.schemaname = 'realtime'
    and policy.tablename = 'messages'
    and policy.policyname in (
      'group note members read presence',
      'group note members track presence'
    )
    and coalesce(policy.qual, policy.with_check) like '%can_edit_group_note%'
    and coalesce(policy.qual, policy.with_check) like '%presence%';
  if v_policy_count <> 2 then
    raise exception 'Private note presence authorization is incomplete';
  end if;
end;
$$;

do $$
declare
  v_owner uuid := extensions.gen_random_uuid();
  v_member uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_foreign uuid := extensions.gen_random_uuid();
  v_group_id uuid := extensions.gen_random_uuid();
  v_note_id uuid;
  v_private_note_id uuid;
  v_result jsonb;
  v_rows jsonb;
begin
  insert into core.organizations (id, name)
  values
    ('collab-test-a', 'Collab Test A'),
    ('collab-test-b', 'Collab Test B');

  insert into auth.users (id)
  values (v_owner), (v_member), (v_outsider), (v_foreign);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    academic_group
  )
  values
    (v_owner, 'collab-test-a', 'IKBO-01'),
    (v_member, 'collab-test-a', 'IKBO-01'),
    (v_outsider, 'collab-test-a', 'IKBO-01'),
    (v_foreign, 'collab-test-b', 'IKBO-01');

  insert into core.study_groups (
    id,
    organization_id,
    owner_id,
    name,
    join_code
  )
  values (
    v_group_id,
    'collab-test-a',
    v_owner,
    'Test group',
    'COLLAB01'
  );
  insert into core.study_group_members (group_id, user_id, role)
  values
    (v_group_id, v_owner, 'owner'),
    (v_group_id, v_member, 'member');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_owner::text, true);
  v_note_id := app_api_v1.create_group_note(
    'collab-test-a',
    'Shared note',
    'group'
  );
  v_private_note_id := app_api_v1.create_group_note(
    'collab-test-a',
    'Personal note',
    'personal'
  );
  v_rows := public.get_group_notes('collab-test-a');
  if not exists (
    select 1 from jsonb_array_elements(v_rows) note
    where (note->>'id')::uuid = v_private_note_id
      and (note->>'isPersonal')::boolean
  ) then
    raise exception 'Owner cannot read their personal note';
  end if;

  v_result := app_api_v1.save_group_note(
    v_note_id,
    'Shared note',
    'First version',
    0
  );
  if (v_result->>'revision')::bigint <> 1 then
    raise exception 'First revision-aware save returned a wrong revision';
  end if;

  begin
    perform app_api_v1.save_group_note(
      v_note_id,
      'Stale title',
      'Stale version',
      0
    );
    raise exception 'Stale note save succeeded';
  exception
    when sqlstate 'PT409' then null;
  end;

  if (
    select content
    from core.group_notes
    where id = v_note_id
  ) <> 'First version' then
    raise exception 'A stale save changed note content';
  end if;

  perform set_config('request.jwt.claim.sub', v_member::text, true);
  v_rows := public.get_group_notes('collab-test-a');
  if not exists (
    select 1 from jsonb_array_elements(v_rows) note
    where (note->>'id')::uuid = v_note_id
  ) or exists (
    select 1 from jsonb_array_elements(v_rows) note
    where (note->>'id')::uuid = v_private_note_id
  ) then
    raise exception 'Group note reads do not preserve personal visibility';
  end if;
  v_result := app_api_v1.save_group_note(
    v_note_id,
    'Shared note',
    'Groupmate version',
    1
  );
  if (v_result->>'revision')::bigint <> 2 then
    raise exception 'Groupmate save did not advance the revision';
  end if;

  begin
    perform app_api_v1.delete_group_note(v_note_id);
    raise exception 'A non-owner deleted the note';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  v_rows := public.get_group_notes('collab-test-a');
  if jsonb_array_length(v_rows) <> 0 then
    raise exception 'Same-organization non-member can read study-group notes';
  end if;

  perform set_config('request.jwt.claim.sub', v_foreign::text, true);
  begin
    select app_api_v1.get_group_notes('collab-test-a') into v_rows;
    if jsonb_array_length(v_rows) <> 0 then
      raise exception 'Cross-organization group note leaked';
    end if;
  exception
    when insufficient_privilege then null;
  end;

  begin
    perform app_api_v1.create_group_note(
      'collab-test-a',
      'Foreign personal note',
      'personal'
    );
    raise exception 'Personal note was created in a foreign organization';
  exception
    when insufficient_privilege then null;
  end;

end;
$$;

rollback;
