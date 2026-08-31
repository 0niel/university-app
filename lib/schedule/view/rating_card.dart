part of 'teacher_profile_page.dart';

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.value, required this.label});

  final double? value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 96, minHeight: 76),
      child: NinjaScheduleSurface(
        padding: const .symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value?.toStringAsFixed(1) ?? '—',
              style: NinjaText.tabular(
                NinjaText.title.copyWith(color: colors.ink),
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: NinjaText.helper.copyWith(
                color: colors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
