create or replace function app_api_v1.get_mini_apps_moderation_queue(
  p_organization_id text
)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select case
    when not core.is_mini_app_moderator(p_organization_id) then
      jsonb_build_object('pending', '[]'::jsonb, 'reported', '[]'::jsonb)
    else jsonb_build_object(
      'pending', coalesce(
        (
          select jsonb_agg(
            app_api_v1.mini_app_to_json(a, (select auth.uid()))
            order by a.updated_at
          )
          from core.mini_apps a
          where a.organization_id = p_organization_id
            and a.status = 'pending_review'
        ),
        '[]'::jsonb
      ),
      'reported', coalesce(
        (
          select jsonb_agg(reported order by last_report_at desc)
          from (
            select
              jsonb_build_object(
                'app', app_api_v1.mini_app_to_json(a, (select auth.uid())),
                'reports', coalesce(
                  (
                    select jsonb_agg(
                      jsonb_build_object(
                        'id', r.id,
                        'reason', r.reason,
                        'details', r.details,
                        'status', r.status,
                        'createdAt', r.created_at
                      )
                      order by r.created_at desc
                    )
                    from core.mini_app_reports r
                    where r.app_id = a.id and r.status = 'open'
                  ),
                  '[]'::jsonb
                )
              ) as reported,
              (
                select max(r.created_at)
                from core.mini_app_reports r
                where r.app_id = a.id and r.status = 'open'
              ) as last_report_at
            from core.mini_apps a
            where a.organization_id = p_organization_id
              and exists (
                select 1 from core.mini_app_reports r
                where r.app_id = a.id and r.status = 'open'
              )
          ) q
        ),
        '[]'::jsonb
      )
    )
  end;
$$;
