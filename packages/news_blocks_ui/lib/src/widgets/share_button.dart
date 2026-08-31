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
  /// Defaults to the current platform foreground color.
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    final fallback =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    return AppButton.ghost(
      label: shareText,
      size: AppButtonSize.small,
      foregroundColor: _color ?? fallback,
      icon: const Icon(Icons.share),
      onPressed: onPressed,
    );
  }
}
