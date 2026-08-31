import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppContextBanner extends StatelessWidget {
  const AppContextBanner({
    required this.title,
    required this.subtitle,
    this.emoji,
    this.icon,
    super.key,
    this.actionLabel,
    this.onTap,
  })  : gradientColors = null,
        assert(
          emoji != null || icon != null,
          'AppContextBanner requires either emoji or icon.',
        );

  const AppContextBanner.gradient({
    required this.title,
    required this.subtitle,
    this.emoji,
    this.icon,
    super.key,
    this.gradientColors = const [Color(0xFFFF5FA2), Color(0xFFB15CFF)],
    this.actionLabel,
    this.onTap,
  }) : assert(
          emoji != null || icon != null,
          'AppContextBanner requires either emoji or icon.',
        );

  final String? emoji;

  final AppLineIcon? icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;

  bool get _isGradient => gradientColors != null;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleColor = _isGradient ? Colors.white : colors.active;
    final subColor =
        _isGradient ? Colors.white.withValues(alpha: 0.92) : colors.deactive;
    final actionColor = _isGradient ? Colors.white : colors.primary;
    final gradient = gradientColors;
    final label = actionLabel;
    final emojiText = emoji;
    final iconValue = icon;

    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        decoration: BoxDecoration(
          color: _isGradient ? null : colors.primary.withValues(alpha: 0.08),
          gradient: gradient != null ? LinearGradient(colors: gradient) : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            if (iconValue != null)
              AppLineIconWidget(iconValue, size: 20, color: actionColor)
            else
              Text(emojiText!, style: const TextStyle(fontSize: 22, height: 1)),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.body.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppText.captionSmall
                        .copyWith(fontSize: 11.5, color: subColor),
                  ),
                ],
              ),
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppText.button.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: actionColor,
                ),
              ),
            ] else if (onTap != null)
              Icon(Icons.chevron_right_rounded, size: 18, color: actionColor),
          ],
        ),
      ),
    );
  }
}
