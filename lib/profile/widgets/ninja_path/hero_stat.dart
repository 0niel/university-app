part of 'ninja_path_hero.dart';

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: .ellipsis,
          style: AppText.title
              .copyWith(color: colors.ink)
              .copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          maxLines: 2,
          overflow: .ellipsis,
          style: AppText.caption.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
