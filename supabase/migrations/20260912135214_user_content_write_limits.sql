create or replace function internal.limit_user_content_write()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_action text;
  v_limits integer[];
  v_ignored text[] := tg_argv[6]::text[];
  v_new jsonb;
  v_old jsonb;
  v_size bigint;
  v_max_size bigint := case
    when tg_table_schema = 'core' and tg_table_name = 'map_proposals' then 17825792
    else 2097152
  end;
  v_admin boolean := false;
begin
  if v_user_id is null then
    return null;
  end if;
  if tg_table_schema = 'core'
    and tg_table_name in ('poll_answers', 'poll_votes')
    and pg_trigger_depth() > 1 then
    return null;
  end if;

  v_new := to_jsonb(new);
  if tg_op = 'UPDATE' then
    v_old := to_jsonb(old);
    if pg_trigger_depth() > 1 and tg_table_schema = 'core' then
      if tg_table_name in ('marketplace_listings', 'lost_found_items')
        and v_old ->> 'archived_at' is null and v_new ->> 'archived_at' is not null
        and coalesce(v_new ->> 'seller_id', v_new ->> 'author_id') = v_user_id::text
        and v_new - array['archived_at', 'updated_at']
          = v_old - array['archived_at', 'updated_at'] then
        return null;
      end if;
      if tg_table_name = 'teams'
        and v_old ->> 'status' = 'open' and v_new ->> 'status' = 'archived'
        and v_new ->> 'owner_id' = v_user_id::text
        and v_new - array['status', 'updated_at'] = v_old - array['status', 'updated_at'] then
        return null;
      end if;
      if tg_table_name = 'team_applications'
        and v_old ->> 'status' = 'pending' and v_new ->> 'status' = 'withdrawn'
        and v_new - array['status', 'updated_at'] = v_old - array['status', 'updated_at']
        and exists (
          select 1 from core.teams team
          where team.id = (v_new ->> 'team_id')::uuid and team.owner_id = v_user_id
        ) then
        return null;
      end if;
    end if;
    if tg_table_schema = 'core' and tg_table_name = 'study_group_invites'
      and v_old ->> 'status' = 'pending' and v_new ->> 'status' = 'revoked'
      and v_new ->> 'target_user_id' = v_user_id::text
      and v_new - array['status', 'responded_at', 'updated_at']
        = v_old - array['status', 'responded_at', 'updated_at'] then
      return null;
    end if;
    if v_new - v_ignored = v_old - v_ignored then
      if tg_nargs > 7 and tg_argv[7] <> ''
        and v_new -> tg_argv[7] is distinct from v_old -> tg_argv[7] then
        perform core.enforce_content_write_limit(
          'interact:' || tg_table_schema || '.' || tg_table_name,
          120, 2400, 10000
        );
      end if;
      return null;
    end if;
    v_action := 'edit:' || tg_table_schema || '.' || tg_table_name;
    v_limits := array[tg_argv[3]::integer, tg_argv[4]::integer, tg_argv[5]::integer];
    if tg_table_schema = 'core'
      and tg_table_name in (
        'lost_found_items', 'marketplace_listings', 'polls',
        'mentor_profiles', 'teams', 'user_deadlines'
      )
      and v_new ->> 'organization_id' is not distinct from v_old ->> 'organization_id'
      and to_regprocedure('core.is_app_admin(text)') is not null then
      execute 'select core.is_app_admin($1)' into v_admin
        using v_new ->> 'organization_id';
      if v_admin then
        v_action := 'moderate:' || tg_table_schema || '.' || tg_table_name;
        v_limits := array[300, 3000, 12000];
      end if;
    end if;
  else
    v_action := 'create:' || tg_table_schema || '.' || tg_table_name;
    v_limits := array[tg_argv[0]::integer, tg_argv[1]::integer, tg_argv[2]::integer];
  end if;

  v_size := octet_length((v_new - v_ignored)::text);
  if v_size > v_max_size
    and (tg_op = 'INSERT' or v_size > octet_length((v_old - v_ignored)::text)) then
    raise exception 'Слишком большой объем данных'
      using errcode = '22001', hint = 'content_too_large:' || tg_table_schema || '.' || tg_table_name;
  end if;

  perform core.enforce_content_write_limit(
    v_action, v_limits[1], v_limits[2], v_limits[3]
  );
  return null;
end;
$$;

revoke all on function internal.limit_user_content_write()
from public, anon, authenticated;

do $$
declare
  v_policy record;
