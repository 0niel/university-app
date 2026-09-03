part of '../analytics_page.dart';

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 132, minHeight: 96),
      child: AppCard(
        child: Column(
          spacing: AppSpacing.xs,
          children: [
            Text(
              value,
              style: AppText.tabular(
                AppText.title.copyWith(color: colors.ink),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.captionSmall.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
