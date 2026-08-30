-- Register the `fetch` action (calls the mini app backend through the proxy
-- and writes the JSON response into reactive state) so screen validation does
-- not flag it as unknown.
-- Applied remotely as: register_mini_app_fetch_action.

insert into core.mini_app_known_types (kind, name) values
  ('action', 'fetch')
on conflict do nothing;
