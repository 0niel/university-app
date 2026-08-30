part of 'mini_apps_moderation_page.dart';

class _ReportedCard extends StatelessWidget {
  const _ReportedCard({required this.reported, required this.processing});

  final ReportedMiniApp reported;
  final bool processing;

  Future<void> _suspend(BuildContext context) async {
    final cubit = context.read<MiniAppsModerationCubit>();
    final notes = await _askNotes(context, context.l10n.miniAppsSuspend);
    if (notes == null) return;
    final suspended = await cubit.moderate(
      reported.app,
      .suspend,
      notes: notes,
    );
    if (suspended) await cubit.resolveReports(reported.app, notes: notes);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final cubit = context.read<MiniAppsModerationCubit>();
    final app = reported.app;
    final suspended = app.status == .suspended;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          MiniAppCard(
            app: app,
            showStatus: true,
            onTap: () => context.go('/services/apps/${app.slug}/run'),
          ),
          Padding(
            padding: const .fromLTRB(
              0,
              10,
              0,
              14,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                for (final report in reported.reports.take(3))
                  Text(
                    '${miniAppReportReasonLabel(context, report.reason)}'
                    '${report.details.isEmpty ? '' : ' — ${report.details}'}',
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: NinjaText.helper.copyWith(color: colors.muted),
                  ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: NinjaButton.secondary(
                        label: l10n.miniAppsDismissReports,
                        size: .small,
                        expanded: true,
                        onPressed: processing
                            ? null
                            : () => unawaited(
                                cubit.resolveReports(app, dismiss: true),
                              ),
                      ),
                    ),
                    Expanded(
                      child: suspended
                          ? NinjaButton.primary(
                              label: l10n.miniAppsRestore,
                              size: .small,
                              expanded: true,
                              onPressed: processing
                                  ? null
                                  : () => unawaited(
                                      cubit.moderate(app, .restore),
                                    ),
                            )
                          : NinjaButton.destructive(
                              label: l10n.miniAppsSuspend,
                              size: .small,
                              expanded: true,
                              onPressed: processing
                                  ? null
                                  : () => unawaited(_suspend(context)),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
