-- Moderation RPCs for the moderate-content edge function.
--
-- core is not exposed through PostgREST, so the function talks to the
-- database only through these service_role-only functions in app_api_v1.

create or replace function internal.moderation_content(
  p_content_type text,
  p_content_id uuid
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_row jsonb;
begin
  case p_content_type
    when 'lost_found' then
      select jsonb_build_object(
        'kind', 'lost & found',
        'title', coalesce(item.item_name, ''),
        'body', coalesce(item.description, ''),
        'extra', jsonb_build_object(
          'status', coalesce(item.status, ''),
          'category', coalesce(item.category, ''),
          'location', coalesce(item.location, '')
        ),
        'author_id', item.author_id,
        'organization_id', item.organization_id
      ) into v_row
      from core.lost_found_items item where item.id = p_content_id;
    when 'marketplace' then
      select jsonb_build_object(
        'kind', 'marketplace',
        'title', coalesce(listing.title, ''),
        'body', coalesce(listing.description, ''),
        'extra', jsonb_build_object(
          'price', case when listing.is_free then 'free'
                        else listing.price::text || ' RUB' end,
          'category', coalesce(listing.category, '')
        ),
        'author_id', listing.seller_id,
        'organization_id', listing.organization_id
      ) into v_row
      from core.marketplace_listings listing where listing.id = p_content_id;
    when 'event' then
      select jsonb_build_object(
        'kind', 'campus events',
        'title', coalesce(event.title, ''),
        'body', coalesce(event.description, ''),
        'extra', jsonb_build_object(
          'category', coalesce(event.category, ''),
          'place', coalesce(event.place, ''),
          'starts_at', coalesce(event.starts_at::text, '')
        ),
        'author_id', event.created_by,
        'organization_id', event.organization_id
      ) into v_row
      from core.campus_events event where event.id = p_content_id;
    when 'mentor' then
      select jsonb_build_object(
        'kind', 'mentorship profile',
        'title', coalesce(array_to_string(mentor.topics, ', '), ''),
        'body', coalesce(mentor.bio, ''),
        'extra', jsonb_build_object(
          'level', coalesce(mentor.level, ''),
          'formats', coalesce(array_to_string(mentor.formats, ', '), ''),
          'price', coalesce(mentor.price::text, '')
        ),
        'author_id', mentor.user_id,
        'organization_id', mentor.organization_id
      ) into v_row
      from core.mentor_profiles mentor where mentor.user_id = p_content_id;
    when 'poll' then
      select jsonb_build_object(
        'kind', 'poll',
        'title', coalesce(nullif(poll.title, ''), poll.question, ''),
        'body', concat_ws(E'\n', nullif(poll.description, ''), (
          select string_agg(
            'Q: ' || question.text || ' (' || question.kind || ')'
            || coalesce((
              select E'\n' || string_agg('  - ' || option.text, E'\n'
                order by option.position)
              from core.poll_options option
              where option.question_id = question.id
            ), ''),
            E'\n' order by question.position
          )
          from core.poll_questions question
          where question.poll_id = poll.id
        )),
        'extra', jsonb_build_object(
          'category', coalesce(poll.category, ''),
          'anonymous', case when poll.is_anonymous then 'yes' else 'no' end
        ),
        'author_id', poll.author_id,
        'organization_id', poll.organization_id
      ) into v_row
      from core.polls poll where poll.id = p_content_id;
    else
      raise exception 'Unknown content type %', p_content_type
        using errcode = '22023';
  end case;
  return v_row;
end;
$$;

revoke all on function internal.moderation_content(text, uuid)
from public, anon, authenticated;

create or replace function internal.moderation_remove_content(
  p_content_type text,
  p_content_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_paths jsonb := '[]'::jsonb;
  v_bucket text := '';
  v_images jsonb;
  v_media jsonb;
begin
  case p_content_type
    when 'lost_found' then
      delete from core.lost_found_items item
      where item.id = p_content_id
      returning item.images into v_images;
      v_bucket := 'lost-found-images';
      select coalesce(jsonb_agg(image.value), '[]'::jsonb) into v_paths
      from jsonb_array_elements(
        case when jsonb_typeof(v_images) = 'array' then v_images
             else '[]'::jsonb end
      ) image
      where jsonb_typeof(image.value) = 'string';
    when 'marketplace' then
      delete from core.marketplace_listings listing
      where listing.id = p_content_id
      returning listing.media into v_media;
      v_bucket := 'marketplace-media';
      select coalesce(jsonb_agg(item.value -> 'path'), '[]'::jsonb) into v_paths
      from jsonb_array_elements(
        case when jsonb_typeof(v_media) = 'array' then v_media
             else '[]'::jsonb end
      ) item
      where jsonb_typeof(item.value -> 'path') = 'string';
    when 'event' then
      delete from core.campus_events where id = p_content_id;
    when 'mentor' then
      delete from core.mentor_profiles where user_id = p_content_id;
    when 'poll' then
      delete from core.polls where id = p_content_id;
    else
      raise exception 'Unknown content type %', p_content_type
        using errcode = '22023';
  end case;
  return jsonb_build_object('bucket', v_bucket, 'paths', v_paths);
end;
$$;

revoke all on function internal.moderation_remove_content(text, uuid)
from public, anon, authenticated;

-- Claims the job (attempts + 1), loads the content and short-circuits when
-- the same text was already judged.
create or replace function app_api_v1.moderation_begin(p_job_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_job core.moderation_jobs%rowtype;
  v_content jsonb;
  v_hash text;
  v_previous text;
begin
  update core.moderation_jobs
  set attempts = attempts + 1, updated_at = clock_timestamp()
  where id = p_job_id and status = 'pending'
  returning * into v_job;
  if v_job.id is null then
    return jsonb_build_object('status', 'skipped', 'reason', 'job not pending');
  end if;

  v_content := internal.moderation_content(v_job.content_type, v_job.content_id);
  if v_content is null then
    update core.moderation_jobs
    set status = 'done', updated_at = clock_timestamp()
    where id = p_job_id;
    return jsonb_build_object('status', 'skipped', 'reason', 'content gone');
  end if;

  v_hash := encode(sha256(convert_to(
    (v_content ->> 'title') || E'\n' || (v_content ->> 'body') || E'\n'
      || (v_content -> 'extra')::text,
    'UTF8'
  )), 'hex');

  select verdict into v_previous
  from core.moderation_decisions
  where content_type = v_job.content_type
    and content_id = v_job.content_id
    and content_hash = v_hash
  order by created_at desc
  limit 1;
  if v_previous is not null then
    update core.moderation_jobs
    set status = 'done', updated_at = clock_timestamp()
    where id = p_job_id;
    return jsonb_build_object(
      'status', 'skipped', 'reason', 'already judged', 'verdict', v_previous
    );
  end if;

  return jsonb_build_object(
    'status', 'ok',
    'job', jsonb_build_object(
      'id', v_job.id,
      'content_type', v_job.content_type,
      'content_id', v_job.content_id,
      'attempts', v_job.attempts
    ),
    'content', v_content,
    'content_hash', v_hash
  );
end;
$$;

revoke all on function app_api_v1.moderation_begin(uuid)
from public, anon, authenticated;
grant execute on function app_api_v1.moderation_begin(uuid) to service_role;

-- Records the decision, removes the content when the action is 'deleted'
-- and closes the job. Returns storage objects the caller should delete.
create or replace function app_api_v1.moderation_finish(
  p_job_id uuid,
  p_decision jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_job core.moderation_jobs%rowtype;
  v_action text := p_decision ->> 'action';
  v_removed jsonb := jsonb_build_object('bucket', '', 'paths', '[]'::jsonb);
begin
  select * into v_job from core.moderation_jobs where id = p_job_id;
  if v_job.id is null then
    raise exception 'Unknown moderation job %', p_job_id using errcode = '22023';
  end if;

  insert into core.moderation_decisions (
    content_type, content_id, author_id, organization_id, content_hash,
    content_excerpt, verdict, category, confidence, reason, model, action,
    latency_ms
  ) values (
    v_job.content_type,
    v_job.content_id,
    (p_decision ->> 'author_id')::uuid,
    p_decision ->> 'organization_id',
    p_decision ->> 'content_hash',
    left(coalesce(p_decision ->> 'content_excerpt', ''), 1000),
    p_decision ->> 'verdict',
    coalesce(p_decision ->> 'category', 'other'),
    least(1, greatest(0, coalesce((p_decision ->> 'confidence')::numeric, 0))),
    left(coalesce(p_decision ->> 'reason', ''), 300),
    p_decision ->> 'model',
    v_action,
    (p_decision ->> 'latency_ms')::integer
  );

  if v_action = 'deleted' then
    v_removed := internal.moderation_remove_content(
      v_job.content_type, v_job.content_id
    );
  end if;

  update core.moderation_jobs
  set status = 'done', last_error = null, updated_at = clock_timestamp()
  where id = p_job_id;

  return v_removed;
end;
$$;

revoke all on function app_api_v1.moderation_finish(uuid, jsonb)
from public, anon, authenticated;
grant execute on function app_api_v1.moderation_finish(uuid, jsonb)
to service_role;

create or replace function app_api_v1.moderation_fail(
  p_job_id uuid,
  p_error text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_attempts integer;
begin
  select attempts into v_attempts
  from core.moderation_jobs where id = p_job_id;
  if v_attempts is null then
    return;
  end if;
  update core.moderation_jobs
  set status = case when v_attempts >= 6 then 'failed' else 'pending' end,
      last_error = left(p_error, 500),
      next_attempt_at = clock_timestamp()
        + make_interval(mins => least(60, power(2, v_attempts)::integer)),
      updated_at = clock_timestamp()
  where id = p_job_id;
end;
$$;

revoke all on function app_api_v1.moderation_fail(uuid, text)
from public, anon, authenticated;
grant execute on function app_api_v1.moderation_fail(uuid, text)
to service_role;
