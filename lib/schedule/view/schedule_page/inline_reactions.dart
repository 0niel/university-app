part of '../schedule_page.dart';

class _InlineReactions extends StatelessWidget {
  const _InlineReactions({
    required this.summary,
    this.dimmed = false,
    this.foreground,
  });

  final LessonReactionSummary summary;
  final bool dimmed;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final sorted = summary.reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final visible = sorted.take(3).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return _LessonExtraRow(
      dimmed: dimmed,
      foreground: foreground,
      text: [
        for (final entry in visible) '${entry.key.emoji} ${entry.value}',
      ].join('   '),
    );
  }
}
