create or replace function app_api_v1.get_news_article(
  p_id uuid,
  p_organization_id text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'id', i.id,
    'title', i.title,
    'originalUrl', i.original_url,
    'newsBlocks', i.news_blocks,
    'sourceType', i.source_type,
    'sourceId', i.source_external_id,
    'sourceName', i.source_name,
    'publishedAt', i.published_at
  )
  from core.news_items i
  join core.news_sources s
    on s.id = i.source_id
    and s.organization_id = i.organization_id
    and s.is_active
  where i.id = p_id
    and i.organization_id = p_organization_id
    and (
      i.source_type <> 'telegram_stories'
      or nullif(i.metadata ->> 'expires_at', '')::timestamptz > now()
    );
$$;

create or replace function public.get_news_article(
  p_id uuid,
  p_organization_id text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_news_article(p_id, p_organization_id);
$$;

revoke all on function app_api_v1.get_news_article(uuid) from public;
revoke all on function public.get_news_article(uuid) from public, anon, authenticated;
revoke all on function app_api_v1.get_news_article(uuid, text) from public;
revoke all on function public.get_news_article(uuid, text) from public, anon;

grant execute on function public.get_news_article(uuid, text) to authenticated;
