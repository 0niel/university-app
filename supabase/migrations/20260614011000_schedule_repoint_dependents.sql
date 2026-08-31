-- Repoint the two live RPCs that still read legacy schedule storage onto the
-- canonical core.schedule_item model, so they reflect fresh data AND the legacy
-- tables can be dropped. (get_free_rooms read schedule_occurrences; the teacher
-- profile's "subjects" read schedule_parts.)

create or replace function app_api_v1.get_free_rooms(p_organization_id text)
returns jsonb language sql stable security definer set search_path to '' as $function$
  with org as (
    select coalesce(o.timezone, 'Europe/Moscow') as tz
    from core.organizations o
    where o.id = p_organization_id
  ),
  today as (
    select (now() at time zone (select tz from org))::date as d
  ),
  busy as (
    select ic.classroom_id, lower(o.span) as starts_at, upper(o.span) as ends_at
    from core.schedule_item_occurrence o
    join core.schedule_item_classroom ic on ic.item_id = o.item_id
    where o.lesson_date = (select d from today)
      and o.span is not null
  ),
  rooms as (
    select
      c.id,
      c.name,
      cam.short_name as campus,
      exists (
        select 1 from busy b
        where b.classroom_id = c.id
          and b.starts_at <= now()
          and b.ends_at > now()
      ) as occupied_now,
      (
        select min(b.starts_at) from busy b
        where b.classroom_id = c.id and b.starts_at > now()
      ) as next_busy_at
    from core.schedule_classrooms c
    left join core.schedule_campuses cam on cam.id = c.campus_id
    where c.organization_id = p_organization_id
      and c.name !~* 'online|дистан|сдо'
  )
  select coalesce(
    jsonb_agg(
      jsonb_build_object('room', r.name, 'campus', r.campus, 'freeUntil', r.next_busy_at)
      order by r.name
    ),
    '[]'::jsonb
  )
  from rooms r
  where not r.occupied_now;
$function$;

create or replace function app_api_v1.get_teacher_profile(p_organization_id text, p_teacher_name text)
returns jsonb language sql stable security definer set search_path to '' as $function$
  select jsonb_build_object(
    'teacherName', p_teacher_name,
    'reviewsCount', (
      select count(*) from core.teacher_reviews r
      where r.organization_id = p_organization_id and r.teacher_name = p_teacher_name
    ),
    'clarity', (
      select round(avg(r.clarity)::numeric, 1) from core.teacher_reviews r
      where r.organization_id = p_organization_id and r.teacher_name = p_teacher_name
    ),
    'loyalty', (
      select round(avg(r.loyalty)::numeric, 1) from core.teacher_reviews r
      where r.organization_id = p_organization_id and r.teacher_name = p_teacher_name
    ),
    'usefulness', (
      select round(avg(r.usefulness)::numeric, 1) from core.teacher_reviews r
      where r.organization_id = p_organization_id and r.teacher_name = p_teacher_name
    ),
    'subjects', (
      select coalesce(jsonb_agg(distinct d.name), '[]'::jsonb)
      from core.schedule_teachers t
      join core.schedule_item_teacher it on it.teacher_id = t.id
      join core.schedule_item si on si.id = it.item_id
      join core.schedule_disciplines d on d.id = si.discipline_id
      where t.organization_id = p_organization_id and t.full_name = p_teacher_name
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
        where organization_id = p_organization_id and teacher_name = p_teacher_name
        order by created_at desc
        limit 50
      ) r
    )
  );
$function$;
