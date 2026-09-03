import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.icon = AppLineIcon.chevronL,
    this.iconColor,
    this.backgroundColor,
    this.tone = AppIconButtonTone.surface,
  });

  const AppBackButton.light({
    super.key,
    this.onPressed,
    this.icon = AppLineIcon.chevronL,
    this.backgroundColor,
  })  : iconColor = Colors.white,
        tone = AppIconButtonTone.plain;

  final VoidCallback? onPressed;
  final AppLineIcon icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final AppIconButtonTone tone;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: AppLineIconWidget(icon, size: AppIconSize.md),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      tone: tone,
      shape: AppIconButtonShape.circle,
      backgroundColor: backgroundColor,
      foregroundColor: iconColor,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
