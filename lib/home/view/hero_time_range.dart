part of 'home_lesson_hero.dart';

class _HeroTimeRange extends StatelessWidget {
  const _HeroTimeRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Text(
      '${DateFormat.Hm().format(start)} – ${DateFormat.Hm().format(end)}',
      maxLines: 1,
      overflow: .ellipsis,
      style: NinjaText.tabular(
        NinjaText.title.copyWith(color: colors.onAccentSoft),
      ),
    );
  }
}
