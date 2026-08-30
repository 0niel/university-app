begin;

do $$
begin
  if not has_function_privilege(
    'anon',
    'public.get_organization_community_catalog(text,text)',
    'EXECUTE'
  ) then
    raise exception 'Anonymous catalog read grant is missing';
  end if;
  if has_table_privilege('anon', 'core.organization_communities', 'INSERT')
    or has_table_privilege('authenticated', 'core.organization_communities', 'UPDATE') then
    raise exception 'Catalog tables are client-writable';
  end if;
end;
$$;

do $$
declare
  v_result jsonb;
begin
  if (select count(*) from core.organization_communities where organization_id = 'mirea') <> 20 then
    raise exception 'The MIREA community catalog seed is incomplete';
  end if;

  v_result := app_api_v1.get_organization_community_catalog('mirea', 'ru');
  if v_result #>> '{sections,0,key}' <> 'general'
    or v_result #>> '{sections,0,items,0,slug}' <> 'mirea-ninja'
    or v_result ->> 'suggestionUrl' <> 'https://t.me/mirea_ninja_chat' then
    raise exception 'The MIREA catalog seed is not available through the API';
  end if;
end;
$$;

do $$
declare
  v_section_a uuid := extensions.gen_random_uuid();
  v_section_b uuid := extensions.gen_random_uuid();
  v_result jsonb;
begin
  insert into core.organizations (id, name)
  values
    ('catalog-test-a', 'Catalog Test A'),
    ('catalog-test-b', 'Catalog Test B');

  insert into core.organization_community_catalogs (
    organization_id,
    default_locale,
    suggestion_url
  )
  values ('catalog-test-a', 'ru', 'https://t.me/catalog_test');

  insert into core.organization_community_sections (
    id,
    organization_id,
    key,
    title,
    emoji,
    sort_order
  )
  values
    (v_section_a, 'catalog-test-a', 'study', 'Учёба', '🎓', 20),
    (v_section_b, 'catalog-test-a', 'life', 'Жизнь', '🏠', 10);

  insert into core.organization_community_section_translations (
    section_id,
    locale,
    title
  )
  values (v_section_a, 'en', 'Study');

  insert into core.organization_community_section_translations (
    section_id,
    locale,
    title
  )
  values (v_section_a, 'de', 'Studium');

  insert into core.organization_communities (
    organization_id,
    section_id,
    slug,
    title,
    destination_url,
    platform,
    sort_order,
    is_featured
  )
  values
    (
      'catalog-test-a',
      v_section_a,
      'official-news',
      'Новости',
      'https://t.me/catalog_test_news',
      'telegram',
      20,
      true
    ),
    (
      'catalog-test-a',
      v_section_a,
      'study-chat',
      'Чат',
      'https://t.me/catalog_test_chat',
      'telegram',
      10,
      false
    ),
    (
      'catalog-test-a',
      v_section_b,
      'inactive',
      'Скрыто',
      'https://example.com/inactive',
      'website',
      0,
      false
    );

  update core.organization_communities
  set is_active = false
  where organization_id = 'catalog-test-a'
    and slug = 'inactive';

  insert into core.organization_community_translations (
    community_id,
    locale,
    title,
    description
  )
  select id, 'en', 'News', 'Official news'
  from core.organization_communities
  where organization_id = 'catalog-test-a'
    and slug = 'official-news';

  insert into core.organization_community_translations (
    community_id,
    locale,
    title,
    description
  )
  select id, 'de', 'Nachrichten', 'Offizielle Nachrichten'
  from core.organization_communities
  where organization_id = 'catalog-test-a'
    and slug = 'official-news';

  v_result := app_api_v1.get_organization_community_catalog(
    'catalog-test-a',
    'en'
  );
  if jsonb_array_length(v_result -> 'sections') <> 1
    or v_result #>> '{sections,0,key}' <> 'study'
    or v_result #>> '{sections,0,title}' <> 'Study'
    or v_result #>> '{sections,0,items,0,slug}' <> 'study-chat'
    or v_result #>> '{sections,0,items,1,title}' <> 'News' then
    raise exception 'Catalog ordering or locale fallback is invalid';
  end if;
  if v_result::text like '%metadata%' then
    raise exception 'Public catalog response leaked metadata';
  end if;

  v_result := app_api_v1.get_organization_community_catalog(
    'catalog-test-a',
    'ru'
  );
  if v_result #>> '{sections,0,title}' <> 'Учёба'
    or v_result #>> '{sections,0,items,1,title}' <> 'Новости' then
    raise exception 'Catalog locale fallback selected an unrelated translation';
  end if;

  if jsonb_array_length(
    app_api_v1.get_organization_community_catalog('catalog-test-b', 'en')
      -> 'sections'
  ) <> 0 then
    raise exception 'Tenant B received tenant A communities';
  end if;

  begin
    insert into core.organization_communities (
      organization_id,
      section_id,
      slug,
      title,
      destination_url,
      platform
    )
    values (
      'catalog-test-b',
      v_section_a,
      'cross-tenant',
      'Cross tenant',
      'https://example.com',
      'website'
    );
    raise exception 'A cross-tenant section was accepted';
  exception
    when foreign_key_violation then null;
  end;

  begin
    insert into core.organization_communities (
      organization_id,
      section_id,
      slug,
      title,
      destination_url,
      platform
    )
    values (
      'catalog-test-a',
      v_section_a,
      'unsafe-url',
      'Unsafe',
      'http://t.me/unsafe',
      'telegram'
    );
    raise exception 'An unsafe URL was accepted';
  exception
    when check_violation then null;
  end;
end;
$$;

rollback;
