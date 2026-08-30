-- Add rate limits + input validation to community content RPCs.
-- Signatures unchanged; only guards added.

create or replace function app_api_v1.create_group_post(
  p_organization_id text, p_title text, p_body text default ''::text,
  p_kind text default 'note'::text, p_pinned boolean default false)
  returns uuid language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_group uuid := core.current_study_group_id();
  v_id uuid;
  v_title text;
  v_body text;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or not in a group';
  end if;
  perform core.enforce_rate_limit('create_group_post', 20, interval '1 hour');
  v_title := core.validate_text(p_title, 'Заголовок', 200, true);
  v_body  := core.validate_text(p_body, 'Текст', 8000, false);
  if p_kind = 'announcement'
     and not exists (select 1 from core.study_groups
                     where id = v_group and owner_id = v_user_id) then
    raise exception 'Only the group owner can post announcements';
  end if;
  insert into core.group_posts (organization_id, group_id, author_id, kind, title, body, is_pinned)
  values (p_organization_id, v_group, v_user_id,
          core.validate_text(p_kind, 'Тип', 40, false), v_title, v_body,
          coalesce(p_pinned, false))
  returning id into v_id;
  return v_id;
end;
$function$;

create or replace function app_api_v1.create_group_note(
  p_organization_id text, p_title text, p_visibility text default 'group'::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_group uuid := core.current_study_group_id();
  v_vis text := coalesce(p_visibility, 'group');
  v_id uuid;
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('create_group_note', 30, interval '1 hour');
  if v_vis not in ('group', 'personal') then v_vis := 'group'; end if;
  if v_vis = 'group' and v_group is null then
    raise exception 'Not in a group';
  end if;
  insert into core.group_notes
    (organization_id, group_id, owner_id, visibility, title, created_by, updated_by)
  values (p_organization_id,
          case when v_vis = 'group' then v_group else null end,
          v_user_id, v_vis, core.validate_text(p_title, 'Название', 200, true),
          v_user_id, v_user_id)
  returning id into v_id;
  return v_id;
end;
$function$;

-- Was a bare SQL UPDATE with no auth check (relied solely on RLS). Now an
-- explicit auth gate, rate limit, and length caps; RLS still scopes ownership.
create or replace function app_api_v1.save_group_note(
  p_id uuid, p_title text, p_content text)
  returns void language plpgsql set search_path to ''
as $function$
declare v_user_id uuid := (select auth.uid());
begin
  if v_user_id is null then raise exception 'Unauthorized'; end if;
  perform core.enforce_rate_limit('save_group_note', 120, interval '1 hour');
  update core.group_notes
  set title = core.validate_text(p_title, 'Название', 200, true),
      content = core.validate_text(p_content, 'Содержимое', 20000, false),
      updated_by = v_user_id,
      updated_at = now()
  where id = p_id;
end;
$function$;

create or replace function app_api_v1.add_group_link(
  p_organization_id text, p_title text, p_url text,
  p_emoji text default '🔗'::text, p_kind text default 'link'::text)
  returns uuid language plpgsql set search_path to ''
as $function$
declare
  v_user_id uuid := (select auth.uid());
  v_group uuid := core.current_study_group_id();
  v_id uuid;
  v_url text;
begin
  if v_user_id is null or v_group is null then
    raise exception 'Unauthorized or not in a group';
  end if;
  perform core.enforce_rate_limit('add_group_link', 30, interval '1 hour');
  v_url := core.validate_text(p_url, 'Ссылка', 2000, true);
  if v_url !~* '^https?://' then
    raise exception 'Ссылка должна начинаться с http:// или https://'
      using errcode = '22023';
  end if;
  insert into core.group_links (organization_id, group_id, kind, emoji, title, url, created_by)
  values (p_organization_id, v_group,
          core.validate_text(p_kind, 'Тип', 40, false),
          left(coalesce(p_emoji, '🔗'), 16),
          core.validate_text(p_title, 'Название', 200, true), v_url, v_user_id)
  returning id into v_id;
  return v_id;
end;
$function$;

-- Bound query length and neutralize LIKE wildcards in user input.
create or replace function app_api_v1.search_group_posts(p_query text)
  returns jsonb language plpgsql stable security definer set search_path to ''
as $function$
declare
  v_q text := btrim(coalesce(p_query, ''));
  v_pat text;
begin
  if char_length(v_q) < 2 then return '[]'::jsonb; end if;
  v_q := left(v_q, 100);
  v_pat := '%' ||
    replace(replace(replace(v_q, '\', '\\'), '%', '\%'), '_', '\_') || '%';
  return (
    select coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', gp.id, 'title', gp.title, 'body', gp.body, 'kind', gp.kind,
          'isPinned', gp.is_pinned, 'createdAt', gp.created_at,
          'authorName', uap.full_name)
        order by gp.is_pinned desc, gp.created_at desc),
      '[]'::jsonb)
    from core.group_posts gp
    left join core.user_academic_profiles uap on uap.user_id = gp.author_id
    where gp.academic_group = core.current_academic_group()
      and (gp.title ilike v_pat escape '\' or gp.body ilike v_pat escape '\')
    limit 20
  );
end;
$function$;
