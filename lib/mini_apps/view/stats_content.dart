part of 'mini_app_stats_page.dart';

class _StatsContent extends StatelessWidget {
  const _StatsContent({required this.app, required this.state});

  final MiniApp app;
  final MiniAppStatsState state;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final stats = state.stats;
    final l10n = context.l10n;
    if (state.status == .failure && stats.isEmpty) {
      return SingleChildScrollView(
        key: const ValueKey('stats-failure'),
        padding: const .fromLTRB(
          AppSpacing.screen,
          24,
          AppSpacing.screen,
          0,
        ),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () => unawaited(context.read<MiniAppStatsCubit>().load()),
        ).animateEmptyState(),
      );
    }
    if (state.status == .loading && stats.isEmpty) {
      return const _StatsSkeleton(key: ValueKey('stats-loading'));
    }
    if (stats.isEmpty) {
      return SingleChildScrollView(
        key: const ValueKey('stats-empty'),
        padding: const .fromLTRB(
          AppSpacing.screen,
          24,
          AppSpacing.screen,
          0,
        ),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.chart),
          title: l10n.miniAppsStatsEmpty,
          message: l10n.miniAppsStatsEmptySubtitle,
          actionLabel: l10n.refreshData,
          onAction: () => unawaited(context.read<MiniAppStatsCubit>().load()),
          outlinedAction: true,
        ).animateEmptyState(),
      );
    }
    return _StatsBody(
      key: const ValueKey('stats-ready'),
      app: app,
      stats: stats,
    );
  }
}
