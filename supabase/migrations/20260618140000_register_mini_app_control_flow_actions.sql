-- Register the action-level control-flow actions so screen validation does not
-- flag them as unknown: `runIf` (conditional) and `forEachAction` (loop).
-- Applied remotely as: register_mini_app_control_flow_actions.

insert into core.mini_app_known_types (kind, name) values
  ('action', 'runIf'),
  ('action', 'forEachAction')
on conflict do nothing;
