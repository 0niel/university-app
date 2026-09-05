begin;

do $$
declare
  v_user_a uuid := extensions.gen_random_uuid();
  v_user_b uuid := extensions.gen_random_uuid();
  v_change bigint;
  v_other_change bigint;
  v_rows jsonb;
  v_read_at timestamptz;
begin
  if has_table_privilege('anon', 'user_private.schedule_notification_reads', 'SELECT,INSERT,UPDATE,DELETE')
    or has_table_privilege('authenticated', 'user_private.schedule_notification_reads', 'UPDATE,DELETE')
    or has_function_privilege('anon', 'public.get_schedule_notification_read_ids(uuid)', 'EXECUTE')
    or has_function_privilege('anon', 'public.mark_schedule_notifications_read(uuid,bigint[])', 'EXECUTE')
    or (select prosecdef from pg_proc where oid = 'public.get_schedule_notification_read_ids(uuid)'::regprocedure)
    or (select prosecdef from pg_proc where oid = 'public.mark_schedule_notifications_read(uuid,bigint[])'::regprocedure)
  then
    raise exception 'Schedule read state grants bypass ownership';
  end if;

  insert into auth.users (id) values (v_user_a), (v_user_b);
  insert into core.schedule_item_change (
    organization_id, term_id, source_uid, change_kind
  ) values ('schedule-read-contract', 20261, 'schedule-read-contract-a', 'cancel')
  returning id into v_change;
  insert into core.schedule_item_change (
    organization_id, term_id, source_uid, change_kind
  ) values ('schedule-read-contract', 20261, 'schedule-read-contract-b', 'cancel')
  returning id into v_other_change;

  perform set_config('request.jwt.claim.sub', v_user_a::text, true);
  execute 'set local role authenticated';
  perform public.mark_schedule_notifications_read(auth.uid(), array[v_change, v_change, -1, 0, null]);
  v_rows := public.get_schedule_notification_read_ids(auth.uid());
  execute 'reset role';
  if v_rows is distinct from jsonb_build_array(v_change::text) then
    raise exception 'Schedule read identity was missing, malformed or duplicated';
  end if;
  select read_at into v_read_at from user_private.schedule_notification_reads
  where user_id = v_user_a and change_id = v_change;

  execute 'set local role authenticated';
  perform public.mark_schedule_notifications_read(auth.uid(), array[v_change]);
  execute 'reset role';
  if (select read_at from user_private.schedule_notification_reads
      where user_id = v_user_a and change_id = v_change) <> v_read_at then
    raise exception 'Repeated read changed the original timestamp';
  end if;

  perform set_config('request.jwt.claim.sub', v_user_b::text, true);
  execute 'set local role authenticated';
  v_rows := public.get_schedule_notification_read_ids(auth.uid());
  if exists (select 1 from user_private.schedule_notification_reads where user_id = v_user_a) then
    raise exception 'Direct table read leaked another account';
  end if;
  execute 'reset role';
  if v_rows <> '[]'::jsonb then
    raise exception 'Read state leaked between accounts';
  end if;
  begin
    execute 'set local role authenticated';
    insert into user_private.schedule_notification_reads (user_id, change_id)
    values (v_user_a, v_other_change);
    execute 'reset role';
    raise exception 'Another account could insert a read marker';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    insert into user_private.schedule_notification_reads (user_id, change_id)
    values (v_user_b, 9223372036854775807);
    execute 'reset role';
    raise exception 'A missing schedule change could be marked directly';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.mark_schedule_notifications_read(auth.uid(), array_fill(v_change, array[201]));
    execute 'reset role';
    raise exception 'Oversized marker batch was accepted';
  exception when invalid_parameter_value then
    execute 'reset role';
  end;

  execute 'set local role authenticated';
  perform public.mark_schedule_notifications_read(auth.uid(), array[v_change, v_other_change]);
  v_rows := public.get_schedule_notification_read_ids(auth.uid());
  execute 'reset role';
  if jsonb_array_length(v_rows) <> 2 then
    raise exception 'Accounts cannot independently read the same schedule change';
  end if;

  begin
    execute 'set local role authenticated';
    perform public.mark_schedule_notifications_read(v_user_a, array[v_other_change]);
    execute 'reset role';
    raise exception 'Changed request identity accepted a write';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.get_schedule_notification_read_ids(v_user_a);
    execute 'reset role';
    raise exception 'Changed request identity accepted a read';
  exception when insufficient_privilege then
    execute 'reset role';
  end;

  perform set_config('request.jwt.claim.sub', '', true);
  begin
    execute 'set local role authenticated';
    perform public.get_schedule_notification_read_ids(v_user_b);
    execute 'reset role';
    raise exception 'Missing identity leaked read state';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
  begin
    execute 'set local role authenticated';
    perform public.mark_schedule_notifications_read(auth.uid(), array[v_other_change]);
    execute 'reset role';
    raise exception 'Missing identity wrote read state';
  exception when insufficient_privilege then
    execute 'reset role';
  end;
end;
$$;

rollback;
