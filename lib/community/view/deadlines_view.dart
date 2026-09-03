import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_actions_sheet.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_groups.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_labels.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadlines_hero.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadlines_shared_card.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_group.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

enum DeadlinesViewMode { list, calendar }

class DeadlinesView extends StatefulWidget {
  const DeadlinesView({super.key, this.now});

  final DateTime? now;

  @override
  State<DeadlinesView> createState() => _DeadlinesViewState();
}

class _DeadlinesViewState extends State<DeadlinesView> {
  DeadlinesViewMode _mode = DeadlinesViewMode.list;
  DateTime? _selectedDay;
  late DateTime _calendarMonth = _monthOf(widget.now ?? DateTime.now());

  static DateTime _monthOf(DateTime value) => DateTime(value.year, value.month);

  Future<void> _createDeadline(BuildContext context) async {
    final cubit = context.read<DeadlinesCubit>();
    if (cubit.state.isCreating) return;
    await showAddDeadlineSheet(context, cubit: cubit);
  }

  Future<void> _toggleDone(BuildContext context, String deadlineId) async {
    final changed = await context.read<DeadlinesCubit>().toggleDone(
      deadlineId,
    );
    if (!changed && context.mounted) {
      _showError(context, context.l10n.deadlinesUpdateError);
    }
  }

  void _deleteDeadline(BuildContext context, String deadlineId) {
    final l10n = context.l10n;
    context.read<DeadlinesCubit>().deleteDeadline(deadlineId);
    ToastManager.showInfo(
      context,
      message: l10n.deadlineDeletedToast,
      actionLabel: l10n.undo,
      onAction: () =>
          context.read<DeadlinesCubit>().undoDeleteDeadline(deadlineId),
    );
  }

  void _showError(BuildContext context, String message) {
    ToastManager.showError(context, message: message);
  }

