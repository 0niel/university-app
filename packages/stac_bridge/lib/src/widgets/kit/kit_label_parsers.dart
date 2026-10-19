import 'package:app_ui/app_ui.dart';

export 'stac_app_badge_parser.dart';
export 'stac_app_count_badge_parser.dart';
export 'stac_app_hash_tag_parser.dart';
export 'stac_app_live_badge_parser.dart';
export 'stac_app_meta_pill_parser.dart';
export 'stac_app_tag_parser.dart';
export 'stac_app_type_tag_parser.dart';

AppBadgeTone appBadgeToneOf(String? name) => switch (name) {
  'accent' => .accent,
  'ink' || 'solid' => .ink,
  'exam' || 'danger' => .exam,
  'warn' => .warn,
  'lecture' || 'success' || 'live' => .lecture,
  'lab' => .lab,
  'practice' || 'info' => .practice,
  _ => .neutral,
};
