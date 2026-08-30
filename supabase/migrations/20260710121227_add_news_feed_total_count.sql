create or replace function app_api_v1.get_news_feed(
  p_organization_id text,
  p_category text default '',
  p_limit integer default 20,
  p_offset integer default 0
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
        'id', n.id,
        'title', n.title,
        'originalUrl', n.original_url,
        'newsBlocks', n.news_blocks,
        'sourceType', n.source_type,
        'sourceId', n.source_external_id,
        'sourceName', n.source_name,
        'publishedAt', n.published_at,
        'totalCount', n.total_count
      )
      order by n.published_at desc, n.id desc
    ),
    '[]'::jsonb
  )
  from (
    select i.*, count(*) over () as total_count
    from core.news_items i
    join core.news_sources s
      on s.id = i.source_id
      and s.organization_id = i.organization_id
      and s.is_active
    where i.organization_id = p_organization_id
      and (
        i.source_type <> 'telegram_stories'
        or nullif(i.metadata ->> 'expires_at', '')::timestamptz > now()
      )
      and (
        p_category is null
        or p_category in ('', 'all')
        or (
          p_category like 'source:%'
          and i.source_type = split_part(p_category, ':', 2)
          and i.source_external_id
                = substring(p_category from '^source:[^:]+:(.*)$')
        )
        or (p_category not like 'source:%' and i.source_type = p_category)
      )
    order by i.published_at desc, i.id desc
    limit least(greatest(coalesce(p_limit, 20), 1), 100)
    offset greatest(coalesce(p_offset, 0), 0)
  ) n;
$$;

revoke all on function app_api_v1.get_news_feed(text, text, integer, integer)
  from public, anon;
grant execute on function
  app_api_v1.get_news_feed(text, text, integer, integer) to authenticated;
