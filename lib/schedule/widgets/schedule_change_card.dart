import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_change_presentation.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleChangeCard extends StatelessWidget {
  const ScheduleChangeCard({required this.change, super.key});

  final ScheduleChange change;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final presentation = ScheduleChangePresentation.fromChange(change, l10n);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppBadge(
              label: presentation.title,
              tone: switch (presentation.effectiveKind) {
                ScheduleChangeKind.cancel => AppBadgeTone.exam,
                ScheduleChangeKind.add => AppBadgeTone.lecture,
                _ => AppBadgeTone.neutral,
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            presentation.subject,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
          if (presentation.context.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              presentation.context.join(' · '),
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
          for (final detail in presentation.details) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              detail.label,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
            const SizedBox(height: AppSpacing.xs),
            LayoutBuilder(
              builder: (context, constraints) {
                final stacked =
                    constraints.maxWidth < 300 ||
                    detail.before.length > 28 ||
                    detail.after.length > 28 ||
                    MediaQuery.textScalerOf(context).scale(14) > 20;
                final before = _Value(
                  label: l10n.scheduleChangeBefore,
                  value: detail.before,
                  previous: true,
                );
                final after = _Value(
                  label: l10n.scheduleChangeAfter,
                  value: detail.after,
                );
                return stacked
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          before,
                          const SizedBox(height: AppSpacing.xs),
                          after,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: before),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: after),
                        ],
                      );
              },
            ),
          ],
          if (!presentation.isSingleSnapshot &&
              presentation.details.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.scheduleChangeDetailsUnavailable,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.scheduleChangeDetectedAt(
              DateFormat.yMMMd(
                l10n.localeName,
              ).add_Hm().format(change.createdAt),
            ),
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value({
    required this.label,
    required this.value,
    this.previous = false,
  });
  final String label;
  final String value;
  final bool previous;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppText.captionSmall.copyWith(color: context.colors.muted),
      ),
      Text(
        value,
        style: AppText.body.copyWith(
          color: previous ? context.colors.muted : context.colors.ink,
          fontWeight: previous ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
    ],
  );
}
