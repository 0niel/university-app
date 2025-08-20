import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template share_button}
/// A reusable share button.
/// {@endtemplate}
class ShareButton extends StatelessWidget {
  /// {@macro share_button}
  const ShareButton({
    required this.shareText,
    this.onPressed,
    Color? color,
    super.key,
  }) : _color = color;

  /// The text displayed within share icon.
  final String shareText;

  /// Called when the text field has been tapped.
  final VoidCallback? onPressed;

  /// Color used for button font.
  ///
  /// Defaults to [AppColors.black]
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: _color ?? fallback,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(
        Icons.share,
        color: _color ?? fallback,
      ),
      onPressed: onPressed,
      label: Text(
        shareText,
        style: theme.textTheme.labelLarge?.copyWith(
          color: _color ?? fallback,
        ),
      ),
    );
  }
}
