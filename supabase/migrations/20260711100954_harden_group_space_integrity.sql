create or replace function core.is_study_group_member(
  p_group_id uuid,
  p_user_id uuid
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select p_user_id = (select auth.uid()) and exists (
    select 1
    from core.study_group_members membership
    where membership.group_id = p_group_id
      and membership.user_id = p_user_id
  );
$$;

revoke all on function core.is_study_group_member(uuid, uuid)
from public, anon;
grant execute on function core.is_study_group_member(uuid, uuid)
to authenticated, service_role;

drop policy if exists "likes readable by groupmates"
on core.group_post_likes;
drop policy if exists "users like group posts"
on core.group_post_likes;
drop policy if exists "users unlike own likes"
on core.group_post_likes;

create policy "study group members read likes"
on core.group_post_likes for select to authenticated
using (
  exists (
    select 1
    from core.group_posts post
    where post.id = group_post_likes.post_id
      and (
        (
          post.group_id is not null
          and core.is_study_group_member(
            post.group_id,
            (select auth.uid())
          )
        )
        or (
          post.group_id is null
          and post.academic_group = core.current_academic_group()
        )
      )
  )
);

create policy "study group members create likes"
on core.group_post_likes for insert to authenticated
with check (
  user_id = (select auth.uid())
  and exists (
    select 1
    from core.group_posts post
    where post.id = group_post_likes.post_id
      and (
        (
          post.group_id is not null
          and core.is_study_group_member(
            post.group_id,
            (select auth.uid())
          )
        )
        or (
          post.group_id is null
          and post.academic_group = core.current_academic_group()
        )
      )
  )
);

create policy "users remove own likes"
on core.group_post_likes for delete to authenticated
using (user_id = (select auth.uid()));

update core.group_links link
set group_id = study_group.id,
    academic_group = null
from core.study_group_members membership
join core.study_groups study_group
  on study_group.id = membership.group_id
join core.user_academic_profiles profile
  on profile.user_id = membership.user_id
where link.group_id is null
  and membership.user_id = link.created_by
  and study_group.organization_id = link.organization_id
  and profile.organization_id = link.organization_id
  and profile.academic_group = link.academic_group
  and (
    link.kind <> 'telegram'
    or study_group.owner_id = link.created_by
  );

delete from core.group_links
where group_id is null
  and kind = 'telegram';

with ranked as (
  select
    id,
    row_number() over (
      partition by group_id
      order by created_at desc, id desc
    ) as position
  from core.group_posts
  where group_id is not null
    and kind = 'announcement'
)
delete from core.group_posts post
using ranked
where post.id = ranked.id
  and ranked.position > 1;

create unique index if not exists group_posts_one_announcement_idx
on core.group_posts (group_id)
where group_id is not null
  and kind = 'announcement';

with ranked as (
  select
    id,
    row_number() over (
      partition by group_id
      order by created_at desc, id desc
    ) as position
  from core.group_links
  where group_id is not null
    and kind = 'telegram'
)
delete from core.group_links link
using ranked
where link.id = ranked.id
  and ranked.position > 1;

create unique index if not exists group_links_one_telegram_idx
on core.group_links (group_id)
where group_id is not null
  and kind = 'telegram';

create or replace function app_api_v1.create_group_post(
  p_organization_id text,
  p_title text,
  p_body text default '',
  p_kind text default 'note',
  p_pinned boolean default false
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid := core.current_study_group_id();
  v_is_owner boolean;
  v_group_organization_id text;
  v_kind text := lower(btrim(coalesce(p_kind, '')));
  v_title text;
  v_body text;
  v_id uuid;
begin
  if v_user_id is null or v_group_id is null then
    raise exception 'Unauthorized or not in a group' using errcode = '42501';
  end if;

  select study_group.owner_id = v_user_id, study_group.organization_id
  into v_is_owner, v_group_organization_id
  from core.study_groups study_group
  where study_group.id = v_group_id;

  if v_group_organization_id is distinct from p_organization_id then
    raise exception 'Group does not belong to this organization'
      using errcode = '42501';
  end if;

  if not coalesce(v_is_owner, false)
    and (v_kind = 'announcement' or coalesce(p_pinned, false)) then
    raise exception 'Only the group owner can publish pinned content'
      using errcode = '42501';
  end if;
  if v_kind not in ('note', 'announcement') then
    raise exception 'Unsupported group post kind' using errcode = '22023';
  end if;

  perform core.enforce_rate_limit('create_group_post', 20, interval '1 hour');
  v_title := core.validate_text(p_title, 'Title', 200, true);
  v_body := core.validate_text(p_body, 'Body', 8000, false);

  if v_kind = 'announcement' then
    insert into core.group_posts (
      organization_id,
      group_id,
      author_id,
      kind,
      title,
      body,
      is_pinned
    )
    values (
      p_organization_id,
      v_group_id,
      v_user_id,
      v_kind,
      v_title,
      v_body,
      true
    )
    on conflict (group_id) where group_id is not null
      and kind = 'announcement'
    do update set
      organization_id = excluded.organization_id,
      author_id = excluded.author_id,
      title = excluded.title,
      body = excluded.body,
      is_pinned = true,
      created_at = now()
    returning id into v_id;
  else
    insert into core.group_posts (
      organization_id,
      group_id,
      author_id,
      kind,
      title,
      body,
      is_pinned
    )
    values (
      p_organization_id,
      v_group_id,
      v_user_id,
      v_kind,
      v_title,
      v_body,
      coalesce(p_pinned, false)
    )
    returning id into v_id;
  end if;

  return v_id;
end;
$$;

create or replace function app_api_v1.add_group_link(
  p_organization_id text,
  p_title text,
  p_url text,
  p_emoji text default '🔗',
  p_kind text default 'link'
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid := core.current_study_group_id();
  v_is_owner boolean;
  v_group_organization_id text;
  v_kind text := lower(btrim(coalesce(p_kind, '')));
  v_url text := core.validate_text(p_url, 'URL', 2000, true);
  v_title text := core.validate_text(p_title, 'Title', 200, true);
  v_id uuid;
begin
  if v_user_id is null or v_group_id is null then
    raise exception 'Unauthorized or not in a group' using errcode = '42501';
  end if;

  select study_group.owner_id = v_user_id, study_group.organization_id
  into v_is_owner, v_group_organization_id
  from core.study_groups study_group
  where study_group.id = v_group_id;

  if v_group_organization_id is distinct from p_organization_id then
    raise exception 'Group does not belong to this organization'
      using errcode = '42501';
  end if;

  if v_kind not in ('link', 'telegram') then
    raise exception 'Unsupported group link kind' using errcode = '22023';
  end if;
  if v_url !~* '^https://[a-z0-9][a-z0-9.-]*(:[0-9]{1,5})?'
      '([/?#][^[:space:][:cntrl:]]*)?$' then
    raise exception 'Only valid HTTPS links are allowed' using errcode = '22023';
  end if;
  if v_kind = 'telegram'
    and v_url !~* '^https://(t[.]me|telegram[.]me)/'
      '[a-z0-9_+/-]+([?#][^[:space:][:cntrl:]]*)?$' then
    raise exception 'Invalid Telegram link' using errcode = '22023';
  end if;
  if v_kind = 'telegram' and not coalesce(v_is_owner, false) then
    raise exception 'Only the group owner can set the Telegram link'
      using errcode = '42501';
  end if;

  perform core.enforce_rate_limit('add_group_link', 30, interval '1 hour');

  if v_kind = 'telegram' then
    insert into core.group_links (
      organization_id,
      group_id,
      kind,
      emoji,
      title,
      url,
      created_by
    )
    values (
      p_organization_id,
      v_group_id,
      v_kind,
      left(coalesce(p_emoji, '✈️'), 16),
      v_title,
      v_url,
      v_user_id
    )
    on conflict (group_id) where group_id is not null
      and kind = 'telegram'
    do update set
      organization_id = excluded.organization_id,
      emoji = excluded.emoji,
      title = excluded.title,
      url = excluded.url,
      created_by = excluded.created_by,
      created_at = now()
    returning id into v_id;
  else
    insert into core.group_links (
      organization_id,
      group_id,
      kind,
      emoji,
      title,
      url,
      created_by
    )
    values (
      p_organization_id,
      v_group_id,
      v_kind,
      left(coalesce(p_emoji, '🔗'), 16),
      v_title,
      v_url,
      v_user_id
    )
    returning id into v_id;
  end if;

  return v_id;
end;
$$;

create or replace function app_api_v1.delete_group_link(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_group_id uuid;
  v_created_by uuid;
  v_is_owner boolean;
  v_organization_id text;
  v_academic_group text;
  v_current_organization_id text;
  v_current_academic_group text;
  v_current_group_id uuid;
  v_is_current_group_owner boolean := false;
begin
  if v_user_id is null then
    raise exception 'Unauthorized' using errcode = '42501';
  end if;

  select
    link.group_id,
    link.created_by,
    link.organization_id,
    link.academic_group
  into
    v_group_id,
    v_created_by,
    v_organization_id,
    v_academic_group
  from core.group_links link
  where link.id = p_id;

  if not found then
    raise exception 'Group link not found' using errcode = '42501';
  end if;

  if v_group_id is null then
    select profile.organization_id, profile.academic_group
    into v_current_organization_id, v_current_academic_group
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id;

    v_current_group_id := core.current_study_group_id();
    if v_current_group_id is not null then
      select study_group.owner_id = v_user_id
      into v_is_current_group_owner
      from core.study_groups study_group
      where study_group.id = v_current_group_id;
    end if;

    if (
      v_created_by <> v_user_id
      and not coalesce(v_is_current_group_owner, false)
    )
      or v_organization_id is distinct from v_current_organization_id
      or v_academic_group is distinct from v_current_academic_group then
      raise exception 'Group link not found' using errcode = '42501';
    end if;

    delete from core.group_links where id = p_id;
    return;
  end if;

  if not core.is_study_group_member(v_group_id, v_user_id) then
    raise exception 'Group link not found' using errcode = '42501';
  end if;

  select study_group.owner_id = v_user_id
  into v_is_owner
  from core.study_groups study_group
  where study_group.id = v_group_id;

  if v_created_by <> v_user_id and not coalesce(v_is_owner, false) then
    raise exception 'Only the author or group owner can delete this link'
      using errcode = '42501';
  end if;

  delete from core.group_links where id = p_id;
end;
$$;

revoke all on function app_api_v1.create_group_post(
  text,
  text,
  text,
  text,
  boolean
) from public, anon;
grant execute on function app_api_v1.create_group_post(
  text,
  text,
  text,
  text,
  boolean
) to authenticated, service_role;

revoke all on function app_api_v1.add_group_link(
  text,
  text,
  text,
  text,
  text
) from public, anon;
grant execute on function app_api_v1.add_group_link(
  text,
  text,
  text,
  text,
  text
) to authenticated, service_role;

revoke all on function app_api_v1.delete_group_link(uuid)
from public, anon;
grant execute on function app_api_v1.delete_group_link(uuid)
to authenticated, service_role;
