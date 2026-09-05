part of 'mini_app_stats_page.dart';

class MiniAppStatsView extends StatelessWidget {
  const MiniAppStatsView({required this.app, super.key});
  final MiniApp app;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final state = context.watch<MiniAppStatsCubit>().state;
    return MiniAppScaffold(
      title: l10n.miniAppsStatsTitle,
      scrollingHeader: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.name,
                style: AppText.title.copyWith(color: colors.ink),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.miniAppsStatsRangeDays(state.range.days),
                style: AppText.subtext.copyWith(color: colors.muted),
              ),
            ],
          ),
        ),
        Padding(
          padding: const .fromLTRB(
            AppSpacing.screen,
            14,
            AppSpacing.screen,
            0,
          ),
          child: _RangeSelector(range: state.range),
        ),
      ],
      body: _StatsContent(app: app, state: state),
    );
  }
}
