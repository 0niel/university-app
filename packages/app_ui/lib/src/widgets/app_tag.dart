import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

enum AppTagTone {
  accent,
  live,
  warn,
  danger,
  info,
  pink,
  mute,
  solid,
}

class AppTag extends StatelessWidget {
  const AppTag({
    required this.label,
    super.key,
    this.tone = AppTagTone.mute,
    this.leading,
  });

  final String label;
  final AppTagTone tone;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final (:bg, :fg) = _resolve(context.colors);
    final leading = this.leading;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.badgeInset,
        vertical: AppSpacing.fine,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading,
            const SizedBox(width: AppSpacing.xsm),
          ],
          Flexible(
            child: Text(label, style: AppText.badge.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }

  ({Color bg, Color fg}) _resolve(AppColors c) => switch (tone) {
        AppTagTone.accent => (bg: c.tint, fg: c.accent),
        AppTagTone.live => (bg: c.lectureTint, fg: c.lecture),
        AppTagTone.warn => (bg: c.warnTint, fg: c.warn),
        AppTagTone.danger => (bg: c.examTint, fg: c.exam),
        AppTagTone.info => (bg: c.practiceTint, fg: c.practice),
        AppTagTone.pink => (bg: c.labTint, fg: c.lab),
        AppTagTone.mute => (bg: c.surface2, fg: c.muted),
        AppTagTone.solid => (bg: c.accent, fg: c.onAccent),
      };
}

class AppLiveDot extends StatelessWidget {
  const AppLiveDot({super.key, this.size = 6, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? context.colors.lecture,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(dimension: size),
    );
  }
}
