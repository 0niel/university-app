create or replace function public.save_group_note_document(
  p_note_id uuid, p_document jsonb, p_revision bigint
)
returns jsonb language sql security invoker set search_path = ''
as $$ select app_api_v1.save_group_note_document(p_note_id, p_document, p_revision); $$;

create or replace function public.rename_group_note(p_id uuid, p_title text)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.rename_group_note(p_id, p_title); $$;

create or replace function public.set_group_note_visibility(p_id uuid, p_visibility text)
returns void language sql security invoker set search_path = ''
as $$ select app_api_v1.set_group_note_visibility(p_id, p_visibility); $$;

create or replace function public.upsert_mentor_profile(
  p_organization_id text, p_topics text[], p_telegram_handle text,
  p_bio text default '', p_level text default '',
  p_formats text[] default '{}', p_price integer default 0
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.upsert_mentor_profile(
    p_organization_id, p_topics, p_telegram_handle, p_bio, p_level, p_formats, p_price
  );
$$;

create or replace function app_api_v1.upsert_mentor_profile(
  p_organization_id text, p_topics text[], p_bio text default '',
  p_level text default '', p_formats text[] default '{}', p_price integer default 0
)
returns void language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_topics text[] := coalesce(p_topics, '{}');
  v_formats text[] := coalesce(p_formats, '{}');
begin
  if v_uid is null or not exists (
    select 1 from core.user_academic_profiles
    where user_id = v_uid and organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if cardinality(v_topics) not between 1 and 20
    or cardinality(v_formats) > 10
    or exists (
      select 1 from unnest(v_topics || v_formats) value
      where value is null or char_length(btrim(value)) not between 1 and 60
    ) then
    raise exception 'Invalid mentor profile options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('upsert_mentor_profile', 20, interval '1 hour');
  insert into core.mentor_profiles (
    user_id, organization_id, topics, bio, level, formats, price
  ) values (
    v_uid, p_organization_id, v_topics,
    core.validate_text(p_bio, 'Bio', 2000, false),
    core.validate_text(p_level, 'Level', 60, false), v_formats,
    least(greatest(coalesce(p_price, 0), 0), 1000000)
  )
  on conflict (organization_id, user_id) do update set
    topics = excluded.topics, bio = excluded.bio, level = excluded.level,
    formats = excluded.formats, price = excluded.price, is_active = true;
end;
$$;

create or replace function app_api_v1.get_group_post_comments(p_post_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select post.group_id into v_group_id
  from core.group_posts post
  where post.id = p_post_id;

  if v_group_id is null or v_group_id is distinct from core.current_study_group_id() then
    raise exception 'Group post not found' using errcode = '42501';
  end if;

  return coalesce((
    select jsonb_agg(
      jsonb_build_object(
        'id', comment.id,
        'postId', comment.post_id,
        'body', comment.body,
        'authorName', coalesce(
          split_part(profile.full_name, ' ', 1),
          'аноним'
        ),
        'createdAt', comment.created_at,
        'isMine', comment.author_id = v_user_id,
        'canDelete', comment.author_id = v_user_id
          or study_group.owner_id = v_user_id
      )
      order by comment.created_at, comment.id
    )
    from core.group_post_comments comment
    join core.study_groups study_group on study_group.id = v_group_id
    left join core.user_academic_profiles profile
      on profile.user_id = comment.author_id
    where comment.post_id = p_post_id
  ), '[]'::jsonb);
end;
$$;

create or replace function app_api_v1.add_group_post_comment(
  p_post_id uuid,
  p_body text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_body text;
  v_id uuid;
  v_created_at timestamptz;
  v_full_name text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select post.group_id into v_group_id
  from core.group_posts post
  where post.id = p_post_id;

  if v_group_id is null or v_group_id is distinct from core.current_study_group_id() then
    raise exception 'Group post not found' using errcode = '42501';
  end if;

  perform core.enforce_rate_limit(
    'add_group_post_comment', 60, interval '1 hour'
  );
  v_body := core.validate_text(p_body, 'Комментарий', 2000, true);

  insert into core.group_post_comments (post_id, author_id, body)
  values (p_post_id, v_user_id, v_body)
  returning id, created_at into v_id, v_created_at;

  select full_name into v_full_name
  from core.user_academic_profiles
  where user_id = v_user_id;

  return jsonb_build_object(
    'id', v_id,
    'postId', p_post_id,
    'body', v_body,
    'authorName', coalesce(split_part(v_full_name, ' ', 1), 'аноним'),
    'createdAt', v_created_at,
    'isMine', true,
    'canDelete', true
  );
end;
$$;

create or replace function app_api_v1.delete_group_post_comment(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_author_id uuid;
  v_group_id uuid;
  v_owner_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select comment.author_id, post.group_id
  into v_author_id, v_group_id
  from core.group_post_comments comment
  join core.group_posts post on post.id = comment.post_id
  where comment.id = p_id;

  if v_group_id is null or v_group_id is distinct from core.current_study_group_id() then
    raise exception 'Comment not found' using errcode = '42501';
  end if;

  select study_group.owner_id into v_owner_id
  from core.study_groups study_group
  where study_group.id = v_group_id;

  if v_author_id <> v_user_id and v_owner_id <> v_user_id then
    raise exception 'Only the author or group owner can delete this comment'
      using errcode = '42501';
  end if;

  delete from core.group_post_comments where id = p_id;
end;
$$;

alter table core.lesson_materials drop constraint if exists lesson_materials_file_size_valid;
alter table core.lesson_materials add constraint lesson_materials_file_size_valid
check (file_size >= 0 and file_size <= 104857600);

create or replace function core.require_material_upload(
  p_organization_id text, p_file_path text, p_file_size bigint, p_mime_type text
)
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_object storage.objects;
  v_mime text := coalesce(nullif(trim(p_mime_type), ''), 'application/octet-stream');
begin
  if v_uid is null or not exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = v_uid and profile.organization_id = p_organization_id
  ) then
    raise exception 'Organization access denied' using errcode = '42501';
  end if;
  if p_file_path is null or split_part(p_file_path, '/', 1) <> v_uid::text
    or p_file_path ~ '(^|/)\.\.?(/|$)' then
    raise exception 'File ownership required' using errcode = '42501';
  end if;
  if p_file_size is null or p_file_size <= 0 or p_file_size > 104857600 then
    raise exception 'Invalid file size' using errcode = '22023';
  end if;
  select * into v_object from storage.objects object
  where object.bucket_id = 'lesson-materials' and object.name = p_file_path
    and coalesce(nullif(object.owner_id, ''), object.owner::text) = v_uid::text
    and object.archived_at is null and not object.is_delete_marker
  for update;
  if not found then
    raise exception 'Owned uploaded file required' using errcode = '42501';
  end if;
  if coalesce(v_object.metadata ->> 'size', '') !~ '^[0-9]{1,10}$' then
    raise exception 'Invalid stored file size' using errcode = '22023';
  end if;
  if (v_object.metadata ->> 'size')::bigint <> p_file_size then
    raise exception 'File size does not match upload' using errcode = '22023';
  end if;
  if not exists (
    select 1 from storage.buckets bucket
    where bucket.id = 'lesson-materials' and not bucket.public
      and (bucket.allowed_mime_types is null or v_mime = any(bucket.allowed_mime_types))
      and (bucket.file_size_limit is null or p_file_size <= bucket.file_size_limit)
  ) or v_mime is distinct from v_object.metadata ->> 'mimetype' then
    raise exception 'Invalid file type' using errcode = '22023';
  end if;
  return v_object.id;
end;
$$;

create or replace function core.can_read_lesson_material_preview(p_preview_path text)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from core.lesson_materials material
    join core.user_academic_profiles profile
      on profile.user_id = (select auth.uid())
      and profile.organization_id = material.organization_id
    where material.preview_path = p_preview_path
      and (material.is_public or material.user_id = (select auth.uid()))
  );
$$;

revoke all on function core.can_read_lesson_material_preview(text) from public, anon;
grant execute on function core.can_read_lesson_material_preview(text) to authenticated, service_role;

create policy "users read accessible material previews"
on storage.objects for select to authenticated using (
  bucket_id = 'lesson-materials'
  and archived_at is null and not is_delete_marker
  and core.can_read_lesson_material_preview(name)
);

create or replace function app_api_v1.delete_room_photo_v2(p_id uuid)
returns text language plpgsql security definer set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_path text;
begin
  if v_uid is null then
    raise exception 'Room photo is unavailable' using errcode = '42501';
  end if;
  delete from core.room_photos
  where id = p_id and created_by = v_uid
  returning path into v_path;
  if not found then
    raise exception 'Room photo is unavailable' using errcode = '42501';
  end if;
  return v_path;
end;
$$;

create policy "owners read own room photo uploads"
on storage.objects for select to authenticated using (
  bucket_id = 'room-photos'
  and split_part(name, '/', 1) = (select auth.uid())::text
  and coalesce(nullif(owner_id, ''), owner::text) = (select auth.uid())::text
);

create or replace function public.delete_room_photo_v2(p_id uuid)
returns text language sql security invoker set search_path = ''
as $$ select app_api_v1.delete_room_photo_v2(p_id); $$;

create or replace function app_api_v1.delete_room_photo(p_id uuid)
returns void language plpgsql security definer set search_path = ''
as $$
begin
  perform app_api_v1.delete_room_photo_v2(p_id);
end;
$$;

do $$
declare v_signature text;
begin
  foreach v_signature in array array[
    'public.save_group_note_document(uuid,jsonb,bigint)',
    'public.rename_group_note(uuid,text)',
    'public.set_group_note_visibility(uuid,text)',
    'public.upsert_mentor_profile(text,text[],text,text,text,text[],integer)',
    'app_api_v1.upsert_mentor_profile(text,text[],text,text,text[],integer)',
    'public.delete_room_photo_v2(uuid)',
    'app_api_v1.delete_room_photo_v2(uuid)'
  ] loop
    execute format('revoke all on function %s from public, anon', v_signature);
    execute format('grant execute on function %s to authenticated, service_role', v_signature);
  end loop;
end;
$$;

lock table core.polls, core.poll_options, core.poll_votes, core.poll_answers
in share row exclusive mode;

alter table core.polls add column if not exists legacy_format boolean not null default false;

update core.polls poll
set legacy_format = true, allow_change = true
where poll.created_at < timestamptz '2026-09-03 19:13:04+00'
  and (select count(*) from core.poll_questions question where question.poll_id = poll.id) = 1;

insert into core.poll_answers (poll_id, question_id, user_id, option_id, created_at)
select vote.poll_id, option.question_id, vote.user_id, vote.option_id, vote.created_at
from core.poll_votes vote
join core.poll_options option on option.id = vote.option_id and option.poll_id = vote.poll_id
where option.question_id is not null
  and not exists (
    select 1 from core.poll_answers answer
    where answer.poll_id = vote.poll_id and answer.user_id = vote.user_id
  )
on conflict (question_id, user_id, option_id) do nothing;

delete from core.poll_votes vote
where exists (
  select 1 from core.poll_answers answer
  where answer.poll_id = vote.poll_id and answer.user_id = vote.user_id
)
and not exists (
  select 1 from core.poll_answers answer
  where answer.poll_id = vote.poll_id and answer.user_id = vote.user_id
    and answer.option_id = vote.option_id
);

create or replace function core.sync_poll_vote_models()
returns trigger language plpgsql security definer set search_path = ''
as $$
declare v_question_id uuid;
begin
  if pg_trigger_depth() > 1 then
    return coalesce(new, old);
  end if;
  if tg_table_name = 'poll_votes' then
    if tg_op = 'INSERT' then
      select question.id into v_question_id
      from core.poll_options option
      join core.poll_questions question on question.id = option.question_id
        and question.poll_id = new.poll_id
      where option.id = new.option_id and option.poll_id = new.poll_id;
      if v_question_id is null then
        raise exception 'Invalid poll option' using errcode = '22023';
      end if;
      insert into core.poll_answers (poll_id, question_id, user_id, option_id, created_at)
      values (new.poll_id, v_question_id, new.user_id, new.option_id, new.created_at)
      on conflict (question_id, user_id, option_id) do nothing;
    elsif tg_op = 'DELETE' then
      delete from core.poll_answers
      where poll_id = old.poll_id and user_id = old.user_id and option_id = old.option_id;
    end if;
  elsif tg_table_name = 'poll_answers' then
    if tg_op = 'INSERT' and new.option_id is not null then
      insert into core.poll_votes (poll_id, user_id, option_id, created_at)
      values (new.poll_id, new.user_id, new.option_id, new.created_at)
      on conflict (option_id, user_id) do nothing;
    elsif tg_op = 'DELETE' and old.option_id is not null then
      delete from core.poll_votes
      where poll_id = old.poll_id and user_id = old.user_id and option_id = old.option_id;
    end if;
  end if;
  return coalesce(new, old);
end;
$$;

revoke all on function core.sync_poll_vote_models() from public, anon, authenticated;

create trigger poll_votes_sync_answers
after insert or delete on core.poll_votes
for each row execute function core.sync_poll_vote_models();

create trigger poll_answers_sync_votes
after insert or delete on core.poll_answers
for each row execute function core.sync_poll_vote_models();

insert into core.poll_votes (poll_id, user_id, option_id, created_at)
select answer.poll_id, answer.user_id, answer.option_id, answer.created_at
from core.poll_answers answer
where answer.option_id is not null
on conflict (option_id, user_id) do nothing;

create or replace function app_api_v1.create_poll(
  p_organization_id text, p_question text, p_options text[],
  p_poll_type text default 'single'::text, p_is_anonymous boolean default false,
  p_show_results boolean default true,
  p_expires_at timestamptz default null, p_correct_index integer default null)
  returns uuid language plpgsql set search_path to ''
as $function$
declare
  v_user uuid := (select auth.uid());
  v_id uuid;
  v_question_id uuid;
  v_opt text;
  v_pos int := 0;
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_poll', 10, interval '1 hour');
  if p_poll_type not in ('single','multi','quiz') then
    raise exception 'Invalid poll type';
  end if;
  if p_options is null or array_length(p_options, 1) < 2 then
    raise exception 'At least two options are required';
  end if;
  if array_length(p_options, 1) > 12 then
    raise exception 'Слишком много вариантов (максимум 12)' using errcode = '22023';
  end if;

  insert into core.polls (
    organization_id, author_id, question, poll_type, title, legacy_format, allow_change, results_visibility,
    is_anonymous, show_results, expires_at
  ) values (
    p_organization_id, v_user,
    core.validate_text(p_question, 'Вопрос', 300, true), p_poll_type,
    core.validate_text(p_question, 'Вопрос', 300, true), true, true,
    case when coalesce(p_show_results, true) then 'always' else 'after_vote' end,
    coalesce(p_is_anonymous, false), coalesce(p_show_results, true), p_expires_at
  ) returning id into v_id;

  insert into core.poll_questions (poll_id, position, text, kind, is_required)
  values (v_id, 0, core.validate_text(p_question, 'Вопрос', 300, true),
    case when p_poll_type = 'multi' then 'multiple'
      when p_poll_type = 'quiz' then 'quiz' else 'single' end, true)
  returning id into v_question_id;

  foreach v_opt in array p_options loop
    if length(btrim(v_opt)) > 0 then
      insert into core.poll_options (poll_id, question_id, position, text, is_correct)
      values (
        v_id, v_question_id, v_pos, core.validate_text(v_opt, 'Вариант', 200, true),
        (p_poll_type = 'quiz' and p_correct_index is not null and v_pos = p_correct_index)
      );
      v_pos := v_pos + 1;
    end if;
  end loop;

  if v_pos < 2 then
    raise exception 'At least two non-empty options are required';
  end if;
  return v_id;
end;
$function$;

create or replace function app_api_v1.submit_poll_answers(p_poll_id uuid, p_answers jsonb)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_poll core.polls;
  v_question record;
  v_answer jsonb;
  v_option_ids uuid[];
  v_text text;
  v_rating int;
  v_already boolean;
  v_answered boolean := false;
begin
  if v_uid is null then
    raise exception 'Unauthorized';
  end if;
  perform core.enforce_rate_limit('submit_poll_answers', 60, interval '1 hour');

  perform pg_advisory_xact_lock(hashtextextended(p_poll_id::text, 0));
  select * into v_poll from core.polls where id = p_poll_id;
  if v_poll.id is null then
    raise exception 'Poll not found';
  end if;
  if v_poll.is_closed
    or (v_poll.expires_at is not null and v_poll.expires_at <= now()) then
    raise exception 'Опрос завершён' using errcode = '22023';
  end if;

  select exists (
    select 1 from core.poll_answers where poll_id = p_poll_id and user_id = v_uid
  ) into v_already;
  if v_already and not v_poll.allow_change then
    raise exception 'Вы уже прошли этот опрос' using errcode = '22023';
  end if;
  if p_answers is null or jsonb_typeof(p_answers) <> 'array' then
    raise exception 'Некорректные ответы' using errcode = '22023';
  end if;

  delete from core.poll_answers where poll_id = p_poll_id and user_id = v_uid;

  for v_question in
    select * from core.poll_questions where poll_id = p_poll_id order by position
  loop
    select elem into v_answer from jsonb_array_elements(p_answers) elem
    where nullif(elem ->> 'questionId', '')::uuid = v_question.id
    limit 1;

    if v_answer is null then
      if v_question.is_required then
        raise exception 'Ответьте на все обязательные вопросы' using errcode = '22023';
      end if;
      continue;
    end if;

    if v_question.kind in ('single', 'multiple', 'quiz') then
      select array(
        select nullif(value, '')::uuid
        from jsonb_array_elements_text(coalesce(v_answer -> 'optionIds', '[]'::jsonb)) value
      ) into v_option_ids;
      v_option_ids := array_remove(v_option_ids, null);
      if v_question.is_required and coalesce(array_length(v_option_ids, 1), 0) = 0 then
        raise exception 'Ответьте на все обязательные вопросы' using errcode = '22023';
      end if;
      if coalesce(array_length(v_option_ids, 1), 0) = 0 then
        continue;
      end if;
      if v_question.kind in ('single', 'quiz') and array_length(v_option_ids, 1) > 1 then
        raise exception 'Можно выбрать только один вариант' using errcode = '22023';
      end if;
      if array_length(v_option_ids, 1) > (case when v_poll.legacy_format then 12 else 10 end) then
        raise exception 'Слишком много вариантов' using errcode = '22023';
      end if;
      if exists (
        select 1 from unnest(v_option_ids) oid
        where not exists (
          select 1 from core.poll_options o
          where o.id = oid and o.question_id = v_question.id
        )
      ) then
        raise exception 'Некорректный вариант ответа' using errcode = '22023';
      end if;
      insert into core.poll_answers (poll_id, question_id, user_id, option_id)
      select p_poll_id, v_question.id, v_uid, oid from unnest(v_option_ids) oid;
      v_answered := true;
    elsif v_question.kind = 'text' then
      v_text := core.validate_text(v_answer ->> 'text', 'Ответ', 2000, v_question.is_required);
      if v_text <> '' then
        insert into core.poll_answers (poll_id, question_id, user_id, text_answer)
        values (p_poll_id, v_question.id, v_uid, v_text);
        v_answered := true;
      end if;
    elsif v_question.kind = 'rating' then
      v_rating := nullif(v_answer ->> 'rating', '')::int;
      if v_question.is_required and v_rating is null then
        raise exception 'Ответьте на все обязательные вопросы' using errcode = '22023';
      end if;
      if v_rating is not null then
        if v_rating not between 1 and 5 then
          raise exception 'Оценка от 1 до 5' using errcode = '22023';
        end if;
        insert into core.poll_answers (poll_id, question_id, user_id, rating)
        values (p_poll_id, v_question.id, v_uid, v_rating);
        v_answered := true;
      end if;
    end if;
  end loop;

  if not v_answered then
    raise exception 'Ответьте хотя бы на один вопрос' using errcode = '22023';
  end if;

  return core.poll_to_json(p_poll_id, v_uid);
end;
$$;

create or replace function app_api_v1.vote_poll(p_poll_id uuid, p_option_ids uuid[])
returns void language plpgsql security invoker set search_path = ''
as $$
declare
  v_question core.poll_questions;
  v_poll core.polls;
  v_uid uuid := (select auth.uid());
  v_answers jsonb;
begin
  if v_uid is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;
  perform pg_advisory_xact_lock(hashtextextended(p_poll_id::text, 0));
  select * into v_poll from core.polls where id = p_poll_id;
  if not found or v_poll.is_closed
    or (v_poll.expires_at is not null and v_poll.expires_at <= now()) then
    raise exception 'Poll is unavailable' using errcode = '22023';
  end if;
  if (select count(*) from core.poll_questions where poll_id = p_poll_id) <> 1 then
    raise exception 'Update the application to answer this poll' using errcode = '22023';
  end if;
  select * into v_question from core.poll_questions where poll_id = p_poll_id;
  if v_question.kind not in ('single', 'multiple', 'quiz') then
    raise exception 'Update the application to answer this poll' using errcode = '22023';
  end if;
  if v_poll.legacy_format and cardinality(coalesce(p_option_ids, '{}'::uuid[])) = 0 then
    perform core.enforce_rate_limit('submit_poll_answers', 60, interval '1 hour');
    delete from core.poll_answers where poll_id = p_poll_id and user_id = v_uid;
    return;
  end if;
  v_answers := jsonb_build_array(jsonb_build_object(
    'questionId', v_question.id, 'optionIds', to_jsonb(coalesce(p_option_ids, '{}'::uuid[]))
  ));
  perform app_api_v1.submit_poll_answers(p_poll_id, v_answers);
end;
$$;

create or replace view core.poll_participations
with (security_invoker = true)
as
select user_id, poll_id, min(created_at) as created_at
from (
  select user_id, poll_id, created_at from core.poll_votes
  union all
  select user_id, poll_id, created_at from core.poll_answers
) participation
group by user_id, poll_id;

revoke all on core.poll_participations from public, anon;
grant select on core.poll_participations to authenticated, service_role;

create or replace function core.evaluate_achievements(p_user_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_streak integer;
  v_metrics jsonb;
  v_badge record;
  v_value numeric;
  v_target numeric;
  v_progress numeric(4, 3);
  v_was_earned boolean;
  v_newly jsonb := '[]'::jsonb;
begin
  select greatest(coalesce(longest_streak, 0), coalesce(streak_days, 0))
  into v_streak
  from core.user_gamification_profiles
  where user_id = p_user_id;

  v_metrics := jsonb_build_object(
    'streak', coalesce(v_streak, 0),
    'quests_done', (
      select count(*) from core.user_quest_progress
      where user_id = p_user_id and is_completed
    ),
    'materials', (
      select count(*) from core.lesson_materials
      where user_id = p_user_id and is_public
    ),
    'reviews', (
      select (
        select count(*) from core.teacher_reviews where user_id = p_user_id
      ) + (
        select count(*) from core.lesson_reviews where user_id = p_user_id
      )
    ),
    'deadlines_done', (
      select count(*) from core.user_deadlines
      where user_id = p_user_id and done_at is not null
    ),
    'friends', (
      select count(*) from core.friendships
      where status = 'accepted'
        and (requester_id = p_user_id or addressee_id = p_user_id)
    ),
    'poll_votes', (
      select count(distinct poll_id) from core.poll_participations
      where user_id = p_user_id
    ),
    'polls_created', (
      select count(*) from core.polls where author_id = p_user_id
    ),
    'rsvps', (
      select count(*) from core.event_rsvps where user_id = p_user_id
    ),
    'lost_found', (
      select count(*) from core.lost_found_items where author_id = p_user_id
    ),
    'listings', (
      select count(*) from core.marketplace_listings
      where seller_id = p_user_id
    ),
    'mentor_sessions', (
      select count(*) from core.mentor_requests
      where mentor_user_id = p_user_id and status = 'completed'
    )
  );

  for v_badge in
    select id, name, emoji, category, description, rarity,
      xp_reward, shuriken_reward,
      case id
        when 'streak_3' then 3 when 'streak_7' then 7 when 'streak_30' then 30
        when 'quests_10' then 10
        when 'material_1' then 1 when 'material_5' then 5
        when 'material_25' then 25
        when 'reviews_3' then 3
        when 'deadline_10' then 10
        when 'friend_1' then 1 when 'friends_5' then 5
        when 'polls_5' then 5
        when 'poll_create' then 1
        when 'rsvp_3' then 3
        when 'lostfound_1' then 1
        when 'market_1' then 1
        when 'mentor' then 1
      end as target,
      case id
        when 'streak_3' then 'streak' when 'streak_7' then 'streak'
        when 'streak_30' then 'streak'
        when 'quests_10' then 'quests_done'
        when 'material_1' then 'materials' when 'material_5' then 'materials'
        when 'material_25' then 'materials'
        when 'reviews_3' then 'reviews'
        when 'deadline_10' then 'deadlines_done'
        when 'friend_1' then 'friends' when 'friends_5' then 'friends'
        when 'polls_5' then 'poll_votes'
        when 'poll_create' then 'polls_created'
        when 'rsvp_3' then 'rsvps'
        when 'lostfound_1' then 'lost_found'
        when 'market_1' then 'listings'
        when 'mentor' then 'mentor_sessions'
      end as metric
    from core.badge_definitions
  loop
    if v_badge.target is null then
      continue;
    end if;
    v_value := coalesce((v_metrics ->> v_badge.metric)::numeric, 0);
    v_target := v_badge.target;
    v_progress := least(v_value / v_target, 1)::numeric(4, 3);

    select is_earned into v_was_earned
    from core.user_badges
    where user_id = p_user_id and badge_id = v_badge.id;

    insert into core.user_badges (user_id, badge_id, progress, is_earned)
    values (p_user_id, v_badge.id, v_progress, v_progress >= 1)
    on conflict (user_id, badge_id) do update set
      progress = excluded.progress,
      is_earned = core.user_badges.is_earned or excluded.is_earned,
      earned_at = case
        when core.user_badges.is_earned then core.user_badges.earned_at
        else now()
      end;

    if v_progress >= 1 and coalesce(v_was_earned, false) = false then
      update core.user_gamification_profiles
      set xp = xp + v_badge.xp_reward
      where user_id = p_user_id;
      if v_badge.shuriken_reward > 0 then
        perform core.apply_shuriken_delta(
          p_user_id, v_badge.emoji, 'Ачивка · ' || v_badge.name,
          v_badge.shuriken_reward
        );
      end if;
      perform internal.notify_app_push_gated(
        p_user_id, 'achievement',
        v_badge.emoji || ' Новая ачивка!',
        v_badge.name,
        '/profile'
      );
      v_newly := v_newly || jsonb_build_object(
        'id', v_badge.id, 'name', v_badge.name, 'emoji', v_badge.emoji,
        'category', v_badge.category, 'description', v_badge.description,
        'rarity', v_badge.rarity, 'isEarned', true, 'progress', 1,
        'xpReward', v_badge.xp_reward,
        'shurikenReward', v_badge.shuriken_reward
      );
    end if;
  end loop;

  return v_newly;
end;
$$;

create or replace function core.refresh_quest_progress(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_today date := (now() at time zone 'UTC')::date;
  v_week date := date_trunc('week', now() at time zone 'UTC')::date;
  v_quest record;
  v_start date;
  v_since timestamptz;
  v_value integer;
  v_completed boolean;
  v_day date;
  v_streak integer := 0;
begin
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_user_id::text, 182741)
  );
  if not exists (
    select 1 from core.user_gamification_profiles wallet
    join core.user_academic_profiles academic
      on academic.user_id = wallet.user_id
      and academic.organization_id = wallet.organization_id
    where wallet.user_id = p_user_id
  ) then
    return;
  end if;
  v_day := v_today;
  if not exists (
    select 1 from core.user_active_days
    where user_id = p_user_id and active_on = v_day
  ) then
    v_day := v_today - 1;
  end if;
  while exists (
    select 1 from core.user_active_days
    where user_id = p_user_id and active_on = v_day
  ) loop
    v_streak := v_streak + 1;
    v_day := v_day - 1;
  end loop;

  for v_quest in
    select id, period, target, xp_reward, emoji, title
    from core.quest_definitions order by id
  loop
    v_start := case when v_quest.period = 'daily' then v_today else v_week end;
    v_since := v_start::timestamp at time zone 'UTC';
    v_value := case v_quest.id
      when 'daily_reaction' then (
        select count(*) from core.lesson_reactions
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_note' then (
        select count(*) from core.group_notes
        where created_by = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_poll' then (
        select count(*) from core.poll_participations
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'daily_deadline' then (
        select count(*) from core.user_deadlines
        where user_id = p_user_id and done_at >= v_since
          and done_at <= now()
      )
      when 'weekly_active' then (
        select count(*) from core.user_active_days
        where user_id = p_user_id
          and active_on >= v_week and active_on <= v_today
      )
      when 'weekly_upload' then (
        select count(*) from core.lesson_materials
        where user_id = p_user_id and created_at >= v_since
          and created_at <= now()
      )
      when 'weekly_streak' then least(v_streak, v_quest.target)
      else null
    end;
    if v_value is null then
      continue;
    end if;
    select is_completed into v_completed from core.user_quest_progress
    where user_id = p_user_id
      and quest_id = v_quest.id and period_start = v_start;
    insert into core.user_quest_progress (
      user_id, quest_id, period_start, progress, is_completed, completed_at
    ) values (
      p_user_id, v_quest.id, v_start, least(v_value, v_quest.target),
      v_value >= v_quest.target,
      case when v_value >= v_quest.target then now() end
    )
    on conflict (user_id, quest_id, period_start) do update set
      progress = case when core.user_quest_progress.is_completed
        then v_quest.target else excluded.progress end,
      is_completed = core.user_quest_progress.is_completed or excluded.is_completed,
      completed_at = coalesce(
        core.user_quest_progress.completed_at, excluded.completed_at
      );
    if v_value >= v_quest.target and not coalesce(v_completed, false) then
      update core.user_gamification_profiles set xp = xp + v_quest.xp_reward
      where user_id = p_user_id;
      if v_quest.xp_reward > 0 then
        perform core.apply_shuriken_delta(
          p_user_id, v_quest.emoji, 'Квест · ' || v_quest.title, v_quest.xp_reward
        );
      end if;
    end if;
  end loop;
end;
$$;

create or replace function app_api_v1.close_poll(p_poll_id uuid)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_poll core.polls;
begin
  if v_uid is null then
    raise exception 'Unauthorized';
  end if;
  perform core.enforce_rate_limit('close_poll', 30, interval '1 hour');
  perform pg_advisory_xact_lock(hashtextextended(p_poll_id::text, 0));
  update core.polls set is_closed = true
  where id = p_poll_id and author_id = v_uid
  returning * into v_poll;
  if v_poll.id is null then
    raise exception 'Poll not found' using errcode = '42501';
  end if;
  return core.poll_to_json(v_poll.id, v_uid);
end;
$$;

create or replace function app_api_v1.get_polls(
  p_organization_id text, p_limit int default 50, p_offset int default 0
) returns jsonb language sql security definer set search_path to '' as $$
  with me as (select auth.uid() as uid),
  p as (
    select *, (core.poll_to_json(id, (select uid from me)) ->> 'canSeeResults')::boolean as can_see
    from core.polls
    where organization_id = p_organization_id
      and (select count(*) from core.poll_questions question where question.poll_id = core.polls.id) = 1
      and exists (
        select 1 from core.poll_questions question
        where question.poll_id = core.polls.id and question.kind in ('single', 'multiple', 'quiz')
      )
    order by created_at desc
    limit greatest(0, least(coalesce(p_limit, 50), 100))
    offset greatest(0, coalesce(p_offset, 0))
  )
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id,
    'authorId', case when not p.is_anonymous or p.author_id = (select uid from me) then p.author_id end,
    'question', p.question,
    'pollType', case when p.poll_type = 'quiz' or exists (
      select 1 from core.poll_questions question where question.poll_id = p.id and question.kind = 'quiz'
    ) then 'quiz'
      when exists (select 1 from core.poll_questions question
        where question.poll_id = p.id and question.kind = 'multiple') then 'multi'
      else 'single' end,
    'isAnonymous', p.is_anonymous,
    'showResults', p.can_see,
    'expiresAt', case when p.is_closed then least(coalesce(p.expires_at, now()), now()) else p.expires_at end,
    'createdAt', p.created_at,
    'isMine', (p.author_id = (select uid from me)),
    'totalVotes', (select count(distinct v.user_id) from core.poll_votes v where v.poll_id = p.id),
    'options', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', o.id,
        'text', o.text,
        'position', o.position,
        'isCorrect', p.can_see and o.is_correct,
        'votes', case when p.can_see then (select count(*) from core.poll_votes v where v.option_id = o.id) else 0 end,
        'votedByMe', exists (
          select 1 from core.poll_votes v
          where v.option_id = o.id and v.user_id = (select uid from me)
        )
      ) order by o.position), '[]'::jsonb)
      from core.poll_options o where o.poll_id = p.id
    )
  ) order by p.created_at desc), '[]'::jsonb)
  from p;
