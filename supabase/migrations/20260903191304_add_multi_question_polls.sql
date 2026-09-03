alter table core.polls
  add column if not exists title text,
  add column if not exists description text not null default '',
  add column if not exists category text,
  add column if not exists is_closed boolean not null default false,
  add column if not exists allow_change boolean not null default false,
  add column if not exists results_visibility text not null default 'always';

alter table core.polls drop constraint if exists polls_results_visibility_chk;
alter table core.polls add constraint polls_results_visibility_chk check (
  results_visibility in ('always', 'after_vote', 'after_close')
);

alter table core.polls drop constraint if exists polls_category_chk;
alter table core.polls add constraint polls_category_chk check (
  category is null or category in ('general', 'academic', 'events', 'feedback', 'other')
);

create table if not exists core.poll_questions (
  id uuid primary key default extensions.gen_random_uuid(),
  poll_id uuid not null references core.polls(id) on delete cascade,
  position int not null default 0,
  text text not null,
  kind text not null default 'single',
  is_required boolean not null default true,
  constraint poll_questions_kind_chk check (kind in ('single', 'multiple', 'text', 'rating'))
);

create index if not exists poll_questions_poll_idx on core.poll_questions(poll_id);

alter table core.poll_options
  add column if not exists question_id uuid references core.poll_questions(id) on delete cascade;

create index if not exists poll_options_question_idx on core.poll_options(question_id);

do $$
declare
  v_poll record;
  v_question_id uuid;
  v_kind text;
begin
  for v_poll in select * from core.polls where title is null
  loop
    v_kind := case when v_poll.poll_type = 'multi' then 'multiple' else 'single' end;
    insert into core.poll_questions (poll_id, position, text, kind, is_required)
    values (
      v_poll.id, 0, coalesce(nullif(btrim(v_poll.question), ''), 'Вопрос'), v_kind, true
    )
    returning id into v_question_id;

    update core.poll_options
    set question_id = v_question_id
    where poll_id = v_poll.id and question_id is null;

    update core.polls
    set
      title = coalesce(nullif(btrim(v_poll.question), ''), 'Опрос'),
      results_visibility = case when v_poll.show_results then 'always' else 'after_vote' end
    where id = v_poll.id;
  end loop;
end;
$$;

alter table core.polls alter column title set not null;

create table if not exists core.poll_answers (
  id uuid primary key default extensions.gen_random_uuid(),
  poll_id uuid not null references core.polls(id) on delete cascade,
  question_id uuid not null references core.poll_questions(id) on delete cascade,
  user_id uuid not null,
  option_id uuid references core.poll_options(id) on delete cascade,
  text_answer text,
  rating int,
  created_at timestamptz not null default now(),
  constraint poll_answers_rating_range check (rating is null or rating between 1 and 5),
  constraint poll_answers_kind_chk check (
    (option_id is not null and text_answer is null and rating is null)
    or (option_id is null and text_answer is not null and rating is null)
    or (option_id is null and text_answer is null and rating is not null)
  ),
  unique (question_id, user_id, option_id)
);

create unique index if not exists poll_answers_single_per_question
  on core.poll_answers (question_id, user_id) where option_id is null;

create index if not exists poll_answers_poll_user_idx on core.poll_answers(poll_id, user_id);
create index if not exists poll_answers_question_idx on core.poll_answers(question_id);
create index if not exists poll_answers_option_idx
  on core.poll_answers(option_id) where option_id is not null;

alter table core.poll_questions enable row level security;
alter table core.poll_answers enable row level security;

drop policy if exists "poll questions readable" on core.poll_questions;
create policy "poll questions readable" on core.poll_questions for select using (true);

drop policy if exists "poll author inserts questions" on core.poll_questions;
create policy "poll author inserts questions" on core.poll_questions for insert
  with check (exists (
    select 1 from core.polls p where p.id = poll_id and p.author_id = (select auth.uid())
  ));

