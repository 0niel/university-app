-- Банк знаний: публичные материалы поверх core.lesson_materials.
-- Список с ценой/страницами из metadata, топ-3 авторов, загрузка
-- материала без файла и счётчик скачиваний.

create or replace function app_api_v1.get_public_materials(
  p_organization_id text,
  p_limit integer default 50
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
        'id', m.id,
        'title', m.title,
        'subjectName', m.subject_name,
        'materialType', m.material_type,
        'downloads', m.download_count,
        'likes', m.like_count,
        'price', coalesce((m.metadata->>'price')::int, 0),
        'pages', coalesce((m.metadata->>'pages')::int, 0),
        'createdAt', m.created_at,
        'isMine', m.user_id = (select auth.uid()),
        'authorName', case
          when m.is_anonymous then 'Аноним'
          else coalesce(
            (select split_part(p.full_name, ' ', 1) || ' '
                || left(split_part(p.full_name, ' ', 2), 1) || '.'
             from core.user_academic_profiles p
             where p.user_id = m.user_id),
            'студент'
          )
        end
      )
      order by m.download_count desc, m.created_at desc
    ),
    '[]'::jsonb
  )
  from (
    select * from core.lesson_materials
    where organization_id = p_organization_id and is_public
    order by download_count desc, created_at desc
    limit least(coalesce(p_limit, 50), 100)
  ) m;
$$;

create or replace function app_api_v1.get_top_material_authors(
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
        'name', a.full_name,
        'downloads', a.downloads,
        'materials', a.materials
      )
      order by a.downloads desc
    ),
    '[]'::jsonb
  )
  from (
    select
      coalesce(p.full_name, 'Аноним') as full_name,
      sum(m.download_count) as downloads,
      count(*) as materials
    from core.lesson_materials m
    left join core.user_academic_profiles p on p.user_id = m.user_id
    where m.organization_id = p_organization_id
      and m.is_public
      and not m.is_anonymous
    group by p.full_name
    order by downloads desc
    limit 3
  ) a;
$$;

create or replace function app_api_v1.create_public_material(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0
)
returns uuid
language plpgsql
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_id uuid;
begin
  if v_user_id is null then
    raise exception 'Unauthorized';
  end if;
  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date,
    lesson_bells_number, material_type, title, file_name, file_path,
    is_public, metadata
  )
  values (
    p_organization_id, v_user_id, coalesce(p_subject_name, ''),
    current_date, 0, coalesce(p_material_type, 'note'), p_title, '', '',
    true,
    jsonb_build_object(
      'price', greatest(coalesce(p_price, 0), 0),
      'pages', greatest(coalesce(p_pages, 0), 0)
    )
  )
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function app_api_v1.increment_material_downloads(
  p_id uuid
)
returns void
language sql
security definer
set search_path = ''
as $$
  update core.lesson_materials
  set download_count = download_count + 1
  where id = p_id and is_public;
$$;

create or replace function public.get_public_materials(
  p_organization_id text,
  p_limit integer default 50
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select app_api_v1.get_public_materials(p_organization_id, p_limit);
$$;

create or replace function public.get_top_material_authors(
  p_organization_id text
)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$ select app_api_v1.get_top_material_authors(p_organization_id); $$;

create or replace function public.create_public_material(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0
)
returns uuid
language sql
set search_path = ''
as $$
  select app_api_v1.create_public_material(
    p_organization_id, p_title, p_subject_name, p_material_type,
    p_price, p_pages
  );
$$;

create or replace function public.increment_material_downloads(
  p_id uuid
)
returns void
language sql
security definer
set search_path = ''
as $$ select app_api_v1.increment_material_downloads(p_id); $$;

revoke all on function public.get_public_materials(text, integer) from public, anon;
revoke all on function public.get_top_material_authors(text) from public, anon;
revoke all on function public.create_public_material(text, text, text, text, integer, integer) from public, anon;
revoke all on function public.increment_material_downloads(uuid) from public, anon;

grant execute on function public.get_public_materials(text, integer) to authenticated;
grant execute on function public.get_top_material_authors(text) to authenticated;
grant execute on function public.create_public_material(text, text, text, text, integer, integer) to authenticated;
grant execute on function public.increment_material_downloads(uuid) to authenticated;
