create table core.organization_community_catalogs (
  organization_id text primary key references core.organizations(id)
    on delete cascade,
  default_locale text not null default 'ru',
  suggestion_url text,
  is_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_community_catalogs_locale_valid
    check (default_locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint organization_community_catalogs_suggestion_url_valid
    check (
      suggestion_url is null
      or (
        suggestion_url ~* '^https://[^/@[:space:]]+(/[^[:space:]]*)?$'
        and suggestion_url !~* '^https://[^/]*@'
      )
    )
);

create trigger set_organization_community_catalogs_updated_at
before update on core.organization_community_catalogs
for each row execute function core.set_updated_at();

create table core.organization_community_sections (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  key text not null,
  title text not null,
  emoji text not null default '💬',
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_community_sections_key_valid
    check (key ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint organization_community_sections_title_valid
    check (char_length(btrim(title)) between 1 and 100),
  constraint organization_community_sections_emoji_valid
    check (char_length(emoji) between 1 and 16),
  unique (organization_id, key)
);

create trigger set_organization_community_sections_updated_at
before update on core.organization_community_sections
for each row execute function core.set_updated_at();

create table core.organization_community_section_translations (
  section_id uuid not null references core.organization_community_sections(id)
    on delete cascade,
  locale text not null,
  title text not null,
  primary key (section_id, locale),
  constraint organization_community_section_translations_locale_valid
    check (locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint organization_community_section_translations_title_valid
    check (char_length(btrim(title)) between 1 and 100)
);

create table core.organization_communities (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  section_id uuid not null references core.organization_community_sections(id)
    on delete cascade,
  slug text not null,
  title text not null,
  description text not null default '',
  destination_url text not null,
  logo_url text,
  platform text not null default 'website',
  member_count integer,
  member_count_updated_at timestamptz,
  is_featured boolean not null default false,
  is_official boolean not null default false,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_communities_slug_valid
    check (slug ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint organization_communities_title_valid
    check (char_length(btrim(title)) between 1 and 160),
  constraint organization_communities_description_valid
    check (char_length(description) <= 1000),
  constraint organization_communities_platform_valid
    check (platform in ('telegram', 'vk', 'discord', 'website', 'other')),
  constraint organization_communities_member_count_valid
    check (member_count is null or member_count >= 0),
  constraint organization_communities_destination_url_valid
    check (
      destination_url ~* '^https://[^/@[:space:]]+(/[^[:space:]]*)?$'
      and destination_url !~* '^https://[^/]*@'
    ),
  constraint organization_communities_logo_url_valid
    check (
      logo_url is null
      or (
        logo_url ~* '^https://[^/@[:space:]]+(/[^[:space:]]*)?$'
        and logo_url !~* '^https://[^/]*@'
      )
    ),
  constraint organization_communities_platform_host_valid
    check (
      (platform = 'telegram' and destination_url ~* '^https://(t[.]me|telegram[.]me)/')
      or (platform = 'vk' and destination_url ~* '^https://(vk[.]com|vk[.]ru)/')
      or (platform = 'discord' and destination_url ~* '^https://(discord[.]gg|discord[.]com)/')
      or platform in ('website', 'other')
    ),
  unique (organization_id, slug)
);

create index organization_communities_catalog_idx
on core.organization_communities (organization_id, is_active, sort_order, slug);

create trigger set_organization_communities_updated_at
before update on core.organization_communities
for each row execute function core.set_updated_at();

create or replace function core.enforce_organization_community_section()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if not exists (
    select 1
    from core.organization_community_sections section
    where section.id = new.section_id
      and section.organization_id = new.organization_id
  ) then
    raise exception 'Community section belongs to another organization'
      using errcode = '23503';
  end if;
  return new;
end;
$$;

create trigger enforce_organization_community_section
before insert or update of organization_id, section_id
on core.organization_communities
for each row execute function core.enforce_organization_community_section();

create table core.organization_community_translations (
  community_id uuid not null references core.organization_communities(id)
    on delete cascade,
  locale text not null,
  title text not null,
  description text not null default '',
  primary key (community_id, locale),
  constraint organization_community_translations_locale_valid
    check (locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint organization_community_translations_title_valid
    check (char_length(btrim(title)) between 1 and 160),
  constraint organization_community_translations_description_valid
    check (char_length(description) <= 1000)
);

alter table core.organization_community_catalogs enable row level security;
alter table core.organization_community_sections enable row level security;
alter table core.organization_community_section_translations enable row level security;
alter table core.organization_communities enable row level security;
alter table core.organization_community_translations enable row level security;

create or replace function app_api_v1.get_organization_community_catalog(
  p_organization_id text,
  p_locale text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_default_locale text;
  v_locale text := nullif(btrim(p_locale), '');
  v_suggestion_url text;
begin
  select catalog.default_locale, catalog.suggestion_url
  into v_default_locale, v_suggestion_url
  from core.organization_community_catalogs catalog
  where catalog.organization_id = p_organization_id
    and catalog.is_enabled;

  if not found then
    return jsonb_build_object(
      'organizationId', p_organization_id,
      'suggestionUrl', null,
      'sections', '[]'::jsonb
    );
  end if;

  return jsonb_build_object(
    'organizationId', p_organization_id,
    'suggestionUrl', v_suggestion_url,
    'sections', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'key', section.key,
            'title', coalesce(section_translation.title, section.title),
            'emoji', section.emoji,
            'sortOrder', section.sort_order,
            'items', coalesce(
              (
                select jsonb_agg(
                  jsonb_build_object(
                    'id', community.id,
                    'slug', community.slug,
                    'title', coalesce(community_translation.title, community.title),
                    'description', coalesce(
                      community_translation.description,
                      community.description
                    ),
                    'url', community.destination_url,
                    'logoUrl', community.logo_url,
                    'platform', community.platform,
                    'membersCount', community.member_count,
                    'membersCountUpdatedAt', community.member_count_updated_at,
                    'isFeatured', community.is_featured,
                    'isOfficial', community.is_official,
                    'sortOrder', community.sort_order
                  )
                  order by community.sort_order, community.slug
                )
                from core.organization_communities community
                left join lateral (
                  select translation.title, translation.description
                  from core.organization_community_translations translation
                  where translation.community_id = community.id
                    and translation.locale in (v_locale, v_default_locale)
                  order by case translation.locale
                    when v_locale then 0
                    when v_default_locale then 1
                    else 2
                  end, translation.locale
                  limit 1
                ) community_translation on true
                where community.section_id = section.id
                  and community.organization_id = p_organization_id
                  and community.is_active
              ),
              '[]'::jsonb
            )
          )
          order by section.sort_order, section.key
        )
        from core.organization_community_sections section
        left join lateral (
          select translation.title
          from core.organization_community_section_translations translation
          where translation.section_id = section.id
            and translation.locale in (v_locale, v_default_locale)
          order by case translation.locale
            when v_locale then 0
            when v_default_locale then 1
            else 2
          end, translation.locale
          limit 1
        ) section_translation on true
        where section.organization_id = p_organization_id
          and section.is_active
          and exists (
            select 1
            from core.organization_communities community
            where community.section_id = section.id
              and community.organization_id = p_organization_id
              and community.is_active
          )
      ),
      '[]'::jsonb
    )
  );
end;
$$;

create or replace function public.get_organization_community_catalog(
  p_organization_id text,
  p_locale text default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.get_organization_community_catalog(
    p_organization_id,
    p_locale
  );
$$;

revoke all on function app_api_v1.get_organization_community_catalog(text, text)
from public;
grant execute on function app_api_v1.get_organization_community_catalog(text, text)
to anon, authenticated, service_role;

revoke all on function public.get_organization_community_catalog(text, text)
from public;
grant execute on function public.get_organization_community_catalog(text, text)
to anon, authenticated, service_role;
