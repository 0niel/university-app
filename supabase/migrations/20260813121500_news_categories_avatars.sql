-- Exposes source avatars and subscriber counts (collected by the telegram
-- sync connector into news_sources.metadata) through get_news_categories so
-- the feed can render a channel rail and richer category tabs.

create or replace function app_api_v1.get_news_categories(
  p_organization_id text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'sourceType', s.source_type,
        'sourceId', s.source_external_id,
        'sourceName', s.source_name,
        'sourceUrl', s.source_url,
        'avatarUrl', s.metadata ->> 'avatar_url',
        'subscribers', s.metadata ->> 'subscribers'
      )
      order by s.source_type, s.source_name
    ),
    '[]'::jsonb
  )
  from core.news_sources s
  where s.organization_id = p_organization_id and s.is_active;
$$;

revoke all on function app_api_v1.get_news_categories(text)
  from public, anon;
grant execute on function app_api_v1.get_news_categories(text)
  to authenticated, service_role;
