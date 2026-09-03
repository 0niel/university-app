begin;

set local statement_timeout = '30s';
set local lock_timeout = '5s';

do $$
declare
  v_owner uuid;
  v_user uuid;
  v_group uuid;
  v_other_owner uuid;
  v_other_group uuid;
  v_invite uuid;
  v_mode text;
  v_guest boolean;
  v_accept boolean;
  v_result jsonb;
  v_failures text[] := '{}';
  v_passed integer := 0;
begin
  insert into core.organizations (id, name)
  values
    ('study-lifecycle-a', 'Study Lifecycle A'),
    ('study-lifecycle-b', 'Study Lifecycle B');

  foreach v_guest in array array[false, true] loop
    foreach v_mode in array array[
      'invite_accept', 'invite_decline', 'code',
      'request_accept', 'request_decline', 'stale_request',
      'stale_request_decline'
    ] loop
      begin
        v_owner := extensions.gen_random_uuid();
        v_user := extensions.gen_random_uuid();
        v_group := extensions.gen_random_uuid();
        v_invite := null;
        v_accept := v_mode in ('invite_accept', 'code', 'request_accept');
        insert into auth.users (id, is_anonymous, raw_app_meta_data)
        values
          (v_owner, v_guest, '{"contract":"study_group_lifecycle"}'),
          (v_user, v_guest, '{"contract":"study_group_lifecycle"}');
        insert into core.user_academic_profiles (
          user_id, organization_id, academic_group, full_name
        ) values
          (v_owner, 'study-lifecycle-a', 'LIFE-01', 'Lifecycle Owner'),
          (v_user, 'study-lifecycle-a', 'LIFE-01', 'Lifecycle Applicant');
        insert into core.study_groups (
          id, organization_id, owner_id, name, join_code
        ) values (
          v_group, 'study-lifecycle-a', v_owner,
          'Lifecycle Group', upper(left(replace(v_group::text, '-', ''), 8))
        );
        insert into core.study_group_members (group_id, user_id, role)
        values (v_group, v_owner, 'owner');

        perform set_config('request.jwt.claim.role', 'authenticated', true);
        perform set_config('request.jwt.claim.sub', v_owner::text, true);
        perform set_config('request.jwt.claims', jsonb_build_object(
          'sub', v_owner, 'role', 'authenticated', 'is_anonymous', v_guest
        )::text, true);
        execute 'set local role authenticated';
        if v_mode like 'invite_%' then
          perform public.invite_to_study_group(v_user);
        end if;
        execute 'reset role';

        if v_mode = 'invite_decline' then
          v_other_owner := extensions.gen_random_uuid();
          v_other_group := extensions.gen_random_uuid();
          insert into auth.users (id, raw_app_meta_data)
          values (v_other_owner, '{"contract":"study_group_lifecycle"}');
          insert into core.user_academic_profiles (
            user_id, organization_id, academic_group
          ) values (v_other_owner, 'study-lifecycle-a', 'LIFE-01');
          insert into core.study_groups (
            id, organization_id, owner_id, name, join_code
          ) values (
            v_other_group, 'study-lifecycle-a', v_other_owner,
            'Other Lifecycle Group',
            upper(left(replace(v_other_group::text, '-', ''), 8))
          );
          insert into core.study_group_members (group_id, user_id, role)
          values (v_other_group, v_other_owner, 'owner');
          insert into core.study_group_invites (
            group_id, target_user_id, created_by, kind
          ) values (v_other_group, v_user, v_other_owner, 'invite');
        end if;

        perform set_config('request.jwt.claim.sub', v_user::text, true);
        perform set_config('request.jwt.claims', jsonb_build_object(
          'sub', v_user, 'role', 'authenticated', 'is_anonymous', v_guest
        )::text, true);
        execute 'set local role authenticated';
        if (select auth.uid()) is distinct from v_user
          or (select (auth.jwt()->>'is_anonymous')::boolean)
            is distinct from v_guest then
          raise exception 'Lifecycle authentication claims are invalid';
        end if;
        if v_mode like 'request_%' or v_mode like 'stale_request%' then
          perform public.request_to_join_group(v_group);
        end if;
        execute 'reset role';
        select id into v_invite
        from core.study_group_invites
        where group_id = v_group and target_user_id = v_user
          and status = 'pending';

        if v_mode like 'stale_request%' then
          update core.user_academic_profiles
          set organization_id = 'study-lifecycle-b'
          where user_id = v_user;
        end if;
        if v_mode like 'request_%' or v_mode like 'stale_request%' then
          perform set_config('request.jwt.claim.sub', v_owner::text, true);
          perform set_config('request.jwt.claims', jsonb_build_object(
            'sub', v_owner, 'role', 'authenticated', 'is_anonymous', v_guest
          )::text, true);
        end if;
        execute 'set local role authenticated';
        if v_mode like 'invite_%' then
          v_result := public.respond_group_invite(v_invite, v_accept);
        elsif v_mode = 'code' then
          v_result := public.join_group_by_code(
            'study-lifecycle-a',
            ' ' || lower(left(replace(v_group::text, '-', ''), 8)) || ' '
          );
        elsif v_mode = 'stale_request' then
          begin
            perform public.respond_join_request(v_invite, true);
            raise exception 'Cross-tenant stale applicant was accepted';
          exception when insufficient_privilege then null;
          end;
        else
          v_result := public.respond_join_request(v_invite, v_accept);
        end if;
        execute 'reset role';

        if v_mode <> 'stale_request' then
          if v_mode = 'invite_decline' and (
            jsonb_array_length(v_result->'incomingInvites') is distinct from 1
            or (v_result->'incomingInvites'->0->>'groupId')::uuid
              is distinct from v_other_group
          ) then
            raise exception 'Declining an invite discarded another pending invite';
          end if;
          if jsonb_typeof(v_result->'members') is distinct from 'array'
            or jsonb_typeof(v_result->'incomingInvites') is distinct from 'array'
            or jsonb_typeof(v_result->'pendingRequests') is distinct from 'array'
          then
            raise exception 'Lifecycle response arrays are missing or malformed';
          end if;
          if (v_result->>'hasGroup')::boolean is distinct from
            (v_mode <> 'invite_decline') then
            raise exception 'Lifecycle membership response is inconsistent';
          end if;
          if v_mode <> 'invite_decline'
            and (v_result->'group'->>'id')::uuid is distinct from v_group then
            raise exception 'Lifecycle response returned the wrong group';
          end if;
          if v_invite is not null and (
            select status from core.study_group_invites where id = v_invite
          ) is distinct from (case when v_accept then 'accepted' else 'declined' end)
          then
            raise exception 'Invitation or request status did not transition';
          end if;
        end if;
        if exists (
          select 1 from core.study_group_members
          where group_id = v_group and user_id = v_user
        ) is distinct from v_accept then
          raise exception 'Lifecycle persisted an incorrect membership';
        end if;
        v_passed := v_passed + 1;
      exception when others then
        execute 'reset role';
        v_failures := array_append(v_failures, format(
          '%s guest=%s: %s %s', v_mode, v_guest, sqlstate, sqlerrm
        ));
      end;
    end loop;
  end loop;
  if cardinality(v_failures) > 0 then
    raise exception 'Study-group lifecycle contract: %', jsonb_build_object(
      'passed', v_passed, 'failed', cardinality(v_failures),
      'failures', v_failures
    );
  end if;
end;
$$;

rollback;
