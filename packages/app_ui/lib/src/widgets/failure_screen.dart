import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    required this.title,
    super.key,
    this.description,
    this.icon,
    this.iconSize = 40,
    this.iconColor,
    this.iconBackgroundColor,
    this.buttonText,
    this.buttonIcon,
    this.onButtonPressed,
    this.buttonBackgroundColor,
    this.padding = const EdgeInsets.all(AppSpacing.xxlg),
  });

  final String title;

  final String? description;

  final HugeIcon? icon;

  final double iconSize;

  final Color? iconColor;

  final Color? iconBackgroundColor;

  final String? buttonText;

  final HugeIcon? buttonIcon;

  final VoidCallback? onButtonPressed;

  final Color? buttonBackgroundColor;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBackgroundColor ??
                      colors.background02.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: icon,
                ),
              ),
              const SizedBox(height: AppSpacing.xlg),
            ],
            Text(
              title,
              style: AppText.heading.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                description!,
                style: AppText.body.copyWith(color: colors.deactive),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.xxlg),
              AppButton.primary(
                onPressed: onButtonPressed,
                icon: buttonIcon ??
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAddSquare,
                      color: colors.white,
                    ),
                label: buttonText!,
                expanded: true,
                backgroundColor: buttonBackgroundColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
