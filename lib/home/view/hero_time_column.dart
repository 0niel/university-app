part of 'home_lesson_hero.dart';

class _HeroTimeColumn extends StatelessWidget {
  const _HeroTimeColumn({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          DateFormat.Hm().format(start),
          style: NinjaText.tabular(
            NinjaText.title.copyWith(color: colors.onAccentSoft),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat.Hm().format(end),
          style: NinjaText.tabular(
            NinjaText.helper.copyWith(color: colors.onAccentSoftMuted),
          ),
        ),
      ],
    );
  }
}
