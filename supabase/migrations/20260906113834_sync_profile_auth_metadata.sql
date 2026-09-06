create or replace function internal.sync_academic_profile_auth_metadata()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_name text := nullif(btrim(new.full_name), '');
  v_identity jsonb;
begin
  if v_name is null and tg_op = 'INSERT' then
    return new;
  end if;
  if v_name is null then
    if nullif(btrim(old.full_name), '') is null then
      return new;
    end if;
    update auth.users
    set raw_user_meta_data = raw_user_meta_data - array['display_name', 'full_name', 'name']
    where id = new.user_id
      and jsonb_typeof(raw_user_meta_data) = 'object'
      and raw_user_meta_data ?| array['display_name', 'full_name', 'name'];
    return new;
  end if;
  v_identity := jsonb_build_object(
    'display_name', v_name, 'full_name', v_name, 'name', v_name
  );
  update auth.users
  set raw_user_meta_data = coalesce(raw_user_meta_data, '{}'::jsonb) || v_identity
  where id = new.user_id
    and (raw_user_meta_data is null or jsonb_typeof(raw_user_meta_data) = 'object')
    and not (coalesce(raw_user_meta_data, '{}'::jsonb) @> v_identity);
  return new;
end;
$$;

revoke all on function internal.sync_academic_profile_auth_metadata()
from public, anon, authenticated, service_role;

create trigger sync_academic_profile_auth_metadata
after insert or update of full_name on core.user_academic_profiles
for each row execute function internal.sync_academic_profile_auth_metadata();

update auth.users as account
set raw_user_meta_data = coalesce(account.raw_user_meta_data, '{}'::jsonb)
  || jsonb_build_object(
    'display_name', btrim(profile.full_name),
    'full_name', btrim(profile.full_name),
    'name', btrim(profile.full_name)
  )
from core.user_academic_profiles as profile
where account.id = profile.user_id
  and nullif(btrim(profile.full_name), '') is not null
  and (account.raw_user_meta_data is null or jsonb_typeof(account.raw_user_meta_data) = 'object')
  and not (coalesce(account.raw_user_meta_data, '{}'::jsonb) @> jsonb_build_object(
    'display_name', btrim(profile.full_name),
    'full_name', btrim(profile.full_name),
    'name', btrim(profile.full_name)
  ));
