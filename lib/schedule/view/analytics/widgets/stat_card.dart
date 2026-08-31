part of '../analytics_page.dart';

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 132, minHeight: 96),
      child: NinjaScheduleSurface(
        child: Column(
          spacing: 4,
          children: [
            Text(
              value,
              style: NinjaText.tabular(
                NinjaText.title.copyWith(color: colors.ink),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: NinjaText.helper.copyWith(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
