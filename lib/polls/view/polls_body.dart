import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/view/polls_skeleton.dart';
import 'package:rtu_mirea_app/polls/widgets/widgets.dart';

class PollsBody extends StatelessWidget {
  const PollsBody({
    required this.isLoading,
    required this.isFailure,
    required this.polls,
    required this.pendingPollIds,
    required this.deletingPollIds,
    required this.onRetry,
    required this.onCreate,
    required this.onVote,
    required this.onDelete,
    super.key,
  });

  final bool isLoading;
  final bool isFailure;
  final List<Poll> polls;
  final Set<String> pendingPollIds;
  final Set<String> deletingPollIds;
  final VoidCallback onRetry;
  final VoidCallback onCreate;
  final void Function(Poll poll, List<String> optionIds) onVote;
  final ValueChanged<Poll> onDelete;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _content(context));
  }

  Widget _content(BuildContext context) {
    final l10n = context.l10n;
    if (isLoading) return const PollsSkeleton(key: ValueKey('polls-loading'));
    if (isFailure) {
      return NinjaErrorState(
        key: const ValueKey('polls-failure'),
        title: l10n.loadingError,
        message: l10n.tryAgain,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      );
    }
    if (polls.isEmpty) {
      return NinjaEmptyState(
        key: const ValueKey('polls-empty'),
        icon: const AppLineIconWidget(AppLineIcon.chart, size: 24),
        title: l10n.pollsEmptyTitle,
        message: l10n.pollsEmptySub,
        actionLabel: l10n.pollsCreate,
        onAction: onCreate,
      );
    }
    return Column(
      key: const ValueKey('polls-ready'),
      children: [
        for (final (index, poll) in polls.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.cardGap),
          PollCard(
            key: ValueKey(poll.id),
            poll: poll,
            pending: pendingPollIds.contains(poll.id),
            deleting: deletingPollIds.contains(poll.id),
            onVote: (optionIds) => onVote(poll, optionIds),
            onDelete: () => onDelete(poll),
          ).animateListItem(index: index),
        ],
      ],
    );
  }
}
