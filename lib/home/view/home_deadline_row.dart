import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDeadlineRow extends StatefulWidget {
  const HomeDeadlineRow({
    required this.deadline,
    this.onToggled,
    super.key,
  });

  final Deadline deadline;
  final VoidCallback? onToggled;

  @override
  State<HomeDeadlineRow> createState() => _HomeDeadlineRowState();
}

class _HomeDeadlineRowState extends State<HomeDeadlineRow> {
  late bool _isDone = widget.deadline.isDone;
  bool _saving = false;

  @override
  void didUpdateWidget(covariant HomeDeadlineRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline.id != widget.deadline.id ||
        oldWidget.deadline.isDone != widget.deadline.isDone) {
      _isDone = widget.deadline.isDone;
    }
  }

  Future<void> _toggleDone() async {
    if (_saving) return;
    final done = !_isDone;
    setState(() {
      _isDone = done;
      _saving = true;
    });
    try {
      await context.read<ScheduleRepository>().setDeadlineState(
        id: widget.deadline.id,
        done: done,
      );
      widget.onToggled?.call();
    } on Exception {
      if (mounted) setState(() => _isDone = !done);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deadline = widget.deadline;
    final colors = context.ninja;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final toggleTint = _isDone ? colors.brand : colors.surfaceAlt;
    final toggleInk = _isDone ? colors.onBrand : colors.mutedDark;
    final content = AnimatedOpacity(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      opacity: _isDone ? 0.5 : 1,
      child: AppPressable(
        onTap: () => context.go('/services/deadlines'),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(NinjaRadius.card),
          ),
          padding: const .fromLTRB(10, 8, 16, 8),
          child: Row(
            children: [
              Semantics(
                button: true,
                checked: _isDone,
                child: AppPressable(
                  key: ValueKey('home-deadline-toggle-${deadline.id}'),
                  onTap: deadline.isMine && !_saving
                      ? () => unawaited(_toggleDone())
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: toggleTint,
                      shape: .circle,
                    ),
                    child: SizedBox.square(
                      dimension: 44,
                      child: Center(
                        child: _saving
                            ? NinjaSpinner(
                                size: 16,
                                strokeWidth: 2,
                                color: toggleInk,
                              )
                            : AppLineIconWidget(
                                _isDone ? .check : .clock,
                                size: 18,
                                color: toggleInk,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      deadline.title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: NinjaText.body.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (deadline.subjectName.isNotEmpty)
                          deadline.subjectName,
                        homeDueLabel(l10n, locale, deadline.dueAt),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.helper.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 44),
                child: Text(
                  _leftLabel(l10n),
                  textAlign: .end,
                  style: NinjaText.badge.copyWith(
                    color: deadline.isUrgent
                        ? colors.scarlet
                        : colors.mutedDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (!deadline.isMine) return content;
    return Dismissible(
      key: ValueKey(deadline.id),
      direction: DismissDirection.startToEnd,
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brand,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
            child: AppLineIconWidget(.check, color: colors.onInk),
          ),
        ),
      ),
      confirmDismiss: (_) async {
        unawaited(HapticFeedback.mediumImpact());
        unawaited(_toggleDone());
        return false;
      },
      child: content,
    );
  }

  String _leftLabel(AppLocalizations l10n) {
    final left = widget.deadline.timeLeft;
    if (left.isNegative) return l10n.homeOverdue;
    if (left.inHours < 24) return l10n.homeHoursShort(left.inHours);
    return l10n.homeDaysShort(left.inDays);
  }
}

String homeDueLabel(AppLocalizations l10n, String locale, DateTime due) {
  final now = DateTime.now();
  if (due.year == now.year && due.day == now.day && due.month == now.month) {
    return l10n.homeDueToday(DateFormat.Hm().format(due));
  }
  final tomorrow = now.add(const Duration(days: 1));
  if (due.year == tomorrow.year &&
      due.day == tomorrow.day &&
      due.month == tomorrow.month) {
    return l10n.homeDueTomorrow(DateFormat.Hm().format(due));
  }
  return DateFormat('d MMMM', locale).format(due);
}
