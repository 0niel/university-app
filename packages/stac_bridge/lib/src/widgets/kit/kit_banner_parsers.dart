import 'package:app_ui/app_ui.dart';

export 'stac_app_banner_parser.dart';
export 'stac_app_tooltip_parser.dart';

AppBannerTone appBannerToneOf(String? name) => switch (name) {
  'warn' || 'warning' => .warn,
  'danger' || 'error' => .danger,
  'success' => .success,
  _ => .accent,
};

NinjaBannerTone ninjaBannerToneOf(String? name) => switch (name) {
  'warn' || 'warning' => .warn,
  'danger' || 'error' => .danger,
  'success' => .success,
  _ => .info,
};
