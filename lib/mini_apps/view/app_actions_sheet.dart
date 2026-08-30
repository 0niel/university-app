part of 'mini_apps_page.dart';

class _AppActionsSheet extends StatelessWidget {
  const _AppActionsSheet({required this.app});

  final MiniApp app;

  Future<void> _report(BuildContext context) async {
    final cubit = context.read<MiniAppsCatalogCubit>();
    Navigator.of(context).pop();
    final sent = await showAppSheet<bool>(
      context,
      title: context.l10n.miniAppsReportTitle,
      subtitle: context.l10n.miniAppsReportSubtitle,
      child: MiniAppReportSheet(
        onSubmit: (reason, details) => cubit.report(app, reason, details),
      ),
    );
    if (sent == true && context.mounted) {
      showNinjaToast(context, message: context.l10n.miniAppsReportSent);
    }
  }

  Future<void> _about(BuildContext context) async {
    final cubit = context.read<MiniAppsCatalogCubit>();
    Navigator.of(context).pop();
    await showAppSheet<void>(
      context,
      title: app.name,
      child: MiniAppAboutSheet(
        app: app,
        onRate: (rating) => cubit.rate(app, rating),
        onPermissionsChanged: (scopes) => cubit.setConsents(app, scopes),
      ),
    );
  }

  void _openStats(BuildContext context) {
    final repository = context.read<MiniAppsRepository>();
    Navigator.of(context).pop();
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MiniAppStatsPage(app: app, repository: repository),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MiniAppsCatalogCubit>();
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      children: [
        _MiniAppActionTile(
          title: l10n.miniAppsOpen,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/services/apps/${app.slug}/run');
          },
        ),
        _MiniAppActionTile(
          title: l10n.miniAppsAbout,
          onTap: () => unawaited(_about(context)),
        ),
        _MiniAppActionTile(
          title: l10n.miniAppsStatsTitle,
          onTap: () => _openStats(context),
        ),
        if (!app.isOwner) ...[
          _MiniAppActionTile(
            title: app.isHidden ? l10n.miniAppsUnhide : l10n.miniAppsHide,
            onTap: () {
              unawaited(cubit.setHidden(app, hidden: !app.isHidden));
              Navigator.of(context).pop();
            },
          ),
          _MiniAppActionTile(
            title: app.hasMyOpenReport
                ? l10n.miniAppsAlreadyReported
                : l10n.miniAppsReport,
            onTap: app.hasMyOpenReport
                ? null
                : () => unawaited(_report(context)),
          ),
        ],
        if (app.isOwner) ...[
          if (app.sourceKind == .hosted)
            _MiniAppActionTile(
              title: l10n.miniAppsRevTitle,
              onTap: () => unawaited(_openRevisions(context, canRestore: true)),
            ),
          _MiniAppActionTile(
            title: l10n.miniAppsTokensTitle,
            onTap: () {
              final repository = context.read<MiniAppsRepository>();
              Navigator.of(context).pop();
              unawaited(
                showAppSheet<void>(
                  context,
                  title: l10n.miniAppsTokensTitle,
                  subtitle: l10n.miniAppsTokensSubtitle,
                  child: MiniAppTokensSheet(repository: repository),
                ),
              );
            },
          ),
          if (app.sourceKind == .remote)
            _MiniAppActionTile(
              title: l10n.miniAppsSecretTitle,
              onTap: () {
                final repository = context.read<MiniAppsRepository>();
                Navigator.of(context).pop();
                unawaited(
                  showAppSheet<void>(
                    context,
                    title: l10n.miniAppsSecretTitle,
                    subtitle: l10n.miniAppsSecretSubtitle,
                    child: MiniAppSecretSheet(
                      repository: repository,
                      appId: app.id,
                    ),
                  ),
                );
              },
            ),
          _MiniAppActionTile(
            title: l10n.miniAppsDelete,
            titleColor: context.ninja.scarlet,
            onTap: () {
              unawaited(cubit.deleteMyApp(app));
              Navigator.of(context).pop();
            },
          ),
        ],
        if (cubit.state.isModerator && app.status == .published)
          _MiniAppActionTile(
            title: app.isFeatured
                ? l10n.miniAppsUnfeature
                : l10n.miniAppsFeature,
            onTap: () {
              unawaited(cubit.toggleFeatured(app));
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }

  Future<void> _openRevisions(
    BuildContext context, {
    required bool canRestore,
  }) async {
    final repository = context.read<MiniAppsRepository>();
    Navigator.of(context).pop();
    final restored = await showAppSheet<bool>(
      context,
      title: context.l10n.miniAppsRevTitle,
      subtitle: context.l10n.miniAppsRevSubtitle,
      child: MiniAppRevisionsSheet(
        app: app,
        repository: repository,
        canRestore: canRestore,
      ),
    );
    if (restored != true || !context.mounted) return;
    unawaited(context.read<MiniAppsCatalogCubit>().load());
  }
}
