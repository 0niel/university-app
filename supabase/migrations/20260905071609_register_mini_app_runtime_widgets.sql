insert into core.mini_app_known_types (kind, name) values
  ('widget', 'appImagePicker'),
  ('widget', 'appAnimatedSwitcher'),
  ('widget', 'appAnimatedContainer'),
  ('widget', 'appAnimatedOpacity'),
  ('action', 'tryAction'),
  ('action', 'delay')
on conflict do nothing;
