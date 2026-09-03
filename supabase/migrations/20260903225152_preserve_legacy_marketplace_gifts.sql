create or replace function app_api_v1.create_listing(
  p_organization_id text,
  p_title text,
  p_price integer,
  p_category text,
  p_emoji text,
  p_description text,
  p_show_contact boolean
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := (select auth.uid());
  v_category text := btrim(coalesce(p_category, ''));
  v_price integer := coalesce(p_price, -1);
  v_id uuid;
begin
  if v_user_id is null or not exists (
    select 1
    from core.user_academic_profiles profile
    where profile.user_id = v_user_id
      and profile.organization_id = p_organization_id
  ) then
    raise exception 'Marketplace is unavailable' using errcode = '42501';
  end if;
  if v_category !~ '^[a-z][a-z0-9_]{0,39}$'
    or v_price < 0
    or v_price > 100000000
    or char_length(coalesce(p_emoji, '')) > 16
    or ((v_category = 'free') <> (v_price = 0))
  then
    raise exception 'Invalid listing options' using errcode = '22023';
  end if;
  perform core.enforce_rate_limit('create_listing', 20, interval '1 hour');
  insert into core.marketplace_listings (
    organization_id,
    seller_id,
    title,
    description,
    price,
    category,
    emoji,
    show_contact,
    is_free
  ) values (
    p_organization_id,
    v_user_id,
    core.validate_text(p_title, 'Title', 120, true),
    core.validate_text(p_description, 'Description', 4000, false),
    v_price,
    v_category,
    internal.marketplace_emoji(v_category),
    coalesce(p_show_contact, false),
    v_price = 0
  ) returning id into v_id;
  return v_id;
end;
$$;

update core.marketplace_listings
set is_free = true
where not is_free
  and price = 0
  and category = 'free'
  and telegram_contact is null;

notify pgrst, 'reload schema';
