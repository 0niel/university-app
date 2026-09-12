create or replace function core.enforce_storage_upload_limits()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_caller uuid := auth.uid();
  v_owner_text text := coalesce(nullif(new.owner_id, ''), new.owner::text);
  v_owner uuid;
  v_size_text text;
  v_bytes bigint := 0;
  v_hint text;
begin
  if v_owner_text is null then
    if v_caller is not null then
      raise exception 'Upload owner is required' using errcode = '42501';
    end if;
    return new;
  end if;

  if v_owner_text !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then
    raise exception 'Invalid upload owner' using errcode = '22023';
  end if;
  v_owner := v_owner_text::uuid;
  if v_caller is not null and v_caller is distinct from v_owner then
    raise exception 'Upload owner does not match the account' using errcode = '42501';
  end if;

  if tg_op = 'UPDATE'
    and (new.name is distinct from old.name or new.bucket_id is distinct from old.bucket_id)
    and new.metadata -> 'size' is not distinct from old.metadata -> 'size'
    and new.metadata -> 'contentLength' is not distinct from old.metadata -> 'contentLength'
  then
    return new;
  end if;

  if tg_op = 'UPDATE'
    and new.version is not distinct from old.version
    and new.metadata -> 'size' is not distinct from old.metadata -> 'size'
    and new.metadata -> 'contentLength' is not distinct from old.metadata -> 'contentLength'
    and new.metadata -> 'eTag' is not distinct from old.metadata -> 'eTag'
  then
    return new;
  end if;

  v_size_text := coalesce(new.metadata ->> 'size', new.metadata ->> 'contentLength');
  if v_size_text is not null then
    if v_size_text !~ '^[0-9]{1,18}$' then
      raise exception 'Invalid upload size' using errcode = '22023';
    end if;
    v_bytes := v_size_text::bigint;
  end if;

  begin
    perform core.enforce_content_write_limit(
      'upload_file', 20, 120, 400, v_bytes, 1073741824, v_owner
    );
  exception when raise_exception then
    get stacked diagnostics v_hint = pg_exception_hint;
    if v_hint = 'rate_limited:upload_file' then
      raise exception 'Слишком много загрузок, попробуйте позже'
        using errcode = '42501', hint = v_hint;
    end if;
    raise;
  end;
  return new;
end;
$$;

revoke all on function core.enforce_storage_upload_limits()
from public, anon, authenticated, service_role;

create trigger enforce_storage_upload_limits
after insert or update on storage.objects
for each row execute function core.enforce_storage_upload_limits();
