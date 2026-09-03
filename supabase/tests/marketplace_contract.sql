begin;

do $$
declare
  v_function text;
begin
  foreach v_function in array array[
    'app_api_v1.get_listings(text)',
    'app_api_v1.create_listing(text,text,integer,text,text,text)',
    'app_api_v1.create_listing(text,text,integer,text,text,text,boolean)',
    'app_api_v1.create_listing_v2(text,text,integer,text,text,boolean,jsonb,text,boolean)',
    'app_api_v1.update_listing(uuid,text,integer,text,text,boolean,jsonb,text,boolean)',
    'app_api_v1.set_listing_sold(uuid,boolean)',
    'app_api_v1.delete_listing(uuid)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not has_function_privilege('service_role', v_function, 'EXECUTE')
    then
      raise exception 'Internal marketplace privileges are invalid: %',
        v_function;
    end if;
  end loop;

  foreach v_function in array array[
    'public.get_listings(text)',
    'public.create_listing(text,text,integer,text,text,text)',
    'public.create_listing(text,text,integer,text,text,text,boolean)',
    'public.create_listing_v2(text,text,integer,text,text,boolean,jsonb,text,boolean)',
    'public.update_listing(uuid,text,integer,text,text,boolean,jsonb,text,boolean)',
    'public.set_listing_sold(uuid,boolean)',
    'public.delete_listing(uuid)'
  ] loop
    if has_function_privilege('anon', v_function, 'EXECUTE')
      or not has_function_privilege('authenticated', v_function, 'EXECUTE')
      or not (
        select function.prosecdef
        from pg_proc function
        where function.oid = v_function::regprocedure
      )
    then
      raise exception 'Public marketplace privileges are invalid: %',
        v_function;
    end if;
  end loop;

  if has_table_privilege(
    'authenticated',
    'core.marketplace_listings',
    'INSERT'
  ) or has_table_privilege(
    'authenticated',
    'core.marketplace_listings',
    'UPDATE'
  ) or has_table_privilege(
    'authenticated',
    'core.marketplace_listings',
    'DELETE'
  ) then
    raise exception 'Direct marketplace mutations are still available';
  end if;
end;
$$;

do $$
declare
  v_seller uuid := extensions.gen_random_uuid();
  v_buyer uuid := extensions.gen_random_uuid();
  v_outsider uuid := extensions.gen_random_uuid();
  v_listing_id uuid;
  v_private_listing_id uuid;
  v_contact_listing_id uuid;
  v_hidden_contact_listing_id uuid;
  v_rows jsonb;
begin
  insert into core.organizations (id, name)
  values
    ('market-test-a', 'Market Test A'),
    ('market-test-b', 'Market Test B');

  insert into auth.users (id)
  values (v_seller), (v_buyer), (v_outsider);

  insert into core.user_academic_profiles (
    user_id,
    organization_id,
    full_name,
    academic_group,
    handle
  )
  values
    (v_seller, 'market-test-a', 'Seller User', 'A-01', 'seller_user'),
    (v_buyer, 'market-test-a', 'Buyer User', 'A-02', 'buyer_user'),
    (v_outsider, 'market-test-b', 'Outside User', 'B-01', 'outside_user');

  perform set_config('request.jwt.claim.role', 'authenticated', true);
  perform set_config('request.jwt.claim.sub', v_outsider::text, true);
  begin
    perform app_api_v1.get_listings('market-test-a');
    raise exception 'Foreign marketplace was enumerable';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.create_listing(
      'market-test-a',
      'Cross tenant',
      100,
      'other',
      '📦',
      '',
      true
    );
    raise exception 'Cross-organization listing was created';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  begin
    perform app_api_v1.create_listing(
      'market-test-a',
      'Fake gift',
      100,
      'free',
      '🎁',
      '',
      true
    );
    raise exception 'A priced free listing was created';
  exception
    when invalid_parameter_value then null;
  end;
  begin
    perform app_api_v1.create_listing(
      'market-test-a',
      'Zero book',
      0,
      'books',
      '📚',
      '',
      true
    );
    raise exception 'A zero-priced non-free listing was created';
  exception
    when invalid_parameter_value then null;
  end;

  v_listing_id := app_api_v1.create_listing(
    'market-test-a',
    'Algorithms',
    1200,
    'books',
    'mismatched',
    'Clean textbook',
    true
  );
  v_private_listing_id := app_api_v1.create_listing(
    'market-test-a',
    'Free notes',
    0,
    'free',
    'mismatched',
    'Printed notes'
  );

  perform set_config('request.jwt.claim.sub', v_buyer::text, true);
  select app_api_v1.get_listings('market-test-a') into v_rows;
  if v_rows is null or jsonb_array_length(v_rows) <> 2
    or not exists (
      select 1
      from jsonb_array_elements(v_rows) row
      where row->>'id' = v_listing_id::text
        and row->>'sellerName' = 'Seller U.'
        and row ? 'telegramHandle'
        and row->>'telegramHandle' is null
        and row->>'sellerHandle' is null
        and (row->>'showContact')::boolean
        and (row->>'isFree')::boolean is false
        and (row->>'price')::integer = 1200
        and row->>'emoji' = '📚'
    )
    or not exists (
      select 1
      from jsonb_array_elements(v_rows) row
      where row->>'id' = v_private_listing_id::text
        and row->>'sellerHandle' is null
        and row ? 'telegramHandle'
        and row->>'telegramHandle' is null
        and not (row->>'showContact')::boolean
        and (row->>'isFree')::boolean is true
        and (row->>'price')::integer = 0
    )
  then
    raise exception 'Marketplace read or contact privacy contract is invalid';
  end if;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  v_contact_listing_id := public.create_listing_v2(
    'market-test-a', 'Telegram contact', 1500, 'books', 'Textbook',
    false, '[]'::jsonb, '@explicit_seller', true
  );
  v_hidden_contact_listing_id := public.create_listing_v2(
    'market-test-a', 'Private Telegram contact', 0, 'books', 'Gift',
    true, '[]'::jsonb, 'private_seller', false
  );
  select public.get_listings('market-test-a') into v_rows;
  if v_rows is null or jsonb_array_length(v_rows) <> 4
    or not exists (
      select 1 from jsonb_array_elements(v_rows) row
      where row->>'id' = v_hidden_contact_listing_id::text
        and row->>'telegramHandle' = 'private_seller'
        and (row->>'isMine')::boolean is true
        and (row->>'showContact')::boolean is false
        and (row->>'isFree')::boolean is true
        and (row->>'price')::integer = 0
    ) then
    raise exception 'Seller cannot edit the private Telegram contact';
  end if;

  perform set_config('request.jwt.claim.sub', v_buyer::text, true);
  select public.get_listings('market-test-a') into v_rows;
  if v_rows is null or jsonb_array_length(v_rows) <> 4
    or not exists (
      select 1 from jsonb_array_elements(v_rows) row
      where row->>'id' = v_contact_listing_id::text
        and row->>'telegramHandle' = 'explicit_seller'
        and row->>'sellerHandle' is null
        and (row->>'showContact')::boolean is true
    )
    or not exists (
      select 1 from jsonb_array_elements(v_rows) row
      where row->>'id' = v_hidden_contact_listing_id::text
        and row ? 'telegramHandle'
        and row->>'telegramHandle' is null
        and row->>'sellerHandle' is null
        and (row->>'showContact')::boolean is false
    ) then
    raise exception 'Explicit Telegram contact privacy contract is invalid';
  end if;
  begin
    perform public.update_listing(v_contact_listing_id,
      'Changed by buyer', 100, 'books', 'Changed',
      false, '[]'::jsonb, 'buyer_contact', true);
    raise exception 'Buyer replaced a foreign seller contact';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  perform public.update_listing(v_contact_listing_id,
    'Telegram contact', 1500, 'books', 'Textbook',
    false, '[]'::jsonb, 'updated_seller', false);
  perform set_config('request.jwt.claim.sub', v_buyer::text, true);
  select public.get_listings('market-test-a') into v_rows;
  if v_rows is null or not exists (
    select 1 from jsonb_array_elements(v_rows) row
    where row->>'id' = v_contact_listing_id::text
      and row ? 'telegramHandle'
      and row->>'telegramHandle' is null
      and (row->>'showContact')::boolean is false
  ) then
    raise exception 'Disabling Telegram contact did not hide it from buyers';
  end if;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  select public.get_listings('market-test-a') into v_rows;
  if v_rows is null or not exists (
    select 1 from jsonb_array_elements(v_rows) row
    where row->>'id' = v_contact_listing_id::text
      and row->>'telegramHandle' = 'updated_seller'
      and (row->>'showContact')::boolean is false
  ) then
    raise exception 'Seller contact update did not persist';
  end if;
  perform public.delete_listing(v_contact_listing_id);
  perform public.delete_listing(v_hidden_contact_listing_id);
  perform set_config('request.jwt.claim.sub', v_buyer::text, true);

  begin
    perform app_api_v1.set_listing_sold(v_listing_id, true);
    raise exception 'Buyer marked a foreign listing sold';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.delete_listing(v_listing_id);
    raise exception 'Buyer deleted a foreign listing';
  exception
    when insufficient_privilege then null;
  end;
  begin
    perform app_api_v1.delete_listing(extensions.gen_random_uuid());
    raise exception 'Missing listing deletion returned success';
  exception
    when insufficient_privilege then null;
  end;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  perform app_api_v1.set_listing_sold(v_listing_id, true);
  perform set_config('request.jwt.claim.sub', v_buyer::text, true);
  select app_api_v1.get_listings('market-test-a') into v_rows;
  if exists (
    select 1 from jsonb_array_elements(v_rows) row
    where row->>'id' = v_listing_id::text
  ) then
    raise exception 'Sold listing remained visible to buyers';
  end if;

  perform set_config('request.jwt.claim.sub', v_seller::text, true);
  select app_api_v1.get_listings('market-test-a') into v_rows;
  if not exists (
    select 1 from jsonb_array_elements(v_rows) row
    where row->>'id' = v_listing_id::text
      and (row->>'isSold')::boolean
  ) then
    raise exception 'Seller lost access to sold listing lifecycle';
  end if;
  perform app_api_v1.delete_listing(v_listing_id);
  if exists (
    select 1 from core.marketplace_listings listing
    where listing.id = v_listing_id
  ) then
    raise exception 'Seller deletion did not remove the listing';
  end if;

  update core.user_academic_profiles profile
  set organization_id = 'market-test-b'
  where profile.user_id = v_seller;
  if (
    select listing.archived_at
    from core.marketplace_listings listing
    where listing.id = v_private_listing_id
  ) is null then
    raise exception 'Seller organization change left an active listing';
  end if;
  begin
    perform app_api_v1.get_listings('market-test-a');
    raise exception 'Former organization seller enumerated old listings';
  exception
    when insufficient_privilege then null;
  end;
end;
$$;

rollback;
