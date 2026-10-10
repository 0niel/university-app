create function internal.require_content_actor(
  p_user_id uuid,
  p_shared boolean default true
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user record;
  v_confirmed_at timestamptz;
begin
  if p_user_id is null then
    raise exception 'Требуется вход в аккаунт' using errcode = '42501';
  end if;
  select is_anonymous, deleted_at, banned_until, created_at,
    confirmed_at, email_confirmed_at, phone_confirmed_at
  into v_user from auth.users where id = p_user_id;
  if not found or v_user.deleted_at is not null then
    raise exception 'Требуется вход в аккаунт' using errcode = '42501';
  end if;
  if v_user.banned_until > clock_timestamp() then
    raise exception 'Аккаунт временно заблокирован' using errcode = '42501';
  end if;
  if not p_shared then
    return;
  end if;
  if coalesce(v_user.is_anonymous, false) then
    raise exception 'Подтвердите аккаунт для публикации и голосования'
      using errcode = '42501', hint = 'content_account_unverified';
  end if;

  v_confirmed_at := greatest(
    v_user.confirmed_at, v_user.email_confirmed_at, v_user.phone_confirmed_at
  );
  if v_confirmed_at is null then
    select min(identity_row.created_at) into v_confirmed_at
    from auth.identities identity_row
    where identity_row.user_id = p_user_id
      and identity_row.provider not in ('email', 'phone', 'anonymous')
      and identity_row.identity_data ->> 'email_verified' = 'true';
  end if;
  if v_confirmed_at is null then
    raise exception 'Подтвердите аккаунт для публикации и голосования'
      using errcode = '42501', hint = 'content_account_unverified';
  end if;
  if v_user.created_at is null
    or greatest(v_user.created_at, v_confirmed_at) > clock_timestamp() - interval '24 hours' then
    raise exception 'Публикации и голосование доступны через 24 часа после подтверждения аккаунта'
      using errcode = '42501', hint = 'content_account_cooldown';
  end if;
end;
$$;

revoke all on function internal.require_content_actor(uuid, boolean)
from public, anon, authenticated, service_role;

create function internal.require_permanent_content_actor(
  p_user_id uuid,
  p_shared boolean default false
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform internal.require_content_actor(p_user_id, p_shared);
  if exists (select 1 from auth.users where id = p_user_id and is_anonymous) then
    raise exception 'Войдите в постоянный аккаунт для создания и изменения контента'
      using errcode = '42501', hint = 'content_account_unverified';
  end if;
end;
$$;

revoke all on function internal.require_permanent_content_actor(uuid, boolean)
from public, anon, authenticated, service_role;

create function internal.content_action_requires_trust(p_action text)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select coalesce(p_action = 'mini_app_deploy' or (
    split_part(p_action, ':', 1) in ('create', 'edit')
    and split_part(p_action, ':', 2) = any(array[
      'core.campus_events', 'core.group_links', 'core.group_post_comments',
      'core.group_post_likes', 'core.group_posts', 'core.lesson_materials',
      'core.lesson_reactions', 'core.lesson_reviews', 'core.teacher_reviews',
      'core.lost_found_items', 'core.marketplace_listings', 'core.mentor_profiles',
      'core.teams', 'core.polls', 'core.poll_questions', 'core.poll_options',
      'core.poll_answers', 'core.poll_votes', 'core.material_likes',
      'core.mini_apps', 'core.mini_app_screens', 'core.mini_app_ratings',
      'core.mini_app_reports', 'core.room_photos', 'core.map_proposals',
      'core.map_room_confirmations'
    ])
  ), false);
$$;

revoke all on function internal.content_action_requires_trust(text)
from public, anon, authenticated, service_role;

create function internal.content_action_requires_member(p_action text)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select coalesce(internal.content_action_requires_trust(p_action)
    or p_action = 'upload_file' or (
    split_part(p_action, ':', 1) in ('create', 'edit', 'moderate')
    and split_part(p_action, ':', 2) = any(array[
      'core.campus_events', 'core.event_rsvps', 'core.exam_readiness',
      'core.friendships', 'core.group_links', 'core.group_notes',
      'core.group_post_comments', 'core.group_post_likes', 'core.group_posts',
      'core.lesson_materials', 'core.lesson_reactions', 'core.lesson_reviews',
      'core.teacher_reviews', 'core.lost_found_items', 'core.lost_found_upload_tickets',
      'core.marketplace_listings', 'core.material_likes', 'core.mentor_profiles',
      'core.mentor_requests', 'core.mini_app_deploy_tokens', 'core.mini_app_ratings',
      'core.mini_app_reports', 'core.mini_app_screens', 'core.mini_app_secrets',
      'core.mini_app_user_storage', 'core.mini_apps', 'core.poll_answers',
      'core.poll_options', 'core.poll_participations', 'core.poll_questions',
      'core.poll_votes', 'core.polls', 'core.room_photos', 'core.map_proposals',
      'core.map_room_confirmations', 'core.scheduled_reminders',
      'core.study_group_invites', 'core.study_group_members', 'core.study_groups',
      'core.team_applications', 'core.team_members', 'core.teams',
      'core.user_activities', 'core.user_deadlines', 'core.user_semester_stats',
      'core.wifi_submit_log', 'public.friend_locations'
    ])
  ), false);
$$;

revoke all on function internal.content_action_requires_member(text)
from public, anon, authenticated, service_role;

create function internal.content_write_is_removal(
  p_table text, p_old jsonb, p_new jsonb, p_user_id uuid
)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select coalesce((
    p_table in ('core.lost_found_items', 'core.marketplace_listings')
    and p_old ->> 'archived_at' is null and p_new ->> 'archived_at' is not null
    and p_new - array['archived_at', 'updated_at'] = p_old - array['archived_at', 'updated_at']
    and coalesce(p_new ->> 'seller_id', p_new ->> 'author_id') = p_user_id::text
  ) or (
    p_table = 'core.teams' and p_old ->> 'status' = 'open'
    and p_new ->> 'status' = 'archived' and p_new ->> 'owner_id' = p_user_id::text
    and p_new - array['status', 'updated_at'] = p_old - array['status', 'updated_at']
  ) or (
    p_old ->> 'status' is distinct from p_new ->> 'status'
    and p_new - (array['status', 'updated_at', 'responded_at']
      || case when p_table = 'core.mentor_requests' then array['refunded_at'] else '{}'::text[] end)
      = p_old - (array['status', 'updated_at', 'responded_at']
      || case when p_table = 'core.mentor_requests' then array['refunded_at'] else '{}'::text[] end)
    and case p_table
      when 'core.study_group_invites' then
        p_old ->> 'status' = 'pending' and p_new ->> 'status' in ('declined', 'revoked')
        and p_user_id::text in (p_new ->> 'target_user_id', p_new ->> 'created_by')
      when 'core.team_applications' then
        p_old ->> 'status' in ('pending', 'accepted') and p_new ->> 'status' = 'withdrawn'
        and p_new ->> 'applicant_id' = p_user_id::text
      when 'core.mentor_requests' then
        p_old ->> 'status' in ('pending', 'accepted')
        and p_new ->> 'status' in ('cancelled', 'declined')
        and p_user_id::text in (p_new ->> 'requester_id', p_new ->> 'mentor_user_id')
      else false
    end), false);
$$;

revoke all on function internal.content_write_is_removal(text, jsonb, jsonb, uuid)
from public, anon, authenticated, service_role;

do $$
declare
  v_definition text;
  v_replacement text;
begin
  v_definition := pg_get_functiondef(
    'core.enforce_content_write_limit(text,integer,integer,integer,bigint,bigint,uuid)'::regprocedure
  );
  if position('v_user_id uuid := coalesce(p_user_id, (select auth.uid()))' in v_definition) = 0
    or position(E'begin\n  if p_action is null' in v_definition) = 0 then
    raise exception 'Unexpected content limiter definition';
  end if;
  v_replacement := replace(v_definition, E'begin\n  if p_action is null',
    E'begin\n  if v_user_id is not null then\n    if internal.content_action_requires_member(p_action) then\n      perform internal.require_permanent_content_actor(v_user_id, internal.content_action_requires_trust(p_action));\n    else\n      perform internal.require_content_actor(v_user_id, false);\n    end if;\n  end if;\n  if p_action is null');
  execute v_replacement;

  v_definition := pg_get_functiondef('internal.limit_user_content_write()'::regprocedure);
  if position(E'begin\n  if v_user_id is null then' in v_definition) = 0 then
    raise exception 'Unexpected content write trigger definition';
  end if;
  v_replacement := replace(v_definition, E'begin\n  if v_user_id is null then',
    E'begin\n  if v_user_id is null and (select auth.role()) = ''service_role''\n    and tg_table_schema = ''core'' and tg_table_name in (''teacher_reviews'', ''lesson_reviews'') then\n    v_user_id := (to_jsonb(new) ->> ''user_id'')::uuid;\n  end if;\n  if v_user_id is null then');
  if position('v_action, v_limits[1], v_limits[2], v_limits[3]' in v_replacement) = 0 then
    raise exception 'Unexpected content write limiter call';
  end if;
  v_replacement := replace(v_replacement,
    'v_action, v_limits[1], v_limits[2], v_limits[3]',
    'v_action, v_limits[1], v_limits[2], v_limits[3], p_user_id => v_user_id');
  if position('v_old := to_jsonb(old);' in v_replacement) = 0 then
    raise exception 'Unexpected content update trigger definition';
  end if;
  v_replacement := replace(v_replacement, 'v_old := to_jsonb(old);',
    E'v_old := to_jsonb(old);\n    if internal.content_write_is_removal(tg_table_schema || ''.'' || tg_table_name, v_old, v_new, v_user_id) then\n      return null;\n    end if;');
  execute v_replacement;
end;
$$;

create function internal.protect_review_identity()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_column text;
begin
  if (select auth.uid()) is null and coalesce((select auth.role()), '') <> 'service_role' then
    return new;
  end if;
  if tg_op = 'INSERT' then
    if tg_table_schema = 'core' and tg_table_name in ('teacher_reviews', 'lesson_reviews') then
      perform internal.require_content_actor(new.user_id, true);
      if not exists (
        select 1 from core.user_academic_profiles profile
        where profile.user_id = new.user_id
          and profile.organization_id = new.organization_id
      ) then
        raise exception 'User does not belong to this organization'
          using errcode = '42501', hint = 'content_organization_denied';
      end if;
    end if;
    new.created_at := clock_timestamp();
  else
    foreach v_column in array tg_argv loop
      if to_jsonb(new) -> v_column is distinct from to_jsonb(old) -> v_column then
        raise exception 'Автор, время и объект оценки не могут быть изменены'
          using errcode = '42501', hint = 'content_identity_immutable';
      end if;
    end loop;
  end if;
  return new;
end;
$$;

revoke all on function internal.protect_review_identity()
from public, anon, authenticated, service_role;

create trigger protect_review_identity before insert or update on core.teacher_reviews
for each row execute function internal.protect_review_identity(
  'id', 'user_id', 'organization_id', 'teacher_name', 'created_at'
);
create trigger protect_review_identity before insert or update on core.lesson_reviews
for each row execute function internal.protect_review_identity(
  'id', 'user_id', 'organization_id', 'subject_name', 'lesson_date',
  'lesson_bells_number', 'created_at'
);
create trigger protect_review_identity before insert or update on core.mini_app_ratings
for each row execute function internal.protect_review_identity(
  'app_id', 'user_id', 'created_at'
);

create function internal.guard_shared_note_write()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null and (select auth.role()) = 'service_role' then
    v_user_id := coalesce(new.owner_id, new.created_by);
  end if;
  if tg_op = 'UPDATE' and to_jsonb(new)
    - array['updated_at', 'updated_by', 'revision', 'document_revision', 'last_editor_id']
    = to_jsonb(old)
    - array['updated_at', 'updated_by', 'revision', 'document_revision', 'last_editor_id'] then
    return new;
  end if;
  if v_user_id is not null then
    perform internal.require_permanent_content_actor(v_user_id,
      new.visibility = 'group' or new.group_id is not null
      or coalesce(cardinality(new.collaborator_ids), 0) > 0
    );
  end if;
  return new;
end;
$$;

revoke all on function internal.guard_shared_note_write()
from public, anon, authenticated, service_role;

create trigger guard_shared_note_write before insert or update on core.group_notes
for each row execute function internal.guard_shared_note_write();

create function internal.guard_shared_storage_write()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_owner_text text := coalesce(nullif(new.owner_id, ''), new.owner::text);
begin
  if tg_op = 'UPDATE'
    and new.name is not distinct from old.name
    and new.bucket_id is not distinct from old.bucket_id
    and new.version is not distinct from old.version
    and new.metadata -> 'size' is not distinct from old.metadata -> 'size'
    and new.metadata -> 'contentLength' is not distinct from old.metadata -> 'contentLength'
    and new.metadata -> 'eTag' is not distinct from old.metadata -> 'eTag'
    and new.user_metadata is not distinct from old.user_metadata
    and new.owner is not distinct from old.owner
    and new.owner_id is not distinct from old.owner_id then
    return new;
  end if;
  if v_user_id is null and v_owner_text ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then
    v_user_id := v_owner_text::uuid;
  end if;
  if v_user_id is not null then
    perform internal.require_permanent_content_actor(v_user_id, new.bucket_id in (
      'lesson-materials', 'lost-found-images', 'marketplace-media',
      'room-photos', 'mini-app-icons', 'mini-app-uploads'
    ));
  end if;
  return new;
end;
$$;

revoke all on function internal.guard_shared_storage_write()
from public, anon, authenticated, service_role;

create trigger guard_shared_storage_write before insert or update on storage.objects
for each row execute function internal.guard_shared_storage_write();
