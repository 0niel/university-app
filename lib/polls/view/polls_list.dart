part of 'polls_view.dart';

class _PollsList extends StatelessWidget {
  const _PollsList({
    required this.isLoading,
    required this.isFailure,
    required this.polls,
    required this.pendingPollIds,
    required this.deletingPollIds,
    required this.onCreate,
    required this.onVote,
    required this.onDelete,
  });

  final bool isLoading;
  final bool isFailure;
  final List<Poll> polls;
  final Set<String> pendingPollIds;
  final Set<String> deletingPollIds;
  final VoidCallback onCreate;
  final void Function(Poll poll, List<String> optionIds) onVote;
  final ValueChanged<Poll> onDelete;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    if (isLoading) return const _PollsSkeleton(key: ValueKey('polls-loading'));
    if (isFailure) return _buildErrorState(context);
    if (polls.isEmpty) return _buildEmptyState(context);
    return ListView.builder(
      key: const ValueKey('polls-ready'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
      itemCount: polls.length,
      itemBuilder: (context, index) {
        final poll = polls[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PollCard(
            key: ValueKey(poll.id),
            poll: poll,
            pending: pendingPollIds.contains(poll.id),
            deleting: deletingPollIds.contains(poll.id),
            onVote: (optionIds) => onVote(poll, optionIds),
            onDelete: () => _confirmDelete(context, poll),
          ).animateListItem(index: index),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<PollsCubit>();
    return ListView(
      key: const ValueKey('polls-failure'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      children: [
        NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(cubit.load()),
        ).animateEmptyState(),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      key: const ValueKey('polls-empty'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      children: [
        NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.chart),
          title: l10n.pollsEmptyTitle,
          message: l10n.pollsEmptySub,
          actionLabel: l10n.pollsCreate,
          onAction: onCreate,
        ).animateEmptyState(),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, Poll poll) async {
    final l10n = context.l10n;
    final confirmed = await showNinjaConfirmDialog(
      context,
      title: l10n.pollsDeleteConfirmTitle,
      message: l10n.pollsDeleteConfirmBody,
      confirmLabel: l10n.pollsDelete,
      cancelLabel: l10n.pollsDeleteCancel,
      destructive: true,
    );
    if (confirmed) onDelete(poll);
  }
}
