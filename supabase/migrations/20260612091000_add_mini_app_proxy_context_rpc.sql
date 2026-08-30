-- One-round-trip helper for the miniapp-proxy edge function (service_role
-- only): registers a rate-limit hit, resolves the app by slug, checks the
-- caller's visibility (published / owner / moderator) and inlines the hosted
-- screen JSON when present.
-- Applied remotely as: add_mini_app_proxy_context_rpc.
create or replace function public.mini_app_proxy_context(
  p_user_id uuid,
  p_organization_id text,
  p_slug text,
  p_path text default null,
  p_rate_limit integer default 180
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_app core.mini_apps;
  v_screen jsonb;
  v_is_moderator boolean;
begin
  if not core.register_mini_app_proxy_hit(p_user_id, p_rate_limit) then
    return jsonb_build_object('allowed', false, 'reason', 'rate_limited');
  end if;

  select * into v_app
  from core.mini_apps a
  where a.organization_id = p_organization_id and a.slug = p_slug;
  if not found then
    return jsonb_build_object('allowed', false, 'reason', 'not_found');
  end if;

  select exists (
    select 1 from core.mini_app_moderators m
    where m.organization_id = p_organization_id and m.user_id = p_user_id
  ) into v_is_moderator;

  if v_app.status <> 'published'
    and v_app.owner_id <> p_user_id
    and not v_is_moderator
  then
    return jsonb_build_object('allowed', false, 'reason', 'not_published');
  end if;

  if v_app.source_kind = 'hosted' then
    select s.json into v_screen
    from core.mini_app_screens s
    where s.app_id = v_app.id
      and s.path = coalesce(p_path, v_app.entry_path);
  end if;

  return jsonb_build_object(
    'allowed', true,
    'app', jsonb_build_object(
      'id', v_app.id,
      'slug', v_app.slug,
      'name', v_app.name,
      'sourceKind', v_app.source_kind,
      'originUrl', v_app.origin_url,
      'entryPath', v_app.entry_path,
      'status', v_app.status
    ),
    'screen', v_screen
  );
end;
$$;

revoke all on function
  public.mini_app_proxy_context(uuid, text, text, text, integer)
  from public, anon, authenticated;
grant execute on function
  public.mini_app_proxy_context(uuid, text, text, text, integer)
  to service_role;
