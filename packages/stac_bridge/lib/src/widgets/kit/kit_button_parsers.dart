import 'package:app_ui/app_ui.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

export 'stac_app_button_parser.dart';
export 'stac_app_fab_parser.dart';
export 'stac_app_icon_button_parser.dart';

AppButtonVariant appButtonVariantOf(String? name) =>
    enumByName(AppButtonVariant.values, name, AppButtonVariant.primary);

AppButtonSize appButtonSizeOf(String? name) =>
    enumByName(AppButtonSize.values, name, AppButtonSize.medium);

AppIconButtonTone appIconButtonToneOf(String? name) => switch (name) {
  'primary' || 'filled' => .primary,
  'tonal' => .tonal,
  'danger' || 'destructive' => .danger,
  'secondary' || 'outline' => .secondary,
  'surface' => .surface,
  _ => .plain,
};

AppIconButtonSize appIconButtonSizeOf(String? name) => switch (name) {
  'small' => .small,
  'compact' => .compact,
  _ => .regular,
};
