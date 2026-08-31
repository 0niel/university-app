create table core.organization_service_catalogs (
  organization_id text primary key references core.organizations(id)
    on delete cascade,
  default_locale text not null default 'ru',
  is_enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_service_catalogs_locale_valid
    check (default_locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$')
);

create trigger set_organization_service_catalogs_updated_at
before update on core.organization_service_catalogs
for each row execute function core.set_updated_at();

create table core.organization_service_sections (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  key text not null,
  title text not null,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_service_sections_key_valid
    check (key ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint organization_service_sections_title_valid
    check (char_length(btrim(title)) between 1 and 100),
  unique (organization_id, key)
);

create index organization_service_sections_catalog_idx
on core.organization_service_sections (organization_id, is_active, sort_order, key);

create trigger set_organization_service_sections_updated_at
before update on core.organization_service_sections
for each row execute function core.set_updated_at();

create table core.organization_service_section_translations (
  section_id uuid not null references core.organization_service_sections(id)
    on delete cascade,
  locale text not null,
  title text not null,
  primary key (section_id, locale),
  constraint organization_service_section_translations_locale_valid
    check (locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint organization_service_section_translations_title_valid
    check (char_length(btrim(title)) between 1 and 100)
);

create table core.organization_services (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id text not null references core.organizations(id)
    on delete cascade,
  section_id uuid not null references core.organization_service_sections(id)
    on delete cascade,
  slug text not null,
  title text not null,
  description text not null default '',
  destination_url text not null,
  icon_key text not null default 'link',
  color_key text not null default 'colorful01',
  emoji text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_services_slug_valid
    check (slug ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint organization_services_title_valid
    check (char_length(btrim(title)) between 1 and 160),
  constraint organization_services_description_valid
    check (char_length(description) <= 1000),
  constraint organization_services_destination_url_valid
    check (
      destination_url ~* '^https://[^/@[:space:]]+(/[^[:space:]]*)?$'
      and destination_url !~* '^https://[^/]*@'
    ),
  constraint organization_services_icon_key_valid
    check (icon_key ~ '^[a-z][a-z0-9_-]{0,63}$'),
  constraint organization_services_color_key_valid
    check (color_key in (
      'colorful01',
      'colorful02',
      'colorful03',
      'colorful04',
      'colorful05',
      'colorful06',
      'colorful07'
    )),
  constraint organization_services_emoji_valid
    check (emoji is null or char_length(emoji) between 1 and 16),
  unique (organization_id, slug)
);

create index organization_services_catalog_idx
on core.organization_services (organization_id, section_id, is_active, sort_order, slug);

create trigger set_organization_services_updated_at
before update on core.organization_services
for each row execute function core.set_updated_at();

create or replace function core.enforce_organization_service_section()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if not exists (
    select 1
    from core.organization_service_sections section
    where section.id = new.section_id
      and section.organization_id = new.organization_id
  ) then
    raise exception 'Service section belongs to another organization'
      using errcode = '23503';
  end if;
  return new;
end;
$$;

create trigger enforce_organization_service_section
before insert or update of organization_id, section_id
on core.organization_services
for each row execute function core.enforce_organization_service_section();

create table core.organization_service_translations (
  service_id uuid not null references core.organization_services(id)
    on delete cascade,
  locale text not null,
  title text not null,
  description text not null default '',
  primary key (service_id, locale),
  constraint organization_service_translations_locale_valid
    check (locale ~ '^[a-z]{2,3}(?:-[A-Z]{2})?$'),
  constraint organization_service_translations_title_valid
    check (char_length(btrim(title)) between 1 and 160),
  constraint organization_service_translations_description_valid
    check (char_length(description) <= 1000)
);

alter table core.organization_service_catalogs enable row level security;
alter table core.organization_service_sections enable row level security;
alter table core.organization_service_section_translations enable row level security;
alter table core.organization_services enable row level security;
alter table core.organization_service_translations enable row level security;

create or replace function app_api_v1.get_organization_service_catalog(
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
begin
  select catalog.default_locale
  into v_default_locale
  from core.organization_service_catalogs catalog
  where catalog.organization_id = p_organization_id
    and catalog.is_enabled;

  if not found then
    return jsonb_build_object(
      'organizationId', p_organization_id,
      'sections', '[]'::jsonb
    );
  end if;

  return jsonb_build_object(
    'organizationId', p_organization_id,
    'sections', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'key', section.key,
            'title', coalesce(section_translation.title, section.title),
            'sortOrder', section.sort_order,
            'items', coalesce(
              (
                select jsonb_agg(
                  jsonb_build_object(
                    'id', service.id,
                    'slug', service.slug,
                    'title', coalesce(service_translation.title, service.title),
                    'description', coalesce(
                      service_translation.description,
                      service.description
                    ),
                    'url', service.destination_url,
                    'iconKey', service.icon_key,
                    'colorKey', service.color_key,
                    'emoji', service.emoji,
                    'sortOrder', service.sort_order
                  )
                  order by service.sort_order, service.slug
                )
                from core.organization_services service
                left join lateral (
                  select translation.title, translation.description
                  from core.organization_service_translations translation
                  where translation.service_id = service.id
                    and translation.locale in (v_locale, v_default_locale)
                  order by case translation.locale
                    when v_locale then 0
                    when v_default_locale then 1
                    else 2
                  end, translation.locale
                  limit 1
                ) service_translation on true
                where service.section_id = section.id
                  and service.organization_id = p_organization_id
                  and service.is_active
              ),
              '[]'::jsonb
            )
          )
          order by section.sort_order, section.key
        )
        from core.organization_service_sections section
        left join lateral (
          select translation.title
          from core.organization_service_section_translations translation
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
            from core.organization_services service
            where service.section_id = section.id
              and service.organization_id = p_organization_id
              and service.is_active
          )
      ),
      '[]'::jsonb
    )
  );
end;
$$;

create or replace function public.get_organization_service_catalog(
  p_organization_id text,
  p_locale text default null
)
returns jsonb
language sql
security invoker
set search_path = ''
as $$
  select app_api_v1.get_organization_service_catalog(
    p_organization_id,
    p_locale
  );
$$;

revoke all on function app_api_v1.get_organization_service_catalog(text, text)
from public;
grant execute on function app_api_v1.get_organization_service_catalog(text, text)
to anon, authenticated, service_role;

revoke all on function public.get_organization_service_catalog(text, text)
from public;
grant execute on function public.get_organization_service_catalog(text, text)
to anon, authenticated, service_role;

insert into core.organization_service_catalogs (organization_id, default_locale)
select 'mirea', 'ru'
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id) do nothing;