$$;

alter table core.poll_questions drop constraint if exists poll_questions_kind_chk;
alter table core.poll_questions add constraint poll_questions_kind_chk
check (kind in ('single', 'multiple', 'quiz', 'text', 'rating'));

update core.poll_questions question
set kind = 'quiz'
from core.polls poll
where poll.id = question.poll_id and poll.poll_type = 'quiz';

create or replace function core.poll_to_json(p_poll_id uuid, p_viewer uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_poll core.polls;
  v_author_name text;
  v_participants int;
  v_i_participated boolean;
  v_can_see boolean;
  v_questions jsonb;
begin
  if p_viewer is null or p_viewer is distinct from (select auth.uid()) then
    raise exception 'Poll viewer identity mismatch' using errcode = '42501';
  end if;
  select * into v_poll from core.polls where id = p_poll_id;
  if not found then
    return null;
  end if;

  if v_poll.is_anonymous then
    v_author_name := null;
  else
    select split_part(profile.full_name, ' ', 1) || ' '
      || left(split_part(profile.full_name, ' ', 2), 1) || '.'
    into v_author_name
    from core.user_academic_profiles profile
    where profile.user_id = v_poll.author_id;
    v_author_name := coalesce(v_author_name, 'Студент');
  end if;

  select count(distinct a.user_id) into v_participants
  from core.poll_answers a where a.poll_id = v_poll.id;

  select exists (
    select 1 from core.poll_answers a
    where a.poll_id = v_poll.id and a.user_id = p_viewer
  ) into v_i_participated;

  v_can_see := v_poll.author_id = p_viewer or case v_poll.results_visibility
    when 'always' then true
    when 'after_vote' then v_i_participated or v_poll.is_closed
      or (v_poll.expires_at is not null and v_poll.expires_at <= now())
    when 'after_close' then v_poll.is_closed
      or (v_poll.expires_at is not null and v_poll.expires_at <= now())
    else false
  end;

  select coalesce(jsonb_agg(jsonb_build_object(
    'id', q.id,
    'position', q.position,
    'text', q.text,
    'kind', q.kind,
    'isRequired', q.is_required,
    'options', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', o.id,
        'position', o.position,
        'text', o.text,
        'isCorrect', v_can_see and o.is_correct,
        'votes', case when v_can_see then (select count(*) from core.poll_answers a where a.option_id = o.id) else 0 end,
        'votedByMe', exists (
          select 1 from core.poll_answers a
          where a.option_id = o.id and a.user_id = p_viewer
        )
      ) order by o.position), '[]'::jsonb)
      from core.poll_options o where o.question_id = q.id
    ),
    'myOptionIds', (
      select coalesce(jsonb_agg(a.option_id), '[]'::jsonb)
      from core.poll_answers a
      where a.question_id = q.id and a.user_id = p_viewer and a.option_id is not null
    ),
    'myTextAnswer', (
      select a.text_answer from core.poll_answers a
      where a.question_id = q.id and a.user_id = p_viewer and a.text_answer is not null
      limit 1
    ),
    'myRating', (
      select a.rating from core.poll_answers a
      where a.question_id = q.id and a.user_id = p_viewer and a.rating is not null
      limit 1
    ),
    'ratingAverage', case when v_can_see then (
      select round(avg(a.rating)::numeric, 2) from core.poll_answers a
      where a.question_id = q.id and a.rating is not null
    ) else null end,
    'ratingCount', case when v_can_see then (
      select count(*) from core.poll_answers a
      where a.question_id = q.id and a.rating is not null
    ) else 0 end,
    'textAnswers', case when v_can_see then (
        select coalesce(jsonb_agg(a.text_answer order by a.created_at), '[]'::jsonb)
        from core.poll_answers a
        where a.question_id = q.id and a.text_answer is not null
      ) else '[]'::jsonb end
  ) order by q.position), '[]'::jsonb)
  into v_questions
  from core.poll_questions q where q.poll_id = v_poll.id;

  return jsonb_build_object(
    'id', v_poll.id,
    'title', v_poll.title,
    'description', v_poll.description,
    'category', v_poll.category,
    'authorId', case when not v_poll.is_anonymous or v_poll.author_id = p_viewer then v_poll.author_id end,
    'authorName', v_author_name,
    'isAnonymous', v_poll.is_anonymous,
    'resultsVisibility', v_poll.results_visibility,
    'expiresAt', v_poll.expires_at,
    'createdAt', v_poll.created_at,
    'isClosed', v_poll.is_closed
      or (v_poll.expires_at is not null and v_poll.expires_at <= now()),
    'allowChange', v_poll.allow_change,
    'isMine', v_poll.author_id = p_viewer,
    'participantsCount', v_participants,
    'iParticipated', v_i_participated,
    'canSeeResults', v_can_see,
    'questions', v_questions
  );
