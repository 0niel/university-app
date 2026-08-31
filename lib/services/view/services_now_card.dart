import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'now_cta.dart';

class ServicesNowCard extends StatelessWidget {
  const ServicesNowCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onTap,
    super.key,
    this.width = 260,
    this.featured = false,
  });

  final AppLineIcon icon;
  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onTap;
  final double width;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final surface = featured ? colors.accentSoft : colors.surface;
    final tint = featured
        ? colors.onAccentSoft.withValues(alpha: .12)
        : colors.brandTint;
    final accent = featured ? colors.onAccentSoft : colors.brand;
    final label = featured ? colors.onAccentSoftMuted : colors.muted;
    final ink = featured ? colors.onAccentSoft : colors.ink;

    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$title, $subtitle',
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 112),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(NinjaRadius.button),
                  ),
                  child: AppLineIconWidget(icon, size: 21, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.subtext.copyWith(color: label),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: NinjaText.body.copyWith(
                          color: ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: _NowCta(label: cta, background: tint, foreground: accent),
            ),
          ],
        ),
      ),
    );
  }
}
