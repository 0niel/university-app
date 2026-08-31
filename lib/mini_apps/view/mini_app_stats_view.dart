part of 'mini_app_stats_page.dart';

class MiniAppStatsView extends StatelessWidget {
  const MiniAppStatsView({required this.app, super.key});
  final MiniApp app;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final state = context.watch<MiniAppStatsCubit>().state;
    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NinjaAppBar.inner(
        title: l10n.miniAppsStatsTitle,
        onBack: () => Navigator.of(context).maybePop(),
        backSemanticLabel: l10n.back,
      ),
      body: Column(
        crossAxisAlignment: .stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: NinjaText.title.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.miniAppsStatsRangeDays(state.range.days),
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const .fromLTRB(
              NinjaMetrics.screenPadding,
              14,
              NinjaMetrics.screenPadding,
              0,
            ),
            child: _RangeSelector(range: state.range),
          ),
          Expanded(
            child: _StatsContent(app: app, state: state),
          ),
        ],
      ),
    );
  }
}
