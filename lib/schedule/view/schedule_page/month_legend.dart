part of '../schedule_page.dart';

class _MonthLegend extends StatelessWidget {
  const _MonthLegend();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final palette = colors.mireaAccentPalette;
    final items = [
      (
        colors.accentInk(palette.elementAtOrNull(5) ?? colors.brand),
        l10n.legendLessons,
      ),
      (
        colors.accentInk(palette.elementAtOrNull(1) ?? colors.brand),
        l10n.busyDayBadge,
      ),
      (_activityColor(colors, .retake), l10n.legendRetake),
      (_activityColor(colors, .event), l10n.legendEvent),
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: [
        for (final (color, label) in items)
          Row(
            mainAxisSize: .min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: .circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: NinjaText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
      ],
    );
  }
}
