part of 'mini_app_stats_page.dart';

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final AppLineIcon icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            AppLineIconWidget(icon, size: AppIconSize.md, color: colors.muted),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppText.tabular(
                AppText.title.copyWith(color: colors.ink),
              ),
            ),
            Text(
              label,
              textAlign: .center,
              style: AppText.captionSmall.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
