do $$
declare
  v_definition text;
  v_condition text := 'and si.organization_id = p_organization_id and not (si.source_uid = any(v_manifest))';
  v_replacement text := 'and si.organization_id = p_organization_id
                and si.term_id = core.term_for_date(p_organization_id, current_date)
                and (coalesce(array_length(v_manifest, 1), 0) = 0 or not (si.source_uid = any(v_manifest)))';
  v_count integer;
begin
  v_definition := pg_get_functiondef('ingest_v1.upsert_schedule_payload(text,jsonb,jsonb,uuid)'::regprocedure);
  v_count := (length(v_definition) - length(replace(v_definition, v_condition, ''))) / length(v_condition);
  if v_count <> 3 then
    raise exception 'Unexpected reconciliation condition count: %', v_count;
  end if;
  if position('if coalesce(array_length(v_manifest, 1), 0) > 0 then' in v_definition) = 0 then
    raise exception 'Reconciliation manifest guard not found';
  end if;
  v_definition := replace(
    v_definition,
    'if coalesce(array_length(v_manifest, 1), 0) > 0 then',
    'if true then'
  );
  v_definition := replace(v_definition, v_condition, v_replacement);
  execute v_definition;
end;
$$;
