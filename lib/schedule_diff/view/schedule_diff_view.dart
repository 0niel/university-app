import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/schedule_diff_section.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/schedule_diff_summary_row.dart';
import 'package:schedule/schedule.dart';

class ScheduleDiffView extends StatelessWidget {
  const ScheduleDiffView({required this.diff, required this.title, super.key});

  final ScheduleUpdateDiff diff;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scale = Theme.of(context).scale;
    final totalChanges =
        diff.added.length + diff.modified.length + diff.removed.length;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: AppInnerHeader(
              title: context.l10n.scheduleDiffTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: .fromLTRB(
                AppSpacing.screen,
                scale.space(20),
                AppSpacing.screen,
                scale.space(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.headline.copyWith(color: colors.ink),
                  ),
                  SizedBox(height: scale.space(4)),
                  Text(
                    context.l10n.scheduleDiffFoundChanges(totalChanges),
                    style: AppText.subtext.copyWith(color: colors.muted),
                  ),
                  SizedBox(height: scale.space(16)),
                  ScheduleDiffSummaryRow(diff: diff),
                ],
              ),
            ),
          ),
          if (diff.added.isNotEmpty)
            ScheduleDiffSection(
              title: context.l10n.scheduleDiffNewLessons,
              subtitle: context.l10n.scheduleDiffAddedCount(
                diff.added.length,
              ),
              color: colors.lecture,
              icon: AppLineIcon.plus,
              items: diff.added,
            ),
          if (diff.modified.isNotEmpty)
            ScheduleDiffSection(
              title: context.l10n.scheduleDiffChanges,
              subtitle: context.l10n.scheduleDiffModifiedCount(
                diff.modified.length,
              ),
              color: colors.warn,
              icon: AppLineIcon.pencil,
              items: diff.modified,
            ),
          if (diff.removed.isNotEmpty)
            ScheduleDiffSection(
              title: context.l10n.scheduleDiffRemovedLessons,
              subtitle: context.l10n.scheduleDiffRemovedCount(
                diff.removed.length,
              ),
              color: colors.exam,
              icon: AppLineIcon.trash,
              items: diff.removed,
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: ninjaBottomInset(context) + AppSpacing.lg,
            ),
          ),
        ],
      ),
    );
  }
}
