part of '../deadline_row.dart';

class _Details extends StatelessWidget {
  const _Details({
    required this.deadline,
    required this.dueLabel,
    required this.leftLabel,
    required this.urgent,
    required this.accent,
  });

  final Deadline deadline;
  final String dueLabel;
  final String leftLabel;
  final bool urgent;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final sourceLabel = switch (deadline.source) {
      .me => null,
      .group => context.l10n.deadlineSourceGroup,
      .prof => context.l10n.deadlineSourceProf,
    };
    final meta = [
      if (deadline.subjectName.isNotEmpty) deadline.subjectName,
      ?sourceLabel,
    ].join(' · ');
    final dueColor = !deadline.isDone && urgent
        ? colors.scarlet
        : colors.mutedDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          deadline.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.headline.copyWith(
            color: deadline.isDone ? colors.mutedDark : colors.ink,
            decoration: deadline.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NinjaText.subtext.copyWith(color: colors.mutedDark),
          ),
        ],
        const SizedBox(height: 9),
        Text(
          deadline.isDone
              ? context.l10n.deadlineDone
              : '$dueLabel · $leftLabel',
          style: NinjaText.tabular(
            NinjaText.subtext.copyWith(color: dueColor),
          ),
        ),
        if (!deadline.isDone && deadline.progress > 0) ...[
          const SizedBox(height: 10),
          _DeadlineProgress(value: deadline.progress, color: accent),
        ],
      ],
    );
  }
}
