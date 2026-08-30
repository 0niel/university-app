-- Mini-app analytics are now visible to ANY signed-in user for published
-- apps (not just the owner/moderator). Drafts/rejected/suspended apps stay
-- restricted to the owner and moderators.
-- Applied remotely as: mini_app_stats_public_read.

drop policy if exists "owners and moderators read stats"
  on core.mini_app_stats_daily;

create policy "stats readable for published or by owner/moderator"
on core.mini_app_stats_daily for select to authenticated
using (
  exists (
    select 1 from core.mini_apps a
    where a.id = app_id
      and (
        a.status = 'published'
        or a.owner_id = (select auth.uid())
        or core.is_mini_app_moderator(a.organization_id)
      )
  )
);