drop policy if exists "users read own poll answers" on core.poll_answers;
create policy "users read own poll answers" on core.poll_answers for select
  using ((select auth.uid()) = user_id);

drop policy if exists "users insert own poll answers" on core.poll_answers;
create policy "users insert own poll answers" on core.poll_answers for insert
  with check ((select auth.uid()) = user_id);

drop policy if exists "users delete own poll answers" on core.poll_answers;
create policy "users delete own poll answers" on core.poll_answers for delete
  using ((select auth.uid()) = user_id);

drop policy if exists "authors close own polls" on core.polls;
create policy "authors close own polls" on core.polls for update
  using ((select auth.uid()) = author_id)
  with check ((select auth.uid()) = author_id);

grant select, insert on core.poll_questions to authenticated;
grant select, insert, delete on core.poll_answers to authenticated;
grant update (is_closed) on core.polls to authenticated;

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
        'isCorrect', o.is_correct,
        'votes', (select count(*) from core.poll_answers a where a.option_id = o.id),
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
    'ratingAverage', (
      select round(avg(a.rating)::numeric, 2) from core.poll_answers a
      where a.question_id = q.id and a.rating is not null
    ),
    'ratingCount', (
      select count(*) from core.poll_answers a
      where a.question_id = q.id and a.rating is not null
    ),
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
    'authorId', v_poll.author_id,
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

revoke all on function core.poll_to_json(uuid, uuid) from public, anon;
grant execute on function core.poll_to_json(uuid, uuid) to authenticated;

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
    if v_kind is null or v_kind not in ('single', 'multiple', 'text', 'rating') then
      raise exception 'Invalid question kind' using errcode = '22023';
    end if;

    insert into core.poll_questions (poll_id, position, text, kind, is_required)
    values (
      v_poll_id, v_position,
      core.validate_text(v_question ->> 'text', 'Вопрос', 300, true),
      v_kind, coalesce((v_question ->> 'isRequired')::boolean, true)
    ) returning id into v_question_id;

    if v_kind in ('single', 'multiple') then
      v_option_count := jsonb_array_length(coalesce(v_question -> 'options', '[]'::jsonb));
      if v_option_count < 2 or v_option_count > 10 then
        raise exception 'От 2 до 10 вариантов ответа' using errcode = '22023';
      end if;
      v_opt_position := 0;
      for v_option_text in select * from jsonb_array_elements_text(
        coalesce(v_question -> 'options', '[]'::jsonb)
      )
      loop
        insert into core.poll_options (poll_id, question_id, position, text)
        values (
          v_poll_id, v_question_id, v_opt_position,
          core.validate_text(v_option_text, 'Вариант', 200, true)
        );
        v_opt_position := v_opt_position + 1;
      end loop;
    end if;

    v_position := v_position + 1;
  end loop;

  return core.poll_to_json(v_poll_id, v_uid);
end;
$$;

create or replace function app_api_v1.get_polls_v2(
  p_organization_id text, p_filter text default 'all', p_category text default null,
  p_query text default null, p_limit int default 20, p_offset int default 0
) returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select auth.uid() as uid),
  base as (
    select p.id, p.created_at from core.polls p
    where p.organization_id = p_organization_id
      and p.title is not null
      and (p_category is null or p.category = p_category)
      and (
        p_query is null or btrim(p_query) = ''
        or p.title ilike '%' || btrim(p_query) || '%'
        or p.description ilike '%' || btrim(p_query) || '%'
      )
      and (
        p_filter is null or p_filter = 'all'
        or (p_filter = 'active' and not p.is_closed
            and (p.expires_at is null or p.expires_at > now()))
        or (p_filter = 'closed' and (p.is_closed
            or (p.expires_at is not null and p.expires_at <= now())))
        or (p_filter = 'mine' and p.author_id = (select uid from me))
        or (p_filter = 'participated' and exists (
              select 1 from core.poll_answers a
              where a.poll_id = p.id and a.user_id = (select uid from me)
            ))
      )
    order by p.created_at desc
    limit greatest(0, least(coalesce(p_limit, 20), 50))
    offset greatest(0, coalesce(p_offset, 0))
  )
  select coalesce(
    jsonb_agg(core.poll_to_json(base.id, (select uid from me)) order by base.created_at desc),
    '[]'::jsonb
  )
  from base;
