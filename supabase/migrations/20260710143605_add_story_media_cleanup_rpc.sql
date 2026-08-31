create or replace function core.try_timestamptz(p_value text)
returns timestamptz
language plpgsql
stable
set search_path = ''
as $$
begin
  return nullif(trim(p_value), '')::timestamptz;
exception
  when others then
    return null;
end;
$$;

revoke all on function core.try_timestamptz(text) from public, anon, authenticated;

create or replace function public.list_expired_story_media(
  p_organization_id text,
  p_limit integer default 100
)
returns table (item_id uuid, media_path text)
language sql
stable
security definer
set search_path = ''
as $$
  with removable as (
    select i.id as item_id, i.metadata ->> 'media_path' as media_path
    from core.news_items i
    where i.organization_id = p_organization_id
      and i.source_type = 'telegram_stories'
      and i.metadata ->> 'media_bucket' = 'story-media'
      and nullif(i.metadata ->> 'media_path', '') is not null
      and coalesce(
        core.try_timestamptz(i.metadata ->> 'expires_at'),
        '-infinity'::timestamptz
      ) <= now()

    union all

    select null::uuid, o.name
    from storage.objects o
    where o.bucket_id = 'story-media'
      and o.name like 'organizations/' || p_organization_id
        || '/telegram-stories/%'
      and o.created_at <= now() - interval '15 minutes'
      and not exists (
        select 1
        from core.news_items i
        where i.organization_id = p_organization_id
          and i.metadata ->> 'media_bucket' = 'story-media'
          and i.metadata ->> 'media_path' = o.name
      )
  )
  select removable.item_id, removable.media_path
  from removable
  order by removable.media_path
  limit least(greatest(coalesce(p_limit, 100), 1), 1000);
$$;

create or replace function public.mark_story_media_cleaned(
  p_organization_id text,
  p_paths text[]
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  affected integer;
begin
  update core.news_items
  set metadata = (
    metadata
    - 'media_path'
    - 'media_bucket'
    - 'media_sha256'
  ) || jsonb_build_object('media_cleaned_at', now())
  where organization_id = p_organization_id
    and source_type = 'telegram_stories'
    and metadata ->> 'media_bucket' = 'story-media'
    and metadata ->> 'media_path' = any(p_paths);

  get diagnostics affected = row_count;
  return affected;
end;
$$;

revoke all on function public.list_expired_story_media(text, integer)
  from public, anon, authenticated;
revoke all on function public.mark_story_media_cleaned(text, text[])
  from public, anon, authenticated;
grant execute on function public.list_expired_story_media(text, integer)
  to service_role;
grant execute on function public.mark_story_media_cleaned(text, text[])
  to service_role;

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
        or core.try_timestamptz(i.metadata ->> 'expires_at') > now()
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
      or core.try_timestamptz(i.metadata ->> 'expires_at') > now()
    );
$$;
