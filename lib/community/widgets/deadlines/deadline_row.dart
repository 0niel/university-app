import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'row/completion_button.dart';
part 'row/deadline_progress.dart';
part 'row/deadline_visual.dart';
part 'row/details.dart';
part 'row/swipe_complete_background.dart';

class DeadlineRow extends StatelessWidget {
  const DeadlineRow({
    required this.deadline,
    required this.onToggle,
    super.key,
    this.pending = false,
    this.dimmed = false,
    this.now,
  });

  final Deadline deadline;
  final VoidCallback onToggle;
  final bool pending;
  final bool dimmed;
  final DateTime? now;

  DateTime get _now => now ?? DateTime.now();

  String _dueLabel(BuildContext context) {
    final due = deadline.dueAt;
    final current = _now;
    final locale = Localizations.localeOf(context).toString();
    final time = DateFormat.Hm(locale).format(due);
    if (_sameDay(due, current)) return '${context.l10n.deadlineToday} $time';
    if (_sameDay(due, current.add(const Duration(days: 1)))) {
      return '${context.l10n.deadlineTomorrow} $time';
    }
    return DateFormat('EEE, d MMM', locale).format(due);
  }

  String _leftLabel(BuildContext context) {
    final left = deadline.timeLeftAt(_now);
    if (left.isNegative) return context.l10n.deadlineOverdue;
    if (left.inHours < 24) return context.l10n.deadlineLeftHours(left.inHours);
    if (left.inDays < 14) return context.l10n.deadlineLeftDays(left.inDays);
    return context.l10n.deadlineLeftWeeks((left.inDays / 7).round());
  }

  bool _sameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final urgent = deadline.isUrgentAt(_now);
    final canToggle = deadline.isMine && !pending;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final accent = deadline.isDone
        ? colors.green
        : urgent
        ? colors.scarlet
        : colors.brand;
    final row = AnimatedOpacity(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      opacity: deadline.isDone
          ? 0.68
          : pending
          ? 0.72
          : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DeadlineVisual(
                done: deadline.isDone,
                urgent: urgent,
                color: accent,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: _Details(
                  deadline: deadline,
                  dueLabel: _dueLabel(context),
                  leftLabel: _leftLabel(context),
                  urgent: urgent,
                  accent: accent,
                ),
              ),
              const SizedBox(width: 8),
              _CompletionButton(
                checked: deadline.isDone,
                enabled: canToggle,
                reduceMotion: reduceMotion,
                onPressed: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
    if (!canToggle || deadline.isDone) return row;
    return Dismissible(
      key: ValueKey(deadline.id),
      direction: DismissDirection.startToEnd,
      background: _SwipeCompleteBackground(colors: colors),
      confirmDismiss: (_) async {
        unawaited(HapticFeedback.mediumImpact());
        onToggle();
        return false;
      },
      child: row,
    );
  }
}
