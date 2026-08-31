part of 'ninja_geo_sharing_sheet.dart';

class _NinjaGeoSettingsSection extends StatelessWidget {
  const _NinjaGeoSettingsSection({
    required this.title,
    required this.child,
    this.helper,
  });

  final String title;
  final String? helper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final helperText = helper;
    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: NinjaText.microLabel.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 9),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: .circular(NinjaRadius.button),
            ),
            child: Padding(padding: const .all(4), child: child),
          ),
          if (helperText != null) ...[
            const SizedBox(height: 8),
            Text(
              helperText,
              style: NinjaText.helper.copyWith(color: colors.muted),
            ),
          ],
        ],
      ),
    );
  }
}

class _NinjaGeoSettingsDivider extends StatelessWidget {
  const _NinjaGeoSettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(
        left: AppSpacing.xl + 46,
        right: AppSpacing.xl,
      ),
      child: Divider(
        height: 1,
        thickness: 1,
        color: context.ninja.lineSoft,
      ),
    );
  }
}
