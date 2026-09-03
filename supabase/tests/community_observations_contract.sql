begin;

do $$
declare
  v_section uuid;
  v_id uuid;
  v_item jsonb;
  v_count integer;
  v_active boolean;
  v_invalid_logo text;
begin
  if has_function_privilege('anon', 'public.get_community_sync_targets(text)', 'EXECUTE')
    or has_function_privilege('authenticated', 'public.apply_community_observations(text,jsonb)', 'EXECUTE')
    or has_function_privilege('authenticated', 'app_api_v1.apply_community_observations(text,jsonb)', 'EXECUTE') then
    raise exception 'Community metadata writes must remain service-only';
  end if;
  insert into core.organizations(id, name) values ('observation-test', 'Observation test');
  insert into core.organization_community_sections(organization_id, key, title)
  values ('observation-test', 'general', 'General') returning id into v_section;
  insert into core.organization_communities(organization_id, section_id, slug, title, destination_url, platform)
  values ('observation-test', v_section, 'news', 'News', 'https://t.me/example_news', 'telegram')
  returning id into v_id;
  v_item := jsonb_build_object('id', v_id, 'url', 'https://t.me/example_news',
    'status', 'verified', 'checked_at', now(), 'http_status', 200,
    'member_count', 114, 'title', 'Real title', 'evidence', '114 subscribers');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select member_count into v_count from core.organization_communities where id = v_id;
  if v_count <> 114 then raise exception 'Verified member count was not applied'; end if;
  foreach v_invalid_logo in array array['http://cdn.example/avatar.jpg', 'javascript:alert(1)', 'data:image/png;base64,abc']
  loop
    begin
      perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item || jsonb_build_object('logo_url', v_invalid_logo)));
      raise exception 'A non-HTTPS logo URL was accepted';
    exception when invalid_parameter_value then null;
    end;
  end loop;
  v_item := v_item || jsonb_build_object('status', 'unavailable', 'http_status', 429, 'member_count', null, 'evidence', 'HTTP 429');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select member_count, is_active into v_count, v_active from core.organization_communities where id = v_id;
  if v_count <> 114 or not v_active then raise exception 'Transient failure damaged real metadata'; end if;
  begin
    perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item || '{"status":"not_found"}'::jsonb));
    raise exception 'A 429 incorrectly qualified as deletion';
  exception when invalid_parameter_value then null;
  end;
  begin
    perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item || '{"status":"not_found","http_status":null}'::jsonb));
    raise exception 'Missing HTTP evidence incorrectly qualified as deletion';
  exception when invalid_parameter_value then null;
  end;
  begin
    perform app_api_v1.apply_community_observations('another-tenant', jsonb_build_array(v_item));
    raise exception 'Cross-tenant observation was accepted';
  exception when invalid_parameter_value then null;
  end;
  v_item := v_item || jsonb_build_object('status', 'not_found', 'http_status', 404, 'evidence', 'HTTP 404');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select is_active into v_active from core.organization_communities where id = v_id;
  if v_active then raise exception 'Confirmed missing community remained active'; end if;
  v_item := v_item || jsonb_build_object('status', 'unavailable', 'http_status', 429, 'evidence', 'HTTP 429');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  v_item := v_item || jsonb_build_object('status', 'verified', 'http_status', 200, 'evidence', 'Public metadata');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select is_active into v_active from core.organization_communities where id = v_id;
  if not v_active then raise exception 'Recovered community was not restored after a transient failure'; end if;
  update core.organization_communities set is_active = false where id = v_id;
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select is_active into v_active from core.organization_communities where id = v_id;
  if v_active then raise exception 'Manually hidden community was reactivated'; end if;
  v_item := v_item || jsonb_build_object('member_count', 1, 'checked_at', now() - interval '1 hour');
  perform app_api_v1.apply_community_observations('observation-test', jsonb_build_array(v_item));
  select member_count into v_count from core.organization_communities where id = v_id;
  if v_count <> 114 then raise exception 'Stale metadata overwrote the verified count'; end if;
end;
$$;

rollback;
