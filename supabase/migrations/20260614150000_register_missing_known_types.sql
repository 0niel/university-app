-- Register design-system widgets that ship in stac_bridge but were missing
-- from the known-types registry, so screen validation stops flagging them as
-- unknown (they render fine — this only fixes the validator/deploy warning).
-- Applied remotely as: register_missing_known_types.

insert into core.mini_app_known_types (kind, name) values
  ('widget', 'appServiceTile'),
  ('widget', 'appSmartChip'),
  ('widget', 'appToggle')
on conflict do nothing;
