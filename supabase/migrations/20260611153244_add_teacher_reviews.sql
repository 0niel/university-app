-- Профиль препода: отзывы с оценками «понятность/лояльность/польза»,
-- агрегаты и предметы из живого расписания.

create table core.teacher_reviews (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  teacher_name text not null,
  clarity smallint not null,
  loyalty smallint not null,
  usefulness smallint not null,
  body text not null default '',
  is_anonymous boolean not null default false,
  created_at timestamptz not null default now(),
  unique (user_id, teacher_name),
  constraint teacher_reviews_clarity_valid check (clarity between 1 and 5),
  constraint teacher_reviews_loyalty_valid check (loyalty between 1 and 5),
  constraint teacher_reviews_usefulness_valid
    check (usefulness between 1 and 5),
  constraint teacher_reviews_teacher_not_empty
    check (length(trim(teacher_name)) > 0)
);

create index teacher_reviews_teacher_idx
on core.teacher_reviews (organization_id, teacher_name, created_at desc);

alter table core.teacher_reviews enable row level security;

create policy "teacher reviews readable by org users"
on core.teacher_reviews for select to authenticated using (true);

create policy "users write own teacher reviews"
on core.teacher_reviews for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "users update own teacher reviews"
on core.teacher_reviews for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users delete own teacher reviews"
on core.teacher_reviews for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on core.teacher_reviews
  to authenticated;
grant all on core.teacher_reviews to service_role;

create or replace function app_api_v1.get_teacher_profile(
  p_organization_id text,
  p_teacher_name text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'teacherName', p_teacher_name,
    'reviewsCount', (
      select count(*) from core.teacher_reviews r
      where r.organization_id = p_organization_id
        and r.teacher_name = p_teacher_name
    ),
    'clarity', (
      select round(avg(r.clarity)::numeric, 1)
      from core.teacher_reviews r
      where r.organization_id = p_organization_id
        and r.teacher_name = p_teacher_name
    ),
    'loyalty', (
      select round(avg(r.loyalty)::numeric, 1)
      from core.teacher_reviews r
      where r.organization_id = p_organization_id
        and r.teacher_name = p_teacher_name
    ),
    'usefulness', (
      select round(avg(r.usefulness)::numeric, 1)
      from core.teacher_reviews r
      where r.organization_id = p_organization_id
        and r.teacher_name = p_teacher_name
    ),
    'subjects', (
      select coalesce(jsonb_agg(distinct d.name), '[]'::jsonb)
      from core.schedule_teachers t
      join core.schedule_part_teachers pt on pt.teacher_id = t.id
      join core.schedule_parts p on p.id = pt.schedule_part_id
      join core.schedule_disciplines d on d.id = p.discipline_id
      where t.organization_id = p_organization_id
        and t.full_name = p_teacher_name
    ),
    'reviews', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', r.id,
            'clarity', r.clarity,
            'loyalty', r.loyalty,
            'usefulness', r.usefulness,
            'body', r.body,
            'createdAt', r.created_at,
            'isMine', r.user_id = (select auth.uid()),
            'authorName', case
              when r.is_anonymous then 'Аноним'
              else coalesce(
                (select split_part(pr.full_name, ' ', 1) || ' '
                    || left(split_part(pr.full_name, ' ', 2), 1) || '.'
                 from core.user_academic_profiles pr
                 where pr.user_id = r.user_id),
                'студент'
              )
            end
          )
          order by r.created_at desc
        ),
        '[]'::jsonb
      )
      from (
        select * from core.teacher_reviews
        where organization_id = p_organization_id
          and teacher_name = p_teacher_name
        order by created_at desc
        limit 50
      ) r
    )
  );
$$;

create or replace function app_api_v1.upsert_teacher_review(
  p_organization_id text,
  p_teacher_name text,
  p_clarity integer,
  p_loyalty integer,
  p_usefulness integer,
  p_body text default '',
  p_is_anonymous boolean default false
)
returns void
language sql
security invoker
set search_path = ''
as $$
  insert into core.teacher_reviews (
    organization_id, user_id, teacher_name, clarity, loyalty,
    usefulness, body, is_anonymous
  )
  values (
    p_organization_id, (select auth.uid()), p_teacher_name,
    p_clarity, p_loyalty, p_usefulness, coalesce(p_body, ''),
    coalesce(p_is_anonymous, false)
  )
  on conflict (user_id, teacher_name) do update set
    clarity = excluded.clarity,
    loyalty = excluded.loyalty,
    usefulness = excluded.usefulness,
    body = excluded.body,
    is_anonymous = excluded.is_anonymous;
$$;

create or replace function public.get_teacher_profile(
  p_organization_id text, p_teacher_name text
)
returns jsonb language sql stable security definer set search_path = ''
as $$
  select app_api_v1.get_teacher_profile(p_organization_id, p_teacher_name);
$$;

create or replace function public.upsert_teacher_review(
  p_organization_id text, p_teacher_name text, p_clarity integer,
  p_loyalty integer, p_usefulness integer, p_body text default '',
  p_is_anonymous boolean default false
)
returns void language sql security invoker set search_path = ''
as $$
  select app_api_v1.upsert_teacher_review(
    p_organization_id, p_teacher_name, p_clarity, p_loyalty,
    p_usefulness, p_body, p_is_anonymous
  );
$$;

revoke all on function public.get_teacher_profile(text, text)
  from public, anon;
revoke all on function public.upsert_teacher_review(
  text, text, integer, integer, integer, text, boolean
) from public, anon;

grant execute on function public.get_teacher_profile(text, text)
  to authenticated;
grant execute on function public.upsert_teacher_review(
  text, text, integer, integer, integer, text, boolean
) to authenticated;
