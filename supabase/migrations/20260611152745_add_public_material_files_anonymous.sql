-- «Залить материал» в Банке знаний по макету: файл (Storage) и
-- анонимность. Файл опционален; путь обязан начинаться с uid автора.

drop function if exists public.create_public_material(
  text, text, text, text, integer, integer
);
drop function if exists app_api_v1.create_public_material(
  text, text, text, text, integer, integer
);

create or replace function app_api_v1.create_public_material(
  p_organization_id text,
  p_title text,
  p_subject_name text,
  p_material_type text default 'note',
  p_price integer default 0,
  p_pages integer default 0,
  p_is_anonymous boolean default false,
  p_file_name text default '',
  p_file_path text default '',
  p_mime_type text default null,
  p_file_size bigint default 0
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
  if p_file_path <> ''
      and split_part(p_file_path, '/', 1) <> v_user_id::text then
    raise exception 'File path must start with the current user id';
  end if;

  insert into core.lesson_materials (
    organization_id, user_id, subject_name, lesson_date,
    lesson_bells_number, material_type, title, file_name, file_path,
    mime_type, file_size, is_public, is_anonymous, metadata
  )
  values (
    p_organization_id, v_user_id, coalesce(p_subject_name, ''),
    current_date, 0, coalesce(p_material_type, 'note'), p_title,
    coalesce(p_file_name, ''), coalesce(p_file_path, ''),
    nullif(trim(coalesce(p_mime_type, '')), ''),
    coalesce(p_file_size, 0), true, coalesce(p_is_anonymous, false),
    jsonb_build_object(
      'price', greatest(coalesce(p_price, 0), 0),
      'pages', greatest(coalesce(p_pages, 0), 0)
    )
  )
  returning id into v_id;

  perform core.apply_shuriken_delta(
    v_user_id, '📘', 'Залил материал «' || left(p_title, 60) || '»', 30
  );
  return v_id;
end;
$$;

create or replace function public.create_public_material(
  p_organization_id text, p_title text, p_subject_name text,
  p_material_type text default 'note', p_price integer default 0,
  p_pages integer default 0, p_is_anonymous boolean default false,
  p_file_name text default '', p_file_path text default '',
  p_mime_type text default null, p_file_size bigint default 0
)
returns uuid language sql security invoker set search_path = ''
as $$
  select app_api_v1.create_public_material(
    p_organization_id, p_title, p_subject_name, p_material_type,
    p_price, p_pages, p_is_anonymous, p_file_name, p_file_path,
    p_mime_type, p_file_size
  );
$$;

revoke all on function public.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text,
  bigint
) from public, anon;

grant execute on function public.create_public_material(
  text, text, text, text, integer, integer, boolean, text, text, text,
  bigint
) to authenticated;
