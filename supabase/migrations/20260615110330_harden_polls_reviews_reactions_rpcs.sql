-- create_poll: rate limit, question length, option count + length caps.
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
    organization_id, author_id, question, poll_type,
    is_anonymous, show_results, expires_at
  ) values (
    p_organization_id, v_user,
    core.validate_text(p_question, 'Вопрос', 300, true), p_poll_type,
    coalesce(p_is_anonymous, false), coalesce(p_show_results, true), p_expires_at
  ) returning id into v_id;

  foreach v_opt in array p_options loop
    if length(btrim(v_opt)) > 0 then
      insert into core.poll_options (poll_id, position, text, is_correct)
      values (
        v_id, v_pos, core.validate_text(v_opt, 'Вариант', 200, true),
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

-- vote_poll: rate limit + cap on submitted option ids.
create or replace function app_api_v1.vote_poll(p_poll_id uuid, p_option_ids uuid[])
  returns void language plpgsql set search_path to ''
as $function$
declare
  v_user uuid := (select auth.uid());
  v_type text;
  v_expires timestamptz;
  v_opt uuid;
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('vote_poll', 60, interval '1 hour');
  if array_length(p_option_ids, 1) > 30 then
    raise exception 'Слишком много вариантов' using errcode = '22023';
  end if;
  select poll_type, expires_at into v_type, v_expires from core.polls where id = p_poll_id;
  if v_type is null then raise exception 'Poll not found'; end if;
  if v_expires is not null and v_expires < now() then raise exception 'Poll has ended'; end if;

  if p_option_ids is not null and exists (
    select 1 from unnest(p_option_ids) oid
    where not exists (select 1 from core.poll_options o where o.id = oid and o.poll_id = p_poll_id)
  ) then
    raise exception 'Invalid option for this poll';
  end if;

  delete from core.poll_votes where poll_id = p_poll_id and user_id = v_user;

  if v_type in ('single','quiz') then
    if array_length(p_option_ids, 1) >= 1 then
      insert into core.poll_votes (poll_id, option_id, user_id)
      values (p_poll_id, p_option_ids[1], v_user);
    end if;
  else
    foreach v_opt in array coalesce(p_option_ids, array[]::uuid[]) loop
      insert into core.poll_votes (poll_id, option_id, user_id)
      values (p_poll_id, v_opt, v_user)
      on conflict (option_id, user_id) do nothing;
    end loop;
  end if;
end;
$function$;

-- upsert_lesson_review: rate limit, body length, rating bounds.
create or replace function app_api_v1.upsert_lesson_review(
  p_organization_id text, p_subject_name text, p_lesson_date date,
  p_lesson_bells_number integer, p_lesson_uid text, p_body text,
  p_rating integer, p_is_anonymous boolean)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_lesson_review', 30, interval '1 hour');
  insert into core.lesson_reviews (
    organization_id, user_id, subject_name, lesson_date, lesson_bells_number,
    lesson_uid, body, rating, is_anonymous)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_lesson_date, p_lesson_bells_number,
    nullif(trim(coalesce(p_lesson_uid, '')), ''),
    core.validate_text(p_body, 'Отзыв', 2000, false),
    greatest(0, least(5, coalesce(p_rating, 0))),
    coalesce(p_is_anonymous, false))
  on conflict (user_id, organization_id, subject_name, lesson_date, lesson_bells_number)
  do update set body = excluded.body, rating = excluded.rating,
    is_anonymous = excluded.is_anonymous, lesson_uid = excluded.lesson_uid;
  return app_api_v1.get_lesson_reviews(
    p_organization_id, p_subject_name, p_lesson_date, p_lesson_bells_number);
end;
$function$;

-- upsert_teacher_review: was SQL with no auth check. Add auth gate, rate
-- limit, length + rating bounds.
create or replace function app_api_v1.upsert_teacher_review(
  p_organization_id text, p_teacher_name text, p_clarity integer,
  p_loyalty integer, p_usefulness integer, p_body text default ''::text,
  p_is_anonymous boolean default false)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_teacher_review', 20, interval '1 hour');
  insert into core.teacher_reviews (
    organization_id, user_id, teacher_name, clarity, loyalty,
    usefulness, body, is_anonymous)
  values (
    p_organization_id, v_user_id,
    core.validate_text(p_teacher_name, 'Преподаватель', 200, true),
    greatest(0, least(5, coalesce(p_clarity, 0))),
    greatest(0, least(5, coalesce(p_loyalty, 0))),
    greatest(0, least(5, coalesce(p_usefulness, 0))),
    core.validate_text(p_body, 'Отзыв', 2000, false),
    coalesce(p_is_anonymous, false))
  on conflict (user_id, teacher_name) do update set
    clarity = excluded.clarity, loyalty = excluded.loyalty,
    usefulness = excluded.usefulness, body = excluded.body,
    is_anonymous = excluded.is_anonymous;
end;
$function$;

-- upsert_lesson_reaction: rate limit + bound reaction code length.
create or replace function app_api_v1.upsert_lesson_reaction(
  p_subject_name text, p_lesson_date date, p_lesson_bells_number integer,
  p_reaction_type text)
  returns jsonb language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('upsert_lesson_reaction', 120, interval '1 hour');
  insert into core.lesson_reactions (
    user_id, subject_name, lesson_date, lesson_bells_number, reaction_type)
  values (
    v_user_id, core.validate_text(p_subject_name, 'Предмет', 300, false),
    p_lesson_date, p_lesson_bells_number,
    core.validate_text(p_reaction_type, 'Реакция', 40, true))
  on conflict (user_id, subject_name, lesson_date, lesson_bells_number)
  do update set reaction_type = excluded.reaction_type;
  return app_api_v1.get_lesson_reactions(
    p_subject_name, p_lesson_date, p_lesson_bells_number);
end;
$function$;
