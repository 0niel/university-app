import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_add_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class DeadlineOverview extends StatelessWidget {
  const DeadlineOverview({
    required this.deadlines,
    required this.isCreating,
    required this.onCreate,
    super.key,
  });

  final List<Deadline> deadlines;
  final bool isCreating;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final active = deadlines.where((item) => !item.isDone).toList();
    final doneCount = deadlines.length - active.length;
    final hotCount = active.where((item) => item.isUrgent).length;
    final progress = deadlines.isEmpty
        ? 0.0
        : deadlines.fold<double>(
                0,
                (total, item) => total + (item.isDone ? 100 : item.progress),
              ) /
              (deadlines.length * 100);
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final statusLabel = hotCount > 0
        ? context.l10n.deadlinesOnFire(hotCount)
        : '$doneCount ${context.l10n.deadlinesFilterDone.toLowerCase()}';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.deadlinesActive(active.length),
                        style: NinjaText.title.copyWith(
                          color: colors.onAccentSoft,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusLabel,
                        style: NinjaText.subtext.copyWith(
                          color: hotCount > 0
                              ? colors.scarlet
                              : colors.onAccentSoftMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                DeadlineAddButton(
                  label: isCreating
                      ? context.l10n.deadlineSaving
                      : context.l10n.deadlinesFabLabel,
                  background: colors.onAccentSoft,
                  foreground: colors.accentSoft,
                  onPressed: onCreate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(NinjaRadius.pill),
                    child: SizedBox(
                      height: 6,
                      child: LayoutBuilder(
                        builder: (context, constraints) => Stack(
                          children: [
                            Positioned.fill(
                              child: ColoredBox(
                                color: Colors.white.withValues(alpha: .55),
                              ),
                            ),
                            AnimatedContainer(
                              duration: reduceMotion
                                  ? Duration.zero
                                  : const Duration(milliseconds: 420),
                              curve: Curves.easeOutCubic,
                              width: constraints.maxWidth * progress,
                              decoration: BoxDecoration(
                                color: colors.onAccentSoft,
                                borderRadius: BorderRadius.circular(
                                  NinjaRadius.pill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(progress * 100).round()}%',
                  style: NinjaText.tabular(
                    NinjaText.microLabel.copyWith(color: colors.onAccentSoft),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
