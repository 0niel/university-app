part of 'ninja_geo_sharing_sheet.dart';

class _NinjaGeoSharingToggleCard extends StatelessWidget {
  const _NinjaGeoSharingToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final AppLineIcon icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    return Padding(
      padding: const .only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            children: [
              Container(
                width: NinjaMetrics.minTouchTarget,
                height: NinjaMetrics.minTouchTarget,
                alignment: .center,
                decoration: BoxDecoration(
                  color: enabled ? colors.surfaceAlt : colors.surface,
                  shape: .circle,
                ),
                child: AppLineIconWidget(
                  icon,
                  size: 20,
                  color: enabled ? colors.ink : colors.disabled,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 3,
                  children: [
                    Text(
                      title,
                      style: NinjaText.headline.copyWith(
                        color: enabled ? colors.ink : colors.disabled,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              NinjaSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}
