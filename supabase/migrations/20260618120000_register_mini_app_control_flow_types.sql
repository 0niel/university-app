-- Register the declarative control-flow nodes added to the BDUI engine so
-- screen validation does not flag them as unknown. These are resolver-level
-- pseudo-widgets (expanded into a plain tree before Stac builds it), not Stac
-- parsers, but they appear in the JSON under `type` like any other widget.
-- Applied remotely as: register_mini_app_control_flow_types.

insert into core.mini_app_known_types (kind, name) values
  ('widget', 'appIf'),
  ('widget', 'appForEach'),
  ('widget', 'appSwitch')
on conflict do nothing;
