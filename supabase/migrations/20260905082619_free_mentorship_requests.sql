create or replace function internal.enforce_free_mentorship()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.price := 0;
  return new;
end;
$$;

revoke all on function internal.enforce_free_mentorship()
from public, anon, authenticated;

create trigger mentor_profiles_free_price
before insert or update of price on core.mentor_profiles
for each row execute function internal.enforce_free_mentorship();

create trigger mentor_requests_free_price
before insert on core.mentor_requests
for each row execute function internal.enforce_free_mentorship();

update core.mentor_profiles set price = 0 where price <> 0;
