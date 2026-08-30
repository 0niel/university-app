-- Community polls: real user-generated polls backing the poll-creator screen.
-- Deployed to the live project (ejzybbyjwtzbibrrwrli) via apply_migration; this
-- file version-controls the schema. Pattern mirrors group_posts/marketplace:
-- core.* tables + RLS, app_api_v1.* logic (resolves auth.uid()), public.* wrappers.

create table if not exists core.polls (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null,
  author_id uuid not null,
  question text not null,
  poll_type text not null default 'single',
  is_anonymous boolean not null default false,
  show_results boolean not null default true,
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  constraint polls_type_chk check (poll_type in ('single','multi','quiz'))
);

create table if not exists core.poll_options (
  id uuid primary key default extensions.gen_random_uuid(),
  poll_id uuid not null references core.polls(id) on delete cascade,
  position int not null default 0,
  text text not null,
  is_correct boolean not null default false
);

create table if not exists core.poll_votes (
  id uuid primary key default extensions.gen_random_uuid(),
  poll_id uuid not null references core.polls(id) on delete cascade,
  option_id uuid not null references core.poll_options(id) on delete cascade,
  user_id uuid not null,
  created_at timestamptz not null default now(),
  unique (option_id, user_id)
);

create index if not exists poll_options_poll_idx on core.poll_options(poll_id);
create index if not exists poll_votes_poll_idx on core.poll_votes(poll_id);
create index if not exists poll_votes_option_idx on core.poll_votes(option_id);
create index if not exists polls_org_created_idx on core.polls(organization_id, created_at desc);

alter table core.polls enable row level security;
alter table core.poll_options enable row level security;
alter table core.poll_votes enable row level security;

create policy "polls readable by org users" on core.polls for select using (true);
create policy "users create own polls" on core.polls for insert
  with check ((select auth.uid()) = author_id);
create policy "authors delete own polls" on core.polls for delete
  using ((select auth.uid()) = author_id);

create policy "poll options readable" on core.poll_options for select using (true);
create policy "poll author inserts options" on core.poll_options for insert
  with check (exists (
    select 1 from core.polls p where p.id = poll_id and p.author_id = (select auth.uid())
  ));

-- Votes are private to each user (anonymity); aggregate counts are exposed only
-- through the SECURITY DEFINER get_polls RPC.
create policy "users read own votes" on core.poll_votes for select
  using ((select auth.uid()) = user_id);
create policy "users cast own votes" on core.poll_votes for insert
  with check ((select auth.uid()) = user_id);
create policy "users remove own votes" on core.poll_votes for delete
  using ((select auth.uid()) = user_id);

grant select, insert, delete on core.polls to authenticated;
grant select, insert on core.poll_options to authenticated;
grant select, insert, delete on core.poll_votes to authenticated;

-- ── create_poll ─────────────────────────────────────────────────────────────
create or replace function app_api_v1.create_poll(
  p_organization_id text, p_question text, p_options text[],
  p_poll_type text default 'single', p_is_anonymous boolean default false,
  p_show_results boolean default true, p_expires_at timestamptz default null,
  p_correct_index int default null
) returns uuid language plpgsql set search_path to '' as $$
declare
  v_user uuid := (select auth.uid());
  v_id uuid;
  v_opt text;
  v_pos int := 0;
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  if p_question is null or length(btrim(p_question)) = 0 then
    raise exception 'Question is required';
  end if;
  if p_poll_type not in ('single','multi','quiz') then
    raise exception 'Invalid poll type';
  end if;
  if p_options is null or array_length(p_options, 1) < 2 then
    raise exception 'At least two options are required';
  end if;

  insert into core.polls (
    organization_id, author_id, question, poll_type,
    is_anonymous, show_results, expires_at
  ) values (
    p_organization_id, v_user, btrim(p_question), p_poll_type,
    coalesce(p_is_anonymous, false), coalesce(p_show_results, true), p_expires_at
  ) returning id into v_id;

  foreach v_opt in array p_options loop
    if length(btrim(v_opt)) > 0 then
      insert into core.poll_options (poll_id, position, text, is_correct)
      values (
        v_id, v_pos, btrim(v_opt),
        (p_poll_type = 'quiz' and p_correct_index is not null and v_pos = p_correct_index)
      );
      v_pos := v_pos + 1;
    end if;
  end loop;

  if v_pos < 2 then
    raise exception 'At least two non-empty options are required';
  end if;
  return v_id;
