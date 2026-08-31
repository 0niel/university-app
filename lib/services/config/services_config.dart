import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

abstract final class ServicesConfig {
  static Color _accent(NinjaColors colors, int index) =>
      colors.mireaAccentPalette.elementAtOrNull(
        index % colors.mireaAccentPalette.length,
      ) ??
      colors.brand;

  static List<ServiceModel> getImportantServices(
    BuildContext context,
    UniversityConfig config,
  ) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return [
      if (config.isEnabled(.campusMap))
        ServiceModel(
          title: l10n.campusMap,
          icon: AppLineIcon.map,
          color: _accent(colors, 5),
          isExternal: false,
          routePath: '/services/map',
        ),
      if (config.isEnabled(.nfcPass))
        ServiceModel(
          title: l10n.nfcPass,
          icon: AppLineIcon.contactless,
          color: _accent(colors, 3),
          isExternal: false,
          routePath: '/services/nfc',
        ),
    ];
  }

  static List<ServiceModel> getCommunityServices(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return [
      ServiceModel(
        title: l10n.communitiesTitle,
        icon: AppLineIcon.message,
        color: _accent(colors, 0),
        isExternal: false,
        routePath: '/services/communities',
      ),
      ServiceModel(
        title: l10n.homePeople,
        icon: AppLineIcon.people,
        color: _accent(colors, 5),
        isExternal: false,
        routePath: '/services/people',
      ),
      ServiceModel(
        title: l10n.servicesFriendsMap,
        icon: AppLineIcon.pin,
        color: _accent(colors, 6),
        isExternal: false,
        routePath: '/services/friends-map',
      ),
      ServiceModel(
        title: l10n.servicesKnowledgeBank,
        icon: AppLineIcon.book,
        color: _accent(colors, 3),
        isExternal: false,
        routePath: '/services/knowledge-bank',
      ),
      ServiceModel(
        title: l10n.servicesTeamFinder,
        icon: AppLineIcon.people,
        color: _accent(colors, 1),
        isExternal: false,
        routePath: '/services/team-finder',
      ),
      ServiceModel(
        title: l10n.servicesMentorship,
        icon: AppLineIcon.book,
        color: _accent(colors, 4),
        isExternal: false,
        routePath: '/services/mentorship',
      ),
      ServiceModel(
        title: l10n.pollsServiceTitle,
        icon: AppLineIcon.chart,
        color: _accent(colors, 2),
        isExternal: false,
        routePath: '/services/polls',
      ),
    ];
  }

  static List<ServiceModel> getMainServices(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return [
      ServiceModel(
        title: l10n.scheduleAppBarTitle,
        icon: AppLineIcon.calendar,
        color: _accent(colors, 5),
        isExternal: false,
        routePath: '/schedule',
      ),
      ServiceModel(
        title: l10n.freeClassrooms,
        icon: AppLineIcon.door,
        color: _accent(colors, 1),
        isExternal: false,
        routePath: '/services/free-rooms',
      ),
      ServiceModel(
        title: l10n.homeDeadlines,
        icon: AppLineIcon.clock,
        color: _accent(colors, 2),
        isExternal: false,
        routePath: '/services/deadlines',
      ),
      ServiceModel(
        title: l10n.servicesNotes,
        icon: AppLineIcon.pencil,
        color: _accent(colors, 0),
        isExternal: false,
        routePath: '/services/collab-notes',
      ),
      ServiceModel(
        title: l10n.toolsServiceTitle,
        icon: AppLineIcon.grid,
        color: _accent(colors, 7),
        isExternal: false,
        routePath: '/services/tools',
      ),
    ];
  }

  static List<ServiceModel> getStudentLifeServices(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return [
      ServiceModel(
        title: l10n.servicesEvents,
        icon: AppLineIcon.spark,
        color: _accent(colors, 4),
        isExternal: false,
        routePath: '/services/events',
      ),
      ServiceModel(
        title: l10n.servicesMarketplace,
        icon: AppLineIcon.bag,
        color: _accent(colors, 1),
        isExternal: false,
        routePath: '/services/marketplace',
      ),
      ServiceModel(
        title: l10n.lostFoundTitle,
        icon: AppLineIcon.search,
        color: _accent(colors, 2),
        isExternal: false,
        routePath: '/services/lost-and-found',
      ),
      ServiceModel(
        title: l10n.servicesWallet,
        icon: AppLineIcon.card,
        color: _accent(colors, 6),
        isExternal: false,
        routePath: '/services/wallet',
      ),
    ];
  }

  static List<ServiceModel> getUsefulServices(
    BuildContext context,
    UniversityConfig config,
  ) {
    final colors = context.ninja;
    final l10n = context.l10n;

    return [
      ServiceModel(
        title: l10n.miniAppsTitle,
        icon: AppLineIcon.grid,
        color: _accent(colors, 0),
        isExternal: false,
        routePath: '/services/apps',
      ),
      if (config.isEnabled(.virtualTour))
        ServiceModel(
          title: l10n.virtualTour,
          icon: AppLineIcon.globe,
          color: _accent(colors, 5),
          url: Uri.parse(
            config.websiteUrl,
          ).resolve('/mediapage/a-virtual-tour-of-the-university/').toString(),
        ),
    ];
  }

  static List<ServiceModel> getHomeServices(
    BuildContext context,
    UniversityConfig config,
  ) {
    return [
      ...getImportantServices(context, config),
      ...getMainServices(context).where(
        (service) => service.routePath != '/schedule',
      ),
      ...getCommunityServices(context).where(
        (service) =>
            service.routePath == '/services/knowledge-bank' ||
            service.routePath == '/services/communities',
      ),
      ...getStudentLifeServices(context).where(
        (service) => service.routePath == '/services/events',
      ),
    ];
  }

  static List<ServiceModel> getAllBuiltInServices(
    BuildContext context,
    UniversityConfig config,
  ) => [
    ...getImportantServices(context, config),
    ...getMainServices(context),
    ...getStudentLifeServices(context),
    ...getCommunityServices(context),
    ...getUsefulServices(context, config),
  ];
}
