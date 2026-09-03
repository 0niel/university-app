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
    required this.filter,
    required this.category,
    required this.query,
    required this.onRetry,
    required this.onCreate,
    required this.onOpen,
    required this.onOwnerActions,
    this.onChangeAnswers,
    this.onResults,
    super.key,
  });

  final bool isLoading;
  final bool isFailure;
  final List<Poll> polls;
  final PollFilter filter;
  final PollCategory? category;
  final String query;
  final VoidCallback onRetry;
  final VoidCallback onCreate;
  final ValueChanged<Poll> onOpen;
  final ValueChanged<Poll> onOwnerActions;
  final ValueChanged<Poll>? onChangeAnswers;
  final ValueChanged<Poll>? onResults;

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
      final trimmedQuery = query.trim();
      if (trimmedQuery.isNotEmpty) {
        return NinjaEmptyState(
          key: const ValueKey('polls-empty-search'),
          icon: const AppLineIconWidget(AppLineIcon.search, size: 24),
          title: l10n.pollsEmptySearch(trimmedQuery),
        );
      }
      if (filter != PollFilter.all || category != null) {
        return NinjaEmptyState(
          key: const ValueKey('polls-empty-filtered'),
          icon: const AppLineIconWidget(AppLineIcon.chart, size: 24),
          title: l10n.pollsEmptyFiltered,
        );
      }
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
            onOpen: () => onOpen(poll),
            onOwnerActions: poll.isMine ? () => onOwnerActions(poll) : null,
            onChangeAnswers: onChangeAnswers == null
                ? null
                : () => onChangeAnswers!(poll),
            onResults: onResults == null ? null : () => onResults!(poll),
          ).animateListItem(index: index),
        ],
      ],
    );
  }
}
