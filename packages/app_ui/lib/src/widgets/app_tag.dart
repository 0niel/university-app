import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
    final colors = Theme.of(context).colors;
    final (:bg, :fg) = _resolve(colors);
    final leading = this.leading;

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading, const SizedBox(width: 4)],
          Text(
            label,
            style: AppText.chip
                .copyWith(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  ({Color bg, Color fg}) _resolve(AppColors c) => switch (tone) {
        AppTagTone.accent => (
            bg: c.primary.withValues(alpha: 0.14),
            fg: c.primary
          ),
        AppTagTone.live => (
            bg: c.success.withValues(alpha: 0.16),
            fg: c.success
          ),
        AppTagTone.warn => (
            bg: c.warning.withValues(alpha: 0.16),
            fg: c.warning
          ),
        AppTagTone.danger => (bg: c.error.withValues(alpha: 0.16), fg: c.error),
        AppTagTone.info => (bg: c.info.withValues(alpha: 0.16), fg: c.info),
        AppTagTone.pink => (
            bg: c.secondary.withValues(alpha: 0.16),
            fg: c.secondary
          ),
        AppTagTone.mute => (bg: c.surfaceHigh, fg: c.deactive),
        AppTagTone.solid => (bg: c.primary, fg: c.onAccent),
      };
}

class AppLiveDot extends StatelessWidget {
  const AppLiveDot({super.key, this.size = 6});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colors.success,
        shape: BoxShape.circle,
      ),
    );
  }
}
