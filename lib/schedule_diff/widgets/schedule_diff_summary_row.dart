import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/schedule_diff_summary_card.dart';
import 'package:schedule/schedule.dart';

class ScheduleDiffSummaryRow extends StatelessWidget {
  const ScheduleDiffSummaryRow({required this.diff, super.key});
  final ScheduleUpdateDiff diff;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final cards = <Widget>[
      if (diff.added.isNotEmpty)
        ScheduleDiffSummaryCard(
          count: diff.added.length,
          label: context.l10n.scheduleDiffNewLabel,
          color: colors.green,
          icon: AppLineIcon.plus,
        ),
      if (diff.modified.isNotEmpty)
        ScheduleDiffSummaryCard(
          count: diff.modified.length,
          label: context.l10n.scheduleDiffModifiedLabel,
          color: colors.amber,
          icon: AppLineIcon.pencil,
        ),
      if (diff.removed.isNotEmpty)
        ScheduleDiffSummaryCard(
          count: diff.removed.length,
          label: context.l10n.scheduleDiffRemovedLabel,
          color: colors.scarlet,
          icon: AppLineIcon.trash,
        ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            MediaQuery.textScalerOf(context).scale(1) > 1.4 ||
            constraints.maxWidth < 360;
        const gap = 8.0;
        final width = stacked
            ? constraints.maxWidth
            : (constraints.maxWidth - gap * (cards.length - 1)) / cards.length;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}
