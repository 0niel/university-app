part of '../schedule_page.dart';

class _EmptyFilterSliver extends StatelessWidget {
  const _EmptyFilterSliver({required this.filter, required this.onReset});

  final _ScheduleFilter filter;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filterWord = switch (filter) {
      .lecture => l10n.filterWordLectures,
      .seminar => l10n.filterWordSeminars,
      .laboratory => l10n.filterWordLabs,
      .exam => l10n.filterWordExams,
      .all => l10n.filterWordAll,
    };

    return SliverToBoxAdapter(
      child: Padding(
        padding: .only(bottom: 112 + ninjaBottomInset(context)),
        child: _ScheduleEmptyBlock(
          dashed: true,
          title: l10n.emptyFilterTitle(filterWord),
          message: l10n.emptyFilterSubtitle,
          actions: [
            NinjaButton.outline(
              label: l10n.resetFilter,
              size: .medium,
              onPressed: onReset,
            ),
          ],
        ),
      ),
    );
  }
}
