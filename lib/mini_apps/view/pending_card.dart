part of 'mini_apps_moderation_page.dart';

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.app, required this.processing});

  final MiniApp app;
  final bool processing;

  Future<void> _decide(
    BuildContext context,
    MiniAppModerationAction action,
  ) async {
    final cubit = context.read<MiniAppsModerationCubit>();
    final notes = await _askNotes(
      context,
      action == .approve
          ? context.l10n.miniAppsApprove
          : context.l10n.miniAppsRejectAction,
    );
    if (notes == null) return;
    await cubit.moderate(app, action, notes: notes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.gap,
      ),
      child: Column(
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
              spacing: 8,
              children: [
                if (app.sourceKind == .hosted)
                  NinjaButton.outline(
                    label: '${l10n.miniAppsRevTitle} · v${app.version}',
                    size: .small,
                    expanded: true,
                    onPressed: () => unawaited(
                      showAppSheet<void>(
                        context,
                        title: l10n.miniAppsRevTitle,
                        subtitle: l10n.miniAppsRevSubtitle,
                        child: MiniAppRevisionsSheet(
                          app: app,
                          repository: context.read(),
                        ),
                      ),
                    ),
                  ),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: NinjaButton.primary(
                        label: l10n.miniAppsApprove,
                        size: .small,
                        expanded: true,
                        onPressed: processing
                            ? null
                            : () => unawaited(_decide(context, .approve)),
                      ),
                    ),
                    Expanded(
                      child: NinjaButton.destructive(
                        label: l10n.miniAppsRejectAction,
                        size: .small,
                        expanded: true,
                        onPressed: processing
                            ? null
                            : () => unawaited(_decide(context, .reject)),
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