end;
$$;

create or replace function app_api_v1.create_poll_v2(
  p_organization_id text, p_title text, p_description text default '',
  p_category text default null, p_is_anonymous boolean default false,
  p_results_visibility text default 'always', p_expires_at timestamptz default null,
  p_allow_change boolean default false, p_questions jsonb default '[]'::jsonb
) returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_poll_id uuid;
  v_title text;
  v_description text;
  v_category text;
  v_question jsonb;
  v_question_id uuid;
  v_kind text;
  v_option_text text;
  v_option_count int;
  v_correct_index int;
  v_opt_position int;
  v_position int := 0;
  v_question_count int;
begin
  if v_uid is null then
    raise exception 'Unauthorized';
  end if;
  perform core.enforce_rate_limit('create_poll', 10, interval '1 hour');

  v_title := core.validate_text(p_title, 'Название', 200, true);
  v_description := core.validate_text(p_description, 'Описание', 2000, false);
  v_category := nullif(btrim(coalesce(p_category, '')), '');
  if v_category is not null
    and v_category not in ('general', 'academic', 'events', 'feedback', 'other') then
    raise exception 'Invalid category' using errcode = '22023';
  end if;
  if p_results_visibility not in ('always', 'after_vote', 'after_close') then
    raise exception 'Invalid results visibility' using errcode = '22023';
  end if;
  if p_questions is null or jsonb_typeof(p_questions) <> 'array' then
    raise exception 'Добавьте хотя бы один вопрос' using errcode = '22023';
  end if;
  select count(*) into v_question_count from jsonb_array_elements(p_questions);
  if v_question_count < 1 or v_question_count > 10 then
    raise exception 'От 1 до 10 вопросов' using errcode = '22023';
  end if;

  insert into core.polls (
    organization_id, author_id, question, title, description, category,
    is_anonymous, results_visibility, expires_at, allow_change, show_results
  ) values (
    p_organization_id, v_uid, v_title, v_title, v_description, v_category,
    coalesce(p_is_anonymous, false), p_results_visibility, p_expires_at,
    coalesce(p_allow_change, false), p_results_visibility = 'always'
  ) returning id into v_poll_id;

  for v_question in select * from jsonb_array_elements(p_questions)
  loop
    v_kind := v_question ->> 'kind';
    if v_kind is null or v_kind not in ('single', 'multiple', 'quiz', 'text', 'rating') then
      raise exception 'Invalid question kind' using errcode = '22023';
    end if;

    insert into core.poll_questions (poll_id, position, text, kind, is_required)
    values (
      v_poll_id, v_position,
      core.validate_text(v_question ->> 'text', 'Вопрос', 300, true),
      v_kind, coalesce((v_question ->> 'isRequired')::boolean, true)
    ) returning id into v_question_id;

    if v_kind in ('single', 'multiple', 'quiz') then
      v_option_count := jsonb_array_length(coalesce(v_question -> 'options', '[]'::jsonb));
      if v_option_count < 2 or v_option_count > 10 then
        raise exception 'От 2 до 10 вариантов ответа' using errcode = '22023';
      end if;
      v_correct_index := null;
      if v_kind = 'quiz' then
        if coalesce(v_question ->> 'correctIndex', '') !~ '^[0-9]$' then
          raise exception 'Choose a correct quiz option' using errcode = '22023';
        end if;
        v_correct_index := (v_question ->> 'correctIndex')::int;
        if v_correct_index >= v_option_count then
          raise exception 'Invalid correct quiz option' using errcode = '22023';
        end if;
      end if;
      v_opt_position := 0;
      for v_option_text in select * from jsonb_array_elements_text(
        coalesce(v_question -> 'options', '[]'::jsonb)
      )
      loop
        insert into core.poll_options (poll_id, question_id, position, text, is_correct)
        values (
          v_poll_id, v_question_id, v_opt_position,
          core.validate_text(v_option_text, 'Вариант', 200, true),
          coalesce(v_opt_position = v_correct_index, false)
        );
        v_opt_position := v_opt_position + 1;
      end loop;
    end if;

    v_position := v_position + 1;
  end loop;

  return core.poll_to_json(v_poll_id, v_uid);
end;
$$;

notify pgrst, 'reload schema';
