import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_groups.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadlines_hero.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadlines_shared_card.dart';
import 'package:rtu_mirea_app/community/widgets/deadlines/deadline_group.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DeadlinesView extends StatelessWidget {
  const DeadlinesView({super.key, this.now});

  final DateTime? now;

  Future<void> _createDeadline(BuildContext context) async {
    final cubit = context.read<DeadlinesCubit>();
    if (cubit.state.isCreating) return;
    await showAddDeadlineSheet(context, cubit: cubit);
  }

  Future<void> _toggleDone(BuildContext context, String deadlineId) async {
    final changed = await context.read<DeadlinesCubit>().toggleDone(deadlineId);
    if (!changed && context.mounted) {
      _showError(context, context.l10n.deadlinesUpdateError);
    }
  }

  void _showError(BuildContext context, String message) {
    ToastManager.showError(context, message: message);
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
        final current = now ?? DateTime.now();
        final groups = {
          for (final kind in DeadlineGroupKind.values)
            kind: deadlinesInGroup(state.deadlines, kind, now: current),
        };
        void add() => unawaited(_createDeadline(context));
        final titles = {
          DeadlineGroupKind.today: l10n.deadlinesGroupToday,
          DeadlineGroupKind.week: l10n.deadlinesGroupWeek,
          DeadlineGroupKind.later: l10n.deadlinesGroupLater,
        };
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
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
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
                      if (state.deadlines.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: AppEmptyState(
                              title: l10n.deadlinesEmptyTitle,
                              subtitle: l10n.deadlinesEmptySubtitle,
                              actionLabel: l10n.add,
                              onAction: add,
                            ),
                          ),
                        ),
                      for (final kind in DeadlineGroupKind.values)
                        if (groups[kind]!.isNotEmpty)
                          DeadlineGroup(
                            title: titles[kind]!,
                            deadlines: groups[kind]!,
                            pendingDeadlineIds: state.pendingDeadlineIds,
                            now: current,
                            onToggle: (id) =>
                                unawaited(_toggleDone(context, id)),
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
