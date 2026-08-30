grant execute on function app_api_v1.get_lesson_materials(
  text,
  text,
  date,
  integer
) to anon, authenticated;

grant execute on function app_api_v1.create_lesson_material(
  text,
  text,
  date,
  integer,
  text,
  text,
  text,
  text,
  text,
  text,
  bigint,
  boolean,
  boolean
) to authenticated;

grant execute on function app_api_v1.get_lesson_reviews(
  text,
  text,
  date,
  integer
) to anon, authenticated;

grant execute on function app_api_v1.upsert_lesson_review(
  text,
  text,
  date,
  integer,
  text,
  text,
  integer,
  boolean
) to authenticated;
