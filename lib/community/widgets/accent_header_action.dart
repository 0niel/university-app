import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_glyph.dart';

export 'accent_header_glyph.dart';

AppHeaderAction accentHeaderAction({
  required VoidCallback? onTap,
  required String semanticsLabel,
  AppLineIcon icon = AppLineIcon.plus,
}) => AppHeaderAction(
  onTap: onTap,
  semanticsLabel: semanticsLabel,
  child: AccentHeaderGlyph(icon: icon, enabled: onTap != null),
);
