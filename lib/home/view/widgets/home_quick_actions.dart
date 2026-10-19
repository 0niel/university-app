import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({
    required this.services,
    required this.onAll,
    this.loading = false,
    super.key,
  });
  final List<ServiceEntry> services;
  final VoidCallback onAll;
  final bool loading;

  @override
  Widget build(BuildContext context) => AppTourAnchor(
    target: .homeServices,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: context.l10n.homeSectionSmartChips,
          action: context.l10n.homeAllServices,
          onActionTap: onAll,
        ),
        if (services.isEmpty && loading)
          AppSkeletonGroup(
            semanticsLabel: context.l10n.loadingContent,
            child: AppShortcutGrid(
              children: List.generate(
                HomeServiceDefaults.routes.length,
                (_) => const AppServiceTile.skeleton(),
              ),
            ),
          )
        else if (services.isEmpty)
          AppEmptyState.compact(title: context.l10n.homeFavoritesEmpty)
        else
          AppShortcutGrid(
            children: [
              for (final entry in services)
                AppServiceTile.compact(
                  icon: AppLineIconWidget(entry.model.icon),
                  color: entry.tone ?? entry.model.color,
                  label: _shortTitle(entry, context.l10n),
                  semanticsLabel: entry.title,
                  onTap: () => entry.open(context),
                ),
            ],
          ),
      ],
    ),
  );

  String _shortTitle(ServiceEntry entry, AppLocalizations l10n) =>
      switch (entry.model.routePath) {
        '/services/map' => l10n.servicesMap,
        '/services/free-rooms' => l10n.classrooms,
        '/services/nfc' => l10n.homePass,
        '/schedule/session' => l10n.serviceExamsTitle,
        '/services/communities' => l10n.servicesSectionCommunity,
        _ => entry.title,
      };
}
