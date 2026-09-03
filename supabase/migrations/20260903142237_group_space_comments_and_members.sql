create table if not exists core.group_post_comments (
  id uuid primary key default extensions.gen_random_uuid(),
  post_id uuid not null references core.group_posts(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now(),
  constraint group_post_comments_body_not_empty check (length(trim(body)) > 0)
);

create index if not exists group_post_comments_post_idx
on core.group_post_comments (post_id, created_at);

alter table core.group_post_comments enable row level security;

drop policy if exists "group post comments readable by members"
on core.group_post_comments;
create policy "group post comments readable by members"
on core.group_post_comments for select to authenticated
using (
  exists (
    select 1
    from core.group_posts post
    where post.id = group_post_comments.post_id
      and post.group_id = core.current_study_group_id()
  )
);

drop policy if exists "members insert comments"
on core.group_post_comments;
create policy "members insert comments"
on core.group_post_comments for insert to authenticated
with check (
  author_id = (select auth.uid())
  and exists (
    select 1
    from core.group_posts post
    where post.id = group_post_comments.post_id
      and post.group_id = core.current_study_group_id()
  )
);

drop policy if exists "authors and owners delete comments"
on core.group_post_comments;
create policy "authors and owners delete comments"
on core.group_post_comments for delete to authenticated
using (
  author_id = (select auth.uid())
  or exists (
    select 1
    from core.group_posts post
    join core.study_groups study_group on study_group.id = post.group_id
    where post.id = group_post_comments.post_id
      and study_group.owner_id = (select auth.uid())
  )
);

grant select, insert, delete on core.group_post_comments to authenticated;
grant all on core.group_post_comments to service_role;

alter table core.group_post_comments replica identity full;
alter table core.group_posts replica identity full;

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

  if v_group_id is null or v_group_id <> core.current_study_group_id() then
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

  if v_group_id is null or v_group_id <> core.current_study_group_id() then
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

  if v_group_id is null or v_group_id <> core.current_study_group_id() then
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

create or replace function public.get_group_post_comments(p_post_id uuid)
returns jsonb
language sql
stable
set search_path = ''
as $$ select app_api_v1.get_group_post_comments(p_post_id); $$;

create or replace function public.add_group_post_comment(
  p_post_id uuid,
  p_body text
)
returns jsonb
language sql
set search_path = ''
as $$ select app_api_v1.add_group_post_comment(p_post_id, p_body); $$;

create or replace function public.delete_group_post_comment(p_id uuid)
returns void
language sql
set search_path = ''
as $$ select app_api_v1.delete_group_post_comment(p_id); $$;

do $$
declare
  v_signature text;
  v_schema text;
begin
  foreach v_signature in array array[
    'get_group_post_comments(uuid)',
    'add_group_post_comment(uuid,text)',
    'delete_group_post_comment(uuid)'
  ] loop
    foreach v_schema in array array['public', 'app_api_v1'] loop
      execute format(
        'revoke all on function %I.%s from public, anon',
        v_schema, v_signature
      );
      execute format(
        'grant execute on function %I.%s to authenticated, service_role',
        v_schema, v_signature
      );
    end loop;
  end loop;
end;
$$;

create or replace function app_api_v1.transfer_study_group_ownership(
  p_user_id uuid
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid := core.current_study_group_id();
  v_organization_id text;
begin
  if v_user_id is null or v_group_id is null then
    raise exception 'Unauthorized or not in a group' using errcode = '42501';
  end if;
  if p_user_id = v_user_id then
    raise exception 'Already the owner' using errcode = '22023';
  end if;

  select study_group.organization_id into v_organization_id
  from core.study_groups study_group
  where study_group.id = v_group_id
    and study_group.owner_id = v_user_id
  for update;

  if v_organization_id is null then
    raise exception 'Only the owner can transfer ownership'
      using errcode = '42501';
  end if;
  if not exists (
    select 1 from core.study_group_members membership
    where membership.group_id = v_group_id
      and membership.user_id = p_user_id
  ) then
    raise exception 'Target user is not a member of this group'
      using errcode = '42501';
  end if;

  perform core.enforce_rate_limit(
    'transfer_study_group_ownership', 10, interval '1 day'
  );

  update core.study_groups
  set owner_id = p_user_id, updated_at = now()
  where id = v_group_id;

  update core.study_group_members
  set role = 'owner'
  where group_id = v_group_id and user_id = p_user_id;

  update core.study_group_members
  set role = 'member'
  where group_id = v_group_id and user_id = v_user_id;

  return app_api_v1.get_my_study_group(v_organization_id);
end;
$$;

create or replace function public.transfer_study_group_ownership(
  p_user_id uuid
)
returns jsonb
language sql
set search_path = ''
as $$ select app_api_v1.transfer_study_group_ownership(p_user_id); $$;

do $$
declare
  v_schema text;
begin
  foreach v_schema in array array['public', 'app_api_v1'] loop
    execute format(
      'revoke all on function %I.transfer_study_group_ownership(uuid) '
      'from public, anon',
      v_schema
    );
    execute format(
      'grant execute on function %I.transfer_study_group_ownership(uuid) '
      'to authenticated, service_role',
      v_schema
    );
  end loop;
end;
$$;

create or replace function app_api_v1.get_group_space(p_organization_id text)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_group_name text;
  v_group_emoji text;
  v_join_code text;
  v_is_owner boolean := false;
  v_academic_group text;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select p.academic_group
  into v_academic_group
  from core.user_academic_profiles p
  where p.user_id = v_user_id
    and p.organization_id = p_organization_id;

  if not found then
    raise exception 'User does not belong to this organization'
      using errcode = '42501';
  end if;

  select g.id, g.name, g.emoji, g.join_code, g.owner_id = v_user_id
  into v_group_id, v_group_name, v_group_emoji, v_join_code, v_is_owner
  from core.study_group_members membership
  join core.study_groups g on g.id = membership.group_id
  where membership.user_id = v_user_id
    and g.organization_id = p_organization_id;

  if v_group_id is null then
    return jsonb_build_object(
      'group', null,
      'groupId', null,
      'joinCode', null,
      'emoji', '🎓',
      'hasGroup', false,
      'isOwner', false,
      'memberCount', 0,
      'memberNames', '[]'::jsonb,
      'members', '[]'::jsonb,
      'links', '[]'::jsonb,
      'announcement', null,
      'notes', '[]'::jsonb,
      'birthdays', '[]'::jsonb,
      'myBirthdaySet', false
    );
  end if;

  return (
    with members as (
      select
        membership.user_id,
        membership.role,
        membership.joined_at,
        coalesce(profile.full_name, 'Студент') as full_name,
        profile.handle,
        profile.birth_date
      from core.study_group_members membership
      left join core.user_academic_profiles profile
        on profile.user_id = membership.user_id
      where membership.group_id = v_group_id
    )
    select jsonb_build_object(
      'group', v_group_name,
      'groupId', v_group_id,
      'joinCode', v_join_code,
      'emoji', v_group_emoji,
      'hasGroup', true,
      'isOwner', v_is_owner,
      'memberCount', (select count(*) from members),
      'memberNames', (
        select coalesce(jsonb_agg(member.full_name), '[]'::jsonb)
        from (
          select full_name
          from members
          order by (role = 'owner') desc, joined_at, user_id
          limit 5
        ) member
      ),
      'members', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'userId', member.user_id,
              'fullName', member.full_name,
              'handle', member.handle,
              'role', member.role,
              'isOwner', member.role = 'owner',
              'isMe', member.user_id = v_user_id
            )
            order by (member.role = 'owner') desc,
              member.full_name, member.user_id
          ),
          '[]'::jsonb
        )
        from members member
      ),
      'myBirthdaySet', exists (
        select 1 from members member
        where member.user_id = v_user_id and member.birth_date is not null
      ),
      'links', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'id', link.id,
              'kind', link.kind,
              'emoji', link.emoji,
              'title', link.title,
              'url', link.url,
              'addedBy', coalesce(
                (
                  select split_part(member.full_name, ' ', 1)
                  from members member
                  where member.user_id = link.created_by
                ),
                'аноним'
              ),
              'isMine', link.created_by = v_user_id
            )
            order by link.created_at
          ),
          '[]'::jsonb
        )
        from core.group_links link
        where link.organization_id = p_organization_id
          and (
            link.group_id = v_group_id
            or (
              link.group_id is null
              and link.academic_group = v_academic_group
            )
          )
      ),
      'announcement', (
        select jsonb_build_object(
          'id', post.id,
          'title', post.title,
          'body', post.body,
          'authorName', coalesce(
            (
              select split_part(member.full_name, ' ', 1)
              from members member
              where member.user_id = post.author_id
            ),
            'аноним'
          ),
          'createdAt', post.created_at,
          'isMine', post.author_id = v_user_id,
          'commentsCount', (
            select count(*)
            from core.group_post_comments comment
            where comment.post_id = post.id
          )
        )
        from core.group_posts post
        where post.organization_id = p_organization_id
          and post.kind = 'announcement'
          and (
            post.group_id = v_group_id
            or (
              post.group_id is null
              and post.academic_group = v_academic_group
            )
          )
        order by post.created_at desc
        limit 1
      ),
      'notes', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'id', post.id,
              'title', post.title,
              'body', post.body,
              'authorName', coalesce(
                (
                  select split_part(member.full_name, ' ', 1)
                  from members member
                  where member.user_id = post.author_id
                ),
                'аноним'
              ),
              'createdAt', post.created_at,
              'isPinned', post.is_pinned,
              'isMine', post.author_id = v_user_id,
              'likes', (
                select count(*)
                from core.group_post_likes reaction
                where reaction.post_id = post.id
              ),
              'likedByMe', exists (
                select 1
                from core.group_post_likes reaction
                where reaction.post_id = post.id
                  and reaction.user_id = v_user_id
              ),
              'commentsCount', (
                select count(*)
                from core.group_post_comments comment
                where comment.post_id = post.id
              )
            )
            order by post.is_pinned desc, post.created_at desc
          ),
          '[]'::jsonb
        )
        from core.group_posts post
        where post.organization_id = p_organization_id
          and post.kind = 'note'
          and (
            post.group_id = v_group_id
            or (
              post.group_id is null
              and post.academic_group = v_academic_group
            )
          )
      ),
      'birthdays', (
        select coalesce(
          jsonb_agg(
            jsonb_build_object(
              'name', birthday.full_name,
              'date', birthday.next_birthday,
              'isMe', birthday.user_id = v_user_id
            )
            order by birthday.next_birthday
          ),
          '[]'::jsonb
        )
        from (
          select
            member.user_id,
            member.full_name,
            (
              member.birth_date
              + make_interval(
                years => extract(
                  year from age(now(), member.birth_date)
                )::integer
                + case
                    when (
                      member.birth_date
                      + make_interval(
                        years => extract(
                          year from age(now(), member.birth_date)
                        )::integer
                      )
                    )::date < current_date then 1
                    else 0
                  end
              )
            )::date as next_birthday
          from members member
          where member.birth_date is not null
        ) birthday
        where birthday.next_birthday <= current_date + 60
      )
    )
  );
end;
$$;

do $$
declare
  v_table text;
begin
  foreach v_table in array array[
    'group_posts', 'group_post_likes', 'group_post_comments'
  ] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'core'
        and tablename = v_table
    ) then
      execute format(
        'alter publication supabase_realtime add table core.%I', v_table
      );
    end if;
  end loop;
end;
$$;
