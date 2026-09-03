import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundAddPhotoButton extends StatelessWidget {
  const LostFoundAddPhotoButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final AppLineIcon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppPressable(
      pressedScale: 0.95,
      onTap: onPressed,
      semanticsLabel: context.l10n.lostFoundPhotosLabel,
      semanticsButton: true,
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: AppLineIconWidget(icon, size: 20, color: colors.accent),
      ),
    );
  }
}
