part of 'ninja_path_hero.dart';

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: .ellipsis,
          style: NinjaText.tabular(
            NinjaText.title.copyWith(color: colors.onAccentSoft),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 2,
          overflow: .ellipsis,
          style: NinjaText.helper.copyWith(color: colors.onAccentSoftMuted),
        ),
      ],
    );
  }
}
