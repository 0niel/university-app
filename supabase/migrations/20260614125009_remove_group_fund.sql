-- Remove the shared group fund (общая касса) feature.
--
-- Drops the fund tables, RPCs and the `fund` key from get_group_space. The
-- remaining group-space mechanics (links, posts+likes, notes, birthdays) are
-- untouched. get_group_space is `language sql`, so it has a hard dependency on
-- core.group_funds — it must be recreated without the fund branch BEFORE the
-- table is dropped.

-- ── get_group_space without the fund branch ──────────────────────────────────
create or replace function app_api_v1.get_group_space(p_organization_id text)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with me as (
    select
      (select auth.uid()) as user_id,
      core.current_academic_group() as academic_group
  ),
  members as (
    select p.user_id, p.full_name, p.birth_date
    from core.user_academic_profiles p, me
    where p.academic_group = me.academic_group
      and me.academic_group is not null
  )
  select jsonb_build_object(
    'group', (select academic_group from me),
    'memberCount', (select count(*) from members),
    'memberNames', (
      select coalesce(jsonb_agg(full_name), '[]'::jsonb)
      from (select full_name from members limit 5) m
    ),
    'links', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', l.id,
            'kind', l.kind,
            'emoji', l.emoji,
            'title', l.title,
            'url', l.url,
            'addedBy', coalesce(
              (select split_part(m.full_name, ' ', 1)
               from members m where m.user_id = l.created_by),
              'аноним'
            ),
            'isMine', l.created_by = (select user_id from me)
          )
          order by l.created_at
        ),
        '[]'::jsonb
      )
      from core.group_links l, me
      where l.academic_group = me.academic_group
    ),
    'announcement', (
      select jsonb_build_object(
        'id', p.id,
        'title', p.title,
        'body', p.body,
        'authorName', coalesce(
          (select split_part(m.full_name, ' ', 1)
           from members m where m.user_id = p.author_id),
          'аноним'
        ),
        'createdAt', p.created_at,
        'isMine', p.author_id = (select user_id from me)
      )
      from core.group_posts p, me
      where p.academic_group = me.academic_group
        and p.kind = 'announcement'
      order by p.created_at desc
      limit 1
    ),
    'notes', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'id', p.id,
            'title', p.title,
            'body', p.body,
            'authorName', coalesce(
              (select split_part(m.full_name, ' ', 1)
               from members m where m.user_id = p.author_id),
              'аноним'
            ),
            'createdAt', p.created_at,
            'isPinned', p.is_pinned,
            'isMine', p.author_id = (select user_id from me),
            'likes', (
              select count(*) from core.group_post_likes gl
              where gl.post_id = p.id
            ),
            'likedByMe', exists (
              select 1 from core.group_post_likes gl
              where gl.post_id = p.id
                and gl.user_id = (select user_id from me)
            )
          )
          order by p.is_pinned desc, p.created_at desc
        ),
        '[]'::jsonb
      )
      from core.group_posts p, me
      where p.academic_group = me.academic_group and p.kind = 'note'
    ),
    'birthdays', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'name', b.full_name,
            'date', b.next_birthday,
            'isMe', b.user_id = (select user_id from me)
          )
          order by b.next_birthday
        ),
        '[]'::jsonb
      )
      from (
        select
          m.user_id,
          m.full_name,
          (m.birth_date + make_interval(
            years => extract(year from age(now(), m.birth_date))::int
              + case
                  when (m.birth_date + make_interval(
                    years => extract(
                      year from age(now(), m.birth_date)
                    )::int
                  ))::date < current_date then 1
                  else 0
                end
          ))::date as next_birthday
        from members m
        where m.birth_date is not null
      ) b
      where b.next_birthday <= current_date + 60
    )
  );
$$;

-- ── Drop fund RPCs (public wrappers first, then the app_api_v1 impls) ─────────
drop function if exists public.create_group_fund(text, text, integer);
drop function if exists public.contribute_to_fund(uuid, integer);
drop function if exists app_api_v1.create_group_fund(text, text, integer);
drop function if exists app_api_v1.contribute_to_fund(uuid, integer);

-- ── Drop fund tables (contributions FK-reference funds, so drop them first) ───
drop table if exists core.group_fund_contributions;
drop table if exists core.group_funds;