insert into core.organization_service_sections (
  organization_id,
  key,
  title,
  sort_order
)
select 'mirea', seed.key, seed.title, seed.sort_order
from (
  values
    ('main', 'Цифровой университет', 0),
    ('student-life', 'Студенческая жизнь', 10),
    ('useful', 'Полезное', 20)
) as seed(key, title, sort_order)
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id, key) do nothing;

insert into core.organization_services (
  organization_id,
  section_id,
  slug,
  title,
  destination_url,
  icon_key,
  color_key,
  emoji,
  sort_order
)
select
  'mirea',
  section.id,
  seed.slug,
  seed.title,
  seed.destination_url,
  seed.icon_key,
  seed.color_key,
  seed.emoji,
  seed.sort_order
from (
  values
    ('main', 'library', 'Библиотека', 'https://library.mirea.ru/', 'library', 'colorful07', '📖', 0),
    ('main', 'free-software', 'Бесплатное ПО', 'https://eios.mirea.ru/eios/free/', 'download', 'colorful04', '💿', 10),
    ('main', 'cyberzone', 'Киберзона', 'https://lk.mirea.ru/cyberzone/', 'computer', 'colorful06', '🖥', 20),
    ('main', 'student-handbook', 'Справочник студента', 'https://student.mirea.ru/help/', 'help', 'colorful07', '📘', 30),
    ('main', 'scholarships', 'Стипендии', 'https://www.mirea.ru/education/scholarships-and-social-support/', 'payments', 'colorful05', '🎫', 40),
    ('main', 'military-registration', 'Воинский учёт', 'https://ump.mirea.ru/', 'shield', 'colorful01', '🛡', 50),
    ('main', 'dormitories', 'Общежития', 'https://www.mirea.ru/education/hostel/', 'dormitory', 'colorful03', '🏠', 60),
    ('student-life', 'student-office', 'Студенческий офис', 'https://student.mirea.ru/services/', 'support', 'colorful02', '🛎', 0),
    ('student-life', 'career-center', 'Центр карьеры', 'https://career.mirea.ru/', 'work', 'colorful04', '💼', 10),
    ('student-life', 'initiative-service', 'Инициативы', 'https://vote.mirea.ru/', 'idea', 'colorful06', '💡', 20),
    ('useful', 'startup-accelerator', 'Акселератор проектов', 'https://project.mirea.ru/', 'rocket', 'colorful04', '🚀', 0),
    ('useful', 'corporate-portal', 'Корпоративный портал', 'https://portal.mirea.ru/', 'business', 'colorful06', '🏢', 10)
) as seed(section_key, slug, title, destination_url, icon_key, color_key, emoji, sort_order)
join core.organization_service_sections section
  on section.organization_id = 'mirea'
  and section.key = seed.section_key
where exists (select 1 from core.organizations where id = 'mirea')
on conflict (organization_id, slug) do nothing;
