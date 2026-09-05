import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class NoteToolbarButton extends StatelessWidget {
  const NoteToolbarButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    super.key,
    this.active = false,
    this.destructive = false,
    this.enabled = true,
  });

  final AppLineIcon icon;
  final String semanticsLabel;
  final VoidCallback? onTap;
  final bool active;
  final bool destructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final disabled = !enabled || onTap == null;
    return Semantics(
      selected: active,
      child: AppIconButton(
        icon: AppLineIconWidget(icon, size: 20),
        tooltip: semanticsLabel,
        onPressed: disabled ? null : onTap,
        tone: destructive
            ? AppIconButtonTone.danger
            : active
            ? AppIconButtonTone.tonal
            : AppIconButtonTone.plain,
      ),
    );
  }
}
