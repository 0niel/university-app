import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';
import 'package:rtu_mirea_app/polls/widgets/widgets.dart';

part 'poll_skeleton_card.dart';
part 'polls_hero.dart';
part 'polls_list.dart';
part 'polls_skeleton.dart';

class PollsView extends StatelessWidget {
  const PollsView({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<PollsCubit>();
    final l10n = context.l10n;
    await showAppSheet<bool>(
      context,
      title: l10n.pollsCreateTitle,
      child: PollCreatorSheet(cubit: cubit),
    );
  }

  Future<void> _vote(
    BuildContext context,
    PollsCubit cubit,
    Poll poll,
    List<String> optionIds,
  ) async {
    final succeeded = await cubit.submitVote(poll, optionIds);
    if (!succeeded && context.mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  Future<void> _delete(
    BuildContext context,
    PollsCubit cubit,
    Poll poll,
  ) async {
    final succeeded = await cubit.deletePoll(poll);
    if (!succeeded && context.mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<PollsCubit>().state;
    final cubit = context.read<PollsCubit>();
    final isLoading = state.status == .loading && state.polls.isEmpty;
    final isFailure = state.status == .failure && state.polls.isEmpty;
    return Scaffold(
      backgroundColor: colors.canvas,
      floatingActionButton: AppFab.extended(
        icon: AppLineIcon.plus,
        label: l10n.pollsCreate,
        onPressed: () => unawaited(_create(context)),
      ),
      body: NinjaSkeletonGroup(
        excludeSemantics: false,
        pulse: isLoading,
        child: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.pollsTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: NinjaText.display.copyWith(
                                color: colors.ink,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          NinjaIconButton(
                            key: const ValueKey('polls-refresh-button'),
                            icon: const AppLineIconWidget(
                              AppLineIcon.refresh,
                              size: 20,
                            ),
                            tooltip: l10n.refreshData,
                            onPressed: isLoading
                                ? null
                                : () => unawaited(cubit.load()),
                          ),
                        ],
                      ),
                      if (!isFailure) ...[
                        const SizedBox(height: 16),
                        _PollsHero(
                          count: state.polls.length,
                          loading: isLoading,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            body: RefreshIndicator(
              color: colors.brand,
              backgroundColor: colors.surface,
              onRefresh: cubit.load,
              child: _PollsList(
                isLoading: isLoading,
                isFailure: isFailure,
                polls: state.polls,
                pendingPollIds: state.pendingPollIds,
                deletingPollIds: state.deletingPollIds,
                onCreate: () => unawaited(_create(context)),
                onVote: (poll, optionIds) =>
                    unawaited(_vote(context, cubit, poll, optionIds)),
                onDelete: (poll) => unawaited(_delete(context, cubit, poll)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
