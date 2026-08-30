-- Register the reactive local-state primitives so screen validation does not
-- flag them as unknown: the `appStateScope` widget and the `setState` action.
-- Applied remotely as: mini_app_known_types_state.

insert into core.mini_app_known_types (kind, name) values
  ('widget', 'appStateScope'),
  ('action', 'setState')
on conflict do nothing;