  List<Widget> _bodySlivers(
    BuildContext context, {
    required DeadlinesState state,
    required List<Deadline> deadlines,
    required Map<DeadlineGroupKind, List<Deadline>> groups,
    required Map<DeadlineGroupKind, String> titles,
    required DateTime current,
    required DeadlinesCubit cubit,
  }) {
    final l10n = context.l10n;
    if (deadlines.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: AppEmptyState(
              title: l10n.deadlinesEmptyTitle,
              subtitle: l10n.deadlinesEmptySubtitle,
              actionLabel: l10n.add,
              onAction: () => unawaited(_createDeadline(context)),
            ),
          ),
        ),
      ];
    }
    if (_mode == DeadlinesViewMode.calendar) {
      return [
        SliverToBoxAdapter(
          child: _DeadlinesCalendar(
            deadlines: deadlines,
            month: _calendarMonth,
            selectedDay: _selectedDay,
            now: current,
            onMonthChanged: (month) => setState(() => _calendarMonth = month),
            onDaySelected: (day) => setState(() => _selectedDay = day),
            cubit: cubit,
            pendingDeadlineIds: state.pendingDeadlineIds,
            onToggle: (id) => unawaited(_toggleDone(context, id)),
            onDelete: (id) => _deleteDeadline(context, id),
          ),
        ),
      ];
    }
    final groupSlivers = <Widget>[];
    for (final kind in deadlineGroupOrder) {
      final items = groups[kind]!;
      if (items.isEmpty) continue;
      groupSlivers.add(
        DeadlineGroup(
          title: titles[kind]!,
          deadlines: items,
          pendingDeadlineIds: state.pendingDeadlineIds,
          now: current,
          cubit: cubit,
          collapsible: kind == DeadlineGroupKind.done,
          expanded: state.doneGroupExpanded,
          onToggleExpanded: kind == DeadlineGroupKind.done
              ? cubit.toggleDoneGroupExpanded
              : null,
          onToggle: (id) => unawaited(_toggleDone(context, id)),
          onDelete: (id) => _deleteDeadline(context, id),
        ),
      );
    }
    return groupSlivers;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeadlinesCubit, DeadlinesState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.deadlines.isNotEmpty,
      listener: (context, _) =>
          _showError(context, context.l10n.deadlinesRefreshError),
      builder: (context, state) {
        final l10n = context.l10n;
        final cubit = context.read<DeadlinesCubit>();
        final current = widget.now ?? DateTime.now();
        final deadlines = state.displayDeadlines;
        void add() => unawaited(_createDeadline(context));
        final titles = {
          DeadlineGroupKind.overdue: l10n.deadlinesGroupOverdue,
          DeadlineGroupKind.today: l10n.deadlinesGroupToday,
          DeadlineGroupKind.tomorrow: l10n.deadlinesGroupTomorrow,
          DeadlineGroupKind.week: l10n.deadlinesGroupWeek,
          DeadlineGroupKind.later: l10n.deadlinesGroupLater,
          DeadlineGroupKind.done: l10n.deadlinesGroupDone,
        };
        final groups = deadlineGroups(deadlines, now: current);
        final overdueMine = [
          for (final deadline in deadlines)
            if (deadline.isMine &&
                !deadline.isDone &&
                deadline.dueAt.isBefore(current))
              deadline,
        ];

        return ColoredBox(
          color: context.colors.canvas,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppInnerHeader(
                  title: l10n.deadlinesTitle,
                  backSemanticsLabel: l10n.back,
                  onBack: () => Navigator.of(context).maybePop(),
                  actions: [
                    AppHeaderAction(
                      semanticsLabel: l10n.deadlinesAddSemantics,
                      onTap: state.isCreating ? null : add,
                      child: AppIconTile(
                        icon: AppLineIcon.plus,
                        size: 44,
                        radius: AppRadius.full,
                        background: context.colors.accent,
                        foreground: context.colors.onAccent,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  ninjaBottomInset(context) + AppSpacing.lg,
                ),
                sliver: SliverMainAxisGroup(
                  slivers: [
                    if (state.deadlines.isEmpty &&
                        (state.status == DeadlinesStatus.initial ||
                            state.status == DeadlinesStatus.loading))
                      const SliverToBoxAdapter(
                        child: AppSkeletonGroup(
                          child: AppListGroup(
                            children: [AppSkeletonRow(), AppSkeletonRow()],
                          ),
                        ),
                      )
                    else if (state.deadlines.isEmpty &&
                        state.status == DeadlinesStatus.failure)
                      SliverToBoxAdapter(
                        child: AppErrorState(
                          title: l10n.deadlinesLoadError,
                          message: l10n.deadlinesLoadErrorSubtitle,
                          primaryLabel: l10n.retry,
                          footnote: null,
                          onPrimary: () => unawaited(cubit.load()),
                        ),
                      )
                    else ...[
                      SliverToBoxAdapter(
                        child: DeadlinesHero(
                          done: state.deadlines.where((d) => d.isDone).length,
                          total: state.deadlines.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.lg),
                          child: AppSegmentedControl<DeadlinesViewMode>(
                            value: _mode,
                            onChanged: (mode) => setState(() => _mode = mode),
                            options: [
                              AppSegmentedOption(
                                value: DeadlinesViewMode.list,
                                label: l10n.deadlinesViewList,
                              ),
                              AppSegmentedOption(
                                value: DeadlinesViewMode.calendar,
                                label: l10n.deadlinesViewCalendar,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (overdueMine.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.lg),
                            child: AppBanner(
                              message: l10n.deadlinesOverdueBanner(
                                overdueMine.length,
                              ),
                              tone: AppBannerTone.danger,
                              actionLabel: l10n.deadlinesPostponeAction,
                              onAction: () async {
                                final moved = await cubit
                                    .postponeOverdueToTomorrow(now: current);
                                if (!context.mounted) return;
                                if (moved) {
                                  ToastManager.showSuccess(
                                    context,
                                    message: l10n.deadlinesPostponedToast,
                                  );
                                } else {
                                  ToastManager.showError(
                                    context,
                                    message: l10n.deadlinesPostponeError,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ..._bodySlivers(
                        context,
                        state: state,
                        deadlines: deadlines,
                        groups: groups,
                        titles: titles,
                        current: current,
                        cubit: cubit,
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: DeadlinesSharedCard(
                            shared: state.deadlines
                                .where((d) => d.source != .me)
                                .length,
                            total: state.deadlines.length,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeadlinesCalendar extends StatelessWidget {
  const _DeadlinesCalendar({
    required this.deadlines,
    required this.month,
    required this.selectedDay,
    required this.now,
    required this.onMonthChanged,
    required this.onDaySelected,
    required this.cubit,
    required this.pendingDeadlineIds,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Deadline> deadlines;
  final DateTime month;
  final DateTime? selectedDay;
  final DateTime now;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDaySelected;
  final DeadlinesCubit cubit;
  final Set<String> pendingDeadlineIds;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;

  List<Color> _dotsForDay(BuildContext context, DateTime day) {
    final colors = context.colors;
    return [
      for (final deadline in deadlines)
        if (sameDay(deadline.dueAt, day))
          deadline.isDone
              ? colors.muted2
              : deadlineUrgencyTierAt(deadline, now) ==
                    DeadlineUrgencyTier.normal
              ? colors.accent
              : colors.danger,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = selectedDay;
    final dayItems = <Deadline>[
      if (selected != null)
        for (final deadline in deadlines)
          if (sameDay(deadline.dueAt, selected)) deadline,
    ]..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCalendarMonth(
          month: month,
          selectedDay: selectedDay,
          today: now,
          onMonthChanged: onMonthChanged,
          onDaySelected: onDaySelected,
          dotsForDay: (day) => _dotsForDay(context, day),
        ),
        if (selected != null) ...[
          const SizedBox(height: AppSpacing.lg),
          if (dayItems.isEmpty)
            AppEmptyState.compact(title: l10n.deadlinesCalendarDayEmpty)
          else
            AppListGroup(
              children: [
                for (final deadline in dayItems)
                  DeadlineRow(
                    key: ValueKey('deadline-calendar-${deadline.id}'),
                    deadline: deadline,
                    now: now,
                    pending: pendingDeadlineIds.contains(deadline.id),
                    onToggle: deadline.isMine
                        ? () => onToggle(deadline.id)
                        : null,
                    onDelete: () => onDelete(deadline.id),
                    onLongPress: () => showDeadlineActionsSheet(
                      context,
                      cubit: cubit,
                      deadline: deadline,
                    ),
                  ),
              ],
            ),
        ],
      ],
    );
  }
}
