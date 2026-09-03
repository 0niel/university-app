import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/widgets/accent_header_action.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';
import 'package:rtu_mirea_app/polls/view/polls_body.dart';
import 'package:rtu_mirea_app/polls/widgets/widgets.dart';

class PollsView extends StatelessWidget {
  const PollsView({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<PollsCubit>();
    await showAppSheet<bool>(
      context,
      title: context.l10n.pollsCreateTitle,
      child: PollCreatorSheet(cubit: cubit),
    );
  }

  Future<void> _vote(
    BuildContext context,
    Poll poll,
    List<String> optionIds,
  ) async {
    final l10n = context.l10n;
    final succeeded = await context.read<PollsCubit>().submitVote(
      poll,
      optionIds,
    );
    if (!context.mounted) return;
    if (succeeded) {
      showNinjaToast(context, message: l10n.pollsVoteCounted);
    } else {
      showNinjaToast(context, showCheck: false, message: l10n.error);
    }
  }

  Future<void> _delete(BuildContext context, Poll poll) async {
    final l10n = context.l10n;
    final confirmed = await showAppConfirmDialog(
      context,
      title: l10n.pollsDeleteConfirmTitle,
      message: l10n.pollsDeleteConfirmBody,
      confirmLabel: l10n.pollsDelete,
      cancelLabel: l10n.pollsDeleteCancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final succeeded = await context.read<PollsCubit>().deletePoll(poll);
    if (!succeeded && context.mounted) {
      showNinjaToast(context, showCheck: false, message: context.l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<PollsCubit>().state;
    final cubit = context.read<PollsCubit>();
    final isLoading = state.status == .loading && state.polls.isEmpty;
    final isFailure = state.status == .failure && state.polls.isEmpty;
    final openCount = state.polls
        .where((poll) => !poll.hasVoted && !poll.hasEnded)
        .length;
    return Scaffold(
      backgroundColor: colors.canvas,
      body: RefreshIndicator(
        color: colors.accent,
        backgroundColor: colors.surface,
        onRefresh: cubit.load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppInnerHeader(
                title: l10n.pollsTitle,
                onBack: () => Navigator.of(context).maybePop(),
                backSemanticsLabel: l10n.back,
                trailingLabel: isLoading || isFailure
                    ? null
                    : l10n.pollsOpenCount(openCount),
                actions: [
                  accentHeaderAction(
                    onTap: () => unawaited(_create(context)),
                    semanticsLabel: l10n.pollsCreate,
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.screen,
                AppSpacing.xxlg,
              ),
              sliver: SliverToBoxAdapter(
                child: PollsBody(
                  isLoading: isLoading,
                  isFailure: isFailure,
                  polls: state.polls,
                  pendingPollIds: state.pendingPollIds,
                  deletingPollIds: state.deletingPollIds,
                  onRetry: () => unawaited(cubit.load()),
                  onCreate: () => unawaited(_create(context)),
                  onVote: (poll, optionIds) =>
                      unawaited(_vote(context, poll, optionIds)),
                  onDelete: (poll) => unawaited(_delete(context, poll)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