$$;

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

    if v_question.kind in ('single', 'multiple') then
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
      if v_question.kind = 'single' and array_length(v_option_ids, 1) > 1 then
        raise exception 'Можно выбрать только один вариант' using errcode = '22023';
      end if;
      if array_length(v_option_ids, 1) > 10 then
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
  update core.polls set is_closed = true
  where id = p_poll_id and author_id = v_uid
  returning * into v_poll;
  if v_poll.id is null then
    raise exception 'Poll not found' using errcode = '42501';
  end if;
  return core.poll_to_json(v_poll.id, v_uid);
end;
$$;

create or replace function public.create_poll_v2(
  p_organization_id text, p_title text, p_description text default '',
  p_category text default null, p_is_anonymous boolean default false,
  p_results_visibility text default 'always', p_expires_at timestamptz default null,
  p_allow_change boolean default false, p_questions jsonb default '[]'::jsonb
) returns jsonb
language sql
set search_path = ''
as $$
  select app_api_v1.create_poll_v2(
    p_organization_id, p_title, p_description, p_category, p_is_anonymous,
    p_results_visibility, p_expires_at, p_allow_change, p_questions
  );
$$;

create or replace function public.get_polls_v2(
  p_organization_id text, p_filter text default 'all', p_category text default null,
  p_query text default null, p_limit int default 20, p_offset int default 0
) returns jsonb
language sql
set search_path = ''
as $$
  select app_api_v1.get_polls_v2(p_organization_id, p_filter, p_category, p_query, p_limit, p_offset);
$$;

create or replace function public.submit_poll_answers(p_poll_id uuid, p_answers jsonb)
returns jsonb
language sql
set search_path = ''
as $$
  select app_api_v1.submit_poll_answers(p_poll_id, p_answers);
$$;

create or replace function public.close_poll(p_poll_id uuid)
returns jsonb
language sql
set search_path = ''
as $$
  select app_api_v1.close_poll(p_poll_id);
$$;

revoke all on function app_api_v1.create_poll_v2(text, text, text, text, boolean, text, timestamptz, boolean, jsonb) from public, anon;
grant execute on function app_api_v1.create_poll_v2(text, text, text, text, boolean, text, timestamptz, boolean, jsonb) to authenticated;
revoke all on function app_api_v1.get_polls_v2(text, text, text, text, int, int) from public, anon;
grant execute on function app_api_v1.get_polls_v2(text, text, text, text, int, int) to authenticated;
revoke all on function app_api_v1.submit_poll_answers(uuid, jsonb) from public, anon;
grant execute on function app_api_v1.submit_poll_answers(uuid, jsonb) to authenticated;
revoke all on function app_api_v1.close_poll(uuid) from public, anon;
grant execute on function app_api_v1.close_poll(uuid) to authenticated;

revoke all on function public.create_poll_v2(text, text, text, text, boolean, text, timestamptz, boolean, jsonb) from public, anon;
grant execute on function public.create_poll_v2(text, text, text, text, boolean, text, timestamptz, boolean, jsonb) to authenticated;
revoke all on function public.get_polls_v2(text, text, text, text, int, int) from public, anon;
grant execute on function public.get_polls_v2(text, text, text, text, int, int) to authenticated;
revoke all on function public.submit_poll_answers(uuid, jsonb) from public, anon;
grant execute on function public.submit_poll_answers(uuid, jsonb) to authenticated;
revoke all on function public.close_poll(uuid) from public, anon;
grant execute on function public.close_poll(uuid) to authenticated;

notify pgrst, 'reload schema';
