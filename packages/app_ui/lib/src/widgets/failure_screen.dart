import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying various empty states or failure scenarios.
///
/// This widget displays a centered layout with an icon, title, description,
/// and an optional action button to help users recover from the state.
class FailureScreen extends StatelessWidget {
  /// Creates a failure screen with customizable content.
  ///
  /// The [title] parameter is required.
  const FailureScreen({
    required this.title, super.key,
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

  /// The primary message explaining the state.
  final String title;

  /// An optional description providing more details about the state.
  final String? description;

  /// The icon to display at the top of the screen.
  final IconData? icon;

  /// The size of the icon.
  final double iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the circular container around the icon.
  final Color? iconBackgroundColor;

  /// The text to display on the action button.
  final String? buttonText;

  /// The icon to show in the action button.
  final IconData? buttonIcon;

  /// The callback that is called when the action button is tapped.
  final VoidCallback? onButtonPressed;

  /// The background color of the action button.
  final Color? buttonBackgroundColor;

  /// The padding to apply around the content of the failure screen.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

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
                  color: iconBackgroundColor ?? colors.background02.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: iconColor ?? colors.deactive,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xlg),
            ],
            Text(
              title,
              style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                description!,
                style: AppTextStyle.body.copyWith(color: colors.deactive),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.xxlg),
              PrimaryButton(
                onPressed: onButtonPressed,
                icon: Icon(buttonIcon ?? Icons.add),
                text: title,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