end; $$;

-- ── vote_poll ───────────────────────────────────────────────────────────────
create or replace function app_api_v1.vote_poll(
  p_poll_id uuid, p_option_ids uuid[]
) returns void language plpgsql set search_path to '' as $$
declare
  v_user uuid := (select auth.uid());
  v_type text;
  v_expires timestamptz;
  v_opt uuid;
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
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
end; $$;

-- ── delete_poll ─────────────────────────────────────────────────────────────
create or replace function app_api_v1.delete_poll(p_poll_id uuid)
returns void language plpgsql set search_path to '' as $$
declare v_user uuid := (select auth.uid());
begin
  if v_user is null then raise exception 'Unauthorized'; end if;
  delete from core.polls where id = p_poll_id and author_id = v_user;
end; $$;

-- ── get_polls (SECURITY DEFINER: aggregates votes across all users) ──────────
create or replace function app_api_v1.get_polls(
  p_organization_id text, p_limit int default 50, p_offset int default 0
) returns jsonb language sql security definer set search_path to '' as $$
  with me as (select auth.uid() as uid),
  p as (
    select * from core.polls
    where organization_id = p_organization_id
    order by created_at desc
    limit greatest(0, least(coalesce(p_limit, 50), 100))
    offset greatest(0, coalesce(p_offset, 0))
  )
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id,
    'authorId', p.author_id,
    'question', p.question,
    'pollType', p.poll_type,
    'isAnonymous', p.is_anonymous,
    'showResults', p.show_results,
    'expiresAt', p.expires_at,
    'createdAt', p.created_at,
    'isMine', (p.author_id = (select uid from me)),
    'totalVotes', (select count(distinct v.user_id) from core.poll_votes v where v.poll_id = p.id),
    'options', (
      select coalesce(jsonb_agg(jsonb_build_object(
        'id', o.id,
        'text', o.text,
        'position', o.position,
        'isCorrect', o.is_correct,
        'votes', (select count(*) from core.poll_votes v where v.option_id = o.id),
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

-- ── public wrappers (called by the Supabase client via rpc()) ────────────────
create or replace function public.create_poll(
  p_organization_id text, p_question text, p_options text[],
  p_poll_type text default 'single', p_is_anonymous boolean default false,
  p_show_results boolean default true, p_expires_at timestamptz default null,
  p_correct_index int default null
) returns uuid language sql set search_path to '' as $$
  select app_api_v1.create_poll(p_organization_id, p_question, p_options,
    p_poll_type, p_is_anonymous, p_show_results, p_expires_at, p_correct_index);
$$;

create or replace function public.vote_poll(p_poll_id uuid, p_option_ids uuid[])
returns void language sql set search_path to '' as $$
  select app_api_v1.vote_poll(p_poll_id, p_option_ids);
$$;

create or replace function public.delete_poll(p_poll_id uuid)
returns void language sql set search_path to '' as $$
  select app_api_v1.delete_poll(p_poll_id);
$$;

create or replace function public.get_polls(p_organization_id text, p_limit int default 50, p_offset int default 0)
returns jsonb language sql set search_path to '' as $$
  select app_api_v1.get_polls(p_organization_id, p_limit, p_offset);
$$;

grant execute on function app_api_v1.create_poll(text, text, text[], text, boolean, boolean, timestamptz, int) to authenticated;
grant execute on function app_api_v1.vote_poll(uuid, uuid[]) to authenticated;
grant execute on function app_api_v1.delete_poll(uuid) to authenticated;
grant execute on function app_api_v1.get_polls(text, int, int) to authenticated;
grant execute on function public.create_poll(text, text, text[], text, boolean, boolean, timestamptz, int) to authenticated;
grant execute on function public.vote_poll(uuid, uuid[]) to authenticated;
grant execute on function public.delete_poll(uuid) to authenticated;
grant execute on function public.get_polls(text, int, int) to authenticated;
