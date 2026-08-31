part of 'ninja_geo_sharing_sheet.dart';

class _NinjaGeoSectionCard extends StatelessWidget {
  const _NinjaGeoSectionCard({
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Text(
              title,
              style: NinjaText.microLabel.copyWith(color: colors.mutedDark),
            ),
            const SizedBox(height: 12),
            child,
            if (helperText != null) ...[
              const SizedBox(height: 10),
              Text(
                helperText,
                style: NinjaText.helper.copyWith(color: colors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
