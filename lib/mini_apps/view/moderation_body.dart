part of 'mini_apps_moderation_page.dart';

class _ModerationBody extends StatelessWidget {
  const _ModerationBody({required this.state});

  final MiniAppsModerationState state;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    if (state.status == .loading && state.queue.isEmpty) {
      return const _ModerationSkeleton(key: ValueKey('moderation-loading'));
    }
    if (state.status == .failure) {
      return SingleChildScrollView(
        key: const ValueKey('moderation-failure'),
        padding: const .symmetric(horizontal: AppSpacing.screen),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () =>
              unawaited(context.read<MiniAppsModerationCubit>().load()),
        ).animateEmptyState(),
      );
    }
    if (state.queue.isEmpty) {
      return SingleChildScrollView(
        key: const ValueKey('moderation-empty'),
        padding: const .symmetric(horizontal: AppSpacing.screen),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.check),
          title: l10n.miniAppsModerationEmpty,
          message: l10n.miniAppsModerationEmptySubtitle,
          actionLabel: l10n.refreshData,
          onAction: () =>
              unawaited(context.read<MiniAppsModerationCubit>().load()),
          outlinedAction: true,
        ).animateEmptyState(),
      );
    }
    final queue = state.queue;
    return RefreshIndicator(
      key: const ValueKey('moderation-ready'),
      color: colors.accent,
      backgroundColor: colors.surface,
      onRefresh: () => context.read<MiniAppsModerationCubit>().load(),
      child: ListView(
        padding: const .only(bottom: 60),
        children: [
          if (queue.pending.isNotEmpty) ...[
            _ModerationSectionLabel(
              title: l10n.miniAppsModerationPending,
              subtitle: l10n.miniAppsModerationPendingSubtitle,
            ),
            for (final (index, app) in queue.pending.indexed)
              _PendingCard(
                app: app,
                processing: state.processingAppId == app.id,
              ).animateListItem(index: index),
          ],
          if (queue.reported.isNotEmpty) ...[
            _ModerationSectionLabel(
              title: l10n.miniAppsModerationReported,
              subtitle: l10n.miniAppsModerationReportedSubtitle,
            ),
            for (final (index, reported) in queue.reported.indexed)
              _ReportedCard(
                reported: reported,
                processing: state.processingAppId == reported.app.id,
              ).animateListItem(index: index),
          ],
        ],
      ),
    );
  }
}
