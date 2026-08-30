-- Client-facing news RPCs replacing the Serverpod news endpoint.
-- News content is org-public; tables are service-managed, so reads are
-- security definer. Applied remotely as: add_news_rpcs.

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
        'publishedAt', n.published_at
      )
      order by n.published_at desc
    ),
    '[]'::jsonb
  )
  from (
    select *
    from core.news_items i
    where i.organization_id = p_organization_id
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
    order by i.published_at desc
    limit least(coalesce(p_limit, 20), 100)
    offset greatest(coalesce(p_offset, 0), 0)
  ) n;
$$;

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
        'sourceName', s.source_name
      )
      order by s.source_type, s.source_name
    ),
    '[]'::jsonb
  )
  from core.news_sources s
  where s.organization_id = p_organization_id and s.is_active;
$$;

create or replace function app_api_v1.get_news_article(p_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'id', n.id,
    'title', n.title,
    'originalUrl', n.original_url,
    'newsBlocks', n.news_blocks,
    'sourceType', n.source_type,
    'sourceId', n.source_external_id,
    'sourceName', n.source_name,
    'publishedAt', n.published_at
  )
  from core.news_items n
  where n.id = p_id;
$$;

-- public wrappers
create or replace function public.get_news_feed(
  p_organization_id text, p_category text default '',
  p_limit integer default 20, p_offset integer default 0
)
returns jsonb language sql stable security definer set search_path = ''
as $$
  select app_api_v1.get_news_feed(
    p_organization_id, p_category, p_limit, p_offset
  );
$$;

create or replace function public.get_news_categories(
  p_organization_id text
)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_news_categories(p_organization_id); $$;

create or replace function public.get_news_article(p_id uuid)
returns jsonb language sql stable security definer set search_path = ''
as $$ select app_api_v1.get_news_article(p_id); $$;

revoke all on function public.get_news_feed(text, text, integer, integer)
  from public, anon;
revoke all on function public.get_news_categories(text) from public, anon;
revoke all on function public.get_news_article(uuid) from public, anon;

grant execute on function
  public.get_news_feed(text, text, integer, integer) to authenticated;
grant execute on function public.get_news_categories(text)
  to authenticated;
grant execute on function public.get_news_article(uuid) to authenticated;
