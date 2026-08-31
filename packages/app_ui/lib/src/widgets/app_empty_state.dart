import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    this.emoji,
    this.icon,
    super.key,
    this.subtitle,
    this.emojiSize = 64,
    this.child,
    this.subtitleMaxWidth = 260,
  }) : assert(
          emoji != null || icon != null,
          'AppEmptyState requires either emoji or icon.',
        );

  final String? emoji;

  final Widget? icon;

  final String title;
  final String? subtitle;
  final double emojiSize;
  final double subtitleMaxWidth;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final subtitleText = subtitle;
    final childWidget = child;
    final emojiText = emoji;
    final iconWidget = icon;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (iconWidget != null)
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.surfaceHigh,
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: iconWidget,
              ),
            )
          else if (emojiText != null)
            Text(
              emojiText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: emojiSize),
            ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.title.copyWith(
              color: colors.active,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          if (subtitleText != null) ...[
            const SizedBox(height: 8),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: subtitleMaxWidth),
                child: Text(
                  subtitleText,
                  textAlign: TextAlign.center,
                  style: AppText.body.copyWith(
                    color: colors.deactiveDarker,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
          if (childWidget != null) ...[
            const SizedBox(height: 22),
            childWidget,
          ],
        ],
      ),
    );
  }
}
