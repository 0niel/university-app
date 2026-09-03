part of 'ninja_geo_sharing_sheet.dart';

class _NinjaGeoSharingToggleRow extends StatelessWidget {
  const _NinjaGeoSharingToggleRow({
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
    final colors = context.colors;
    final onChanged = this.onChanged;
    final enabled = onChanged != null;
    final row = Semantics(
      button: enabled,
      enabled: enabled,
      child: AppPressable(
        onTap: enabled ? () => onChanged(!value) : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 68),
          child: Padding(
            padding: const .symmetric(
              horizontal: AppSpacing.xl,
              vertical: 9,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: .circular(AppRadius.badge),
                  ),
                  child: AppLineIconWidget(
                    icon,
                    size: 18,
                    color: colors.muted,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.body.copyWith(
                          color: colors.ink,
                          fontWeight: .w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                NinjaSwitch(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
    return enabled ? row : Opacity(opacity: 0.45, child: row);
  }
}