begin
  for v_policy in
    select * from (values
      ('core', 'campus_events', 5, 10, 30, 10, 20, 100, '{updated_at}', ''),
      ('core', 'event_rsvps', 30, 120, 1000, 30, 120, 1000, '{updated_at}', ''),
      ('core', 'exam_readiness', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'friendships', 10, 30, 150, 60, 300, 1500, '{updated_at}', ''),
      ('core', 'group_links', 10, 30, 150, 30, 120, 500, '{updated_at}', ''),
      ('core', 'group_notes', 10, 30, 150, 60, 1200, 5000,
        '{updated_at,updated_by,revision,document_revision,last_editor_id,collaborator_ids}', ''),
      ('core', 'group_post_comments', 20, 60, 300, 30, 120, 600, '{updated_at}', ''),
      ('core', 'group_post_likes', 60, 600, 3000, 60, 600, 3000, '{updated_at}', ''),
      ('core', 'group_posts', 10, 20, 100, 30, 120, 500, '{updated_at}', ''),
      ('core', 'lesson_materials', 10, 30, 150, 30, 120, 500,
        '{updated_at,download_count,like_count}', 'download_count'),
      ('core', 'lesson_reactions', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'lesson_reviews', 10, 30, 150, 30, 120, 500, '{updated_at}', ''),
      ('core', 'lost_found_items', 5, 10, 30, 10, 30, 150, '{updated_at}', ''),
      ('core', 'lost_found_upload_tickets', 60, 120, 600, 60, 120, 600, '{updated_at}', ''),
      ('core', 'map_bookmarks', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'map_proposals', 5, 20, 100, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'map_room_confirmations', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'marketplace_listings', 5, 20, 50, 10, 30, 150, '{updated_at}', ''),
      ('core', 'material_entitlements', 30, 150, 1000, 30, 150, 1000, '{updated_at}', ''),
      ('core', 'material_likes', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'mentor_profiles', 5, 20, 100, 10, 30, 150, '{updated_at,sessions_count}', ''),
      ('core', 'mentor_requests', 10, 20, 100, 60, 300, 1500, '{updated_at}', ''),
      ('core', 'mini_app_consents', 120, 600, 3000, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'mini_app_deploy_tokens', 5, 10, 20, 10, 30, 100, '{updated_at,last_used_at}', ''),
      ('core', 'mini_app_hidden', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'mini_app_ratings', 30, 120, 600, 30, 120, 600, '{updated_at}', ''),
      ('core', 'mini_app_reports', 10, 20, 100, 20, 60, 300, '{updated_at}', ''),
      ('core', 'mini_app_screens', 600, 4000, 8000, 600, 4000, 8000, '{updated_at}', ''),
      ('core', 'mini_app_secrets', 10, 30, 100, 10, 30, 100, '{updated_at}', ''),
      ('core', 'mini_app_user_storage', 120, 600, 3000, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'mini_apps', 5, 10, 30, 15, 60, 300,
        '{updated_at,launch_count,rating_avg,rating_count,search,published_at}', 'launch_count'),
      ('core', 'poll_answers', 1200, 12000, 12000, 1200, 12000, 12000, '{updated_at}', ''),
      ('core', 'poll_options', 1200, 12000, 12000, 1200, 12000, 12000, '{updated_at}', ''),
      ('core', 'poll_questions', 1200, 12000, 12000, 1200, 12000, 12000, '{updated_at}', ''),
      ('core', 'poll_votes', 1200, 12000, 12000, 1200, 12000, 12000, '{updated_at}', ''),
      ('core', 'polls', 10, 10, 50, 30, 120, 300, '{updated_at}', ''),
      ('core', 'promo_banner_dismissals', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'promo_banner_events', 120, 600, 3000, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'room_photos', 10, 20, 100, 30, 120, 300, '{updated_at}', ''),
      ('core', 'scheduled_reminders', 120, 600, 3000, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'search_query_events', 60, 300, 1500, 60, 300, 1500, '{updated_at}', ''),
      ('core', 'study_group_invites', 30, 120, 500, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'study_group_members', 30, 120, 500, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'study_groups', 3, 5, 5, 10, 30, 150, '{updated_at}', ''),
      ('core', 'teacher_reviews', 10, 20, 100, 30, 120, 500, '{updated_at}', ''),
      ('core', 'team_applications', 10, 30, 150, 60, 300, 1500, '{updated_at}', ''),
      ('core', 'team_members', 30, 120, 500, 60, 300, 1500, '{updated_at}', ''),
      ('core', 'teams', 5, 10, 50, 10, 30, 150, '{updated_at}', ''),
      ('core', 'user_academic_profiles', 10, 30, 100, 30, 120, 500, '{updated_at}', ''),
      ('core', 'user_activities', 60, 120, 1000, 60, 300, 2000, '{updated_at}', ''),
      ('core', 'user_deadlines', 30, 60, 300, 120, 600, 3000, '{updated_at}', ''),
      ('core', 'user_devices', 10, 30, 100, 30, 120, 500, '{updated_at,cns_endpoint_arn}', ''),
      ('core', 'user_semester_stats', 10, 60, 300, 30, 120, 500, '{updated_at}', ''),
      ('core', 'wifi_submit_log', 60, 1000, 5000, 60, 1000, 5000, '{}', ''),
      ('public', 'friend_locations', 120, 3600, 12000, 120, 3600, 12000, '{}', ''),
      ('user_private', 'friend_location_preferences', 60, 300, 2000, 60, 300, 2000, '{updated_at}', ''),
      ('user_private', 'schedule_notification_reads', 1200, 6000, 12000, 1200, 6000, 12000, '{updated_at}', ''),
      ('user_private', 'user_preferences', 120, 600, 3000, 120, 600, 3000, '{updated_at,revision}', ''),
      ('user_private', 'user_settings', 30, 120, 500, 60, 300, 1500, '{updated_at}', '')
    ) as policies(
      schema_name, table_name, create_minute, create_hour, create_day,
      edit_minute, edit_hour, edit_day, ignored_columns, interaction_column
    )
  loop
    if to_regclass(format('%I.%I', v_policy.schema_name, v_policy.table_name)) is null then
      raise exception 'Content write table is missing: %.%',
        v_policy.schema_name, v_policy.table_name;
    end if;
    execute format(
      'create trigger user_content_write_limit after insert or update on %I.%I '
      'for each row execute function internal.limit_user_content_write(%L,%L,%L,%L,%L,%L,%L,%L)',
      v_policy.schema_name, v_policy.table_name,
      v_policy.create_minute, v_policy.create_hour, v_policy.create_day,
      v_policy.edit_minute, v_policy.edit_hour, v_policy.edit_day,
      v_policy.ignored_columns, v_policy.interaction_column
    );
  end loop;
end;
$$;
