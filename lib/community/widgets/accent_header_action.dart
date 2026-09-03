import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

AppHeaderAction accentHeaderAction({
  required VoidCallback? onTap,
  required String semanticsLabel,
  AppLineIcon icon = AppLineIcon.plus,
}) => AppHeaderAction(
  onTap: onTap,
  semanticsLabel: semanticsLabel,
  child: AccentHeaderGlyph(icon: icon, enabled: onTap != null),
);

class AccentHeaderGlyph extends StatelessWidget {
  const AccentHeaderGlyph({
    required this.icon,
    super.key,
    this.enabled = true,
  });

  final AppLineIcon icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: AppControlSize.iconButton,
      height: AppControlSize.iconButton,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? colors.accent : colors.surface2,
        shape: BoxShape.circle,
      ),
      child: AppLineIconWidget(
        icon,
        size: 20,
        strokeWidth: 2.4,
        color: enabled ? colors.onAccent : colors.muted2,
      ),
    );
  }
}
