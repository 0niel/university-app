alter table core.group_posts
drop constraint if exists group_posts_title_not_empty;

alter table core.group_posts
add constraint group_posts_title_or_body_not_empty
check (length(trim(title)) > 0 or length(trim(body)) > 0);

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
  v_title := core.validate_text(p_title, 'Title', 200, false);
  v_body := core.validate_text(p_body, 'Body', 8000, false);
  if v_title = '' and v_body = '' then
    raise exception 'Post needs a title or a body' using errcode = '22023';
  end if;

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
