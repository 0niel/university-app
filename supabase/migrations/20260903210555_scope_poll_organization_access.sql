drop policy if exists "polls readable by org users" on core.polls;
create policy "polls readable by org users" on core.polls
for select to authenticated using (
  exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = core.polls.organization_id
  )
);

drop policy if exists "users create own polls" on core.polls;
create policy "users create own polls" on core.polls
for insert to authenticated with check (
  author_id = (select auth.uid())
  and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = (select auth.uid())
      and profile.organization_id = core.polls.organization_id
  )
);

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
  select poll.* into v_poll from core.polls poll
  where poll.id = p_poll_id and exists (
    select 1 from core.user_academic_profiles profile
    where profile.user_id = p_viewer
      and profile.organization_id = poll.organization_id
  );
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

create or replace function app_api_v1.get_polls(
  p_organization_id text, p_limit int default 50, p_offset int default 0
) returns jsonb language sql security definer set search_path to '' as $$
  with me as (select auth.uid() as uid),
  p as (
    select *, (core.poll_to_json(id, (select uid from me)) ->> 'canSeeResults')::boolean as can_see
    from core.polls
    where organization_id = p_organization_id
      and exists (
        select 1 from core.user_academic_profiles profile
        where profile.user_id = (select uid from me)
          and profile.organization_id = core.polls.organization_id
      )
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
      and exists (
        select 1 from core.user_academic_profiles profile
        where profile.user_id = (select uid from me)
          and profile.organization_id = p.organization_id
      )
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
