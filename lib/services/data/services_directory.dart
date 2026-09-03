import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/config/catalog_service_mapper.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

abstract final class ServicesDirectory {
  static const sectionFirstParty = 'first-party';
  static const sectionCampus = 'campus';
  static const sectionStudy = 'study';
  static const sectionCommunity = 'community';
  static const sectionStudentLife = 'student-life';
  static const sectionUseful = 'useful';

  static List<ServiceEntry> _unique(Iterable<ServiceEntry> entries) {
    final seen = <String>{};
    return [
      for (final entry in entries)
        if (seen.add(entry.id)) entry,
    ];
  }

  static ServiceEntry _entry(
    BuildContext context, {
    required String title,
    required String subtitle,
    required AppLineIcon icon,
    Color? tone,
    String? routePath,
    String? url,
  }) => ServiceEntry(
    model: ServiceModel(
      title: title,
      icon: icon,
      color: tone ?? context.colors.ink,
      isExternal: routePath == null,
      routePath: routePath,
      url: url,
    ),
    subtitle: subtitle,
    tone: tone,
  );

  static List<ServiceEntry> campus(
    BuildContext context,
    UniversityConfig config,
  ) {
    final colors = context.colors;
    final l10n = context.l10n;
    return [
      if (config.isEnabled(.campusMap))
        _entry(
          context,
          title: l10n.campusMap,
          subtitle: l10n.serviceMapSub,
          icon: AppLineIcon.map,
          tone: colors.practice,
          routePath: '/services/map',
        ),
      _entry(
        context,
        title: l10n.freeClassrooms,
        subtitle: l10n.serviceRoomsSub,
        icon: AppLineIcon.door,
        tone: colors.lecture,
        routePath: '/services/free-rooms',
      ),
      _entry(
        context,
        title: l10n.coworkTitle,
        subtitle: l10n.serviceCoworkSub,
        icon: AppLineIcon.device,
        tone: colors.lab,
        routePath: '/services/cowork',
      ),
      if (config.isEnabled(.nfcPass))
        _entry(
          context,
          title: l10n.serviceNfcTitle,
          subtitle: l10n.serviceNfcSub,
          icon: AppLineIcon.contactless,
          tone: colors.practice,
          routePath: '/services/nfc',
        ),
    ];
  }

  static List<ServiceEntry> study(BuildContext context, {int? examDays}) {
    final colors = context.colors;
    final l10n = context.l10n;
    return [
      _entry(
        context,
        title: l10n.homeDeadlines,
        subtitle: l10n.serviceDeadlinesSub,
        icon: AppLineIcon.clock,
        tone: colors.exam,
        routePath: '/services/deadlines',
      ),
      _entry(
        context,
        title: l10n.serviceExamsTitle,
        subtitle: examDays == null
            ? l10n.serviceExamsSub
            : l10n.serviceExamsInDays(examDays),
        icon: AppLineIcon.clipboard,
        tone: colors.exam,
        routePath: '/schedule/session',
      ),
      _entry(
        context,
        title: l10n.servicesNotes,
        subtitle: l10n.serviceNotesSub,
        icon: AppLineIcon.pencil,
        tone: colors.lab,
        routePath: '/services/collab-notes',
      ),
      _entry(
        context,
        title: l10n.servicesKnowledgeBank,
        subtitle: l10n.serviceKbSub,
        icon: AppLineIcon.book,
        tone: colors.lecture,
        routePath: '/services/knowledge-bank',
      ),
      _entry(
        context,
        title: l10n.toolsPageTitle,
        subtitle: l10n.serviceToolsSub,
        icon: AppLineIcon.grid,
        routePath: '/services/tools',
      ),
    ];
  }

  static List<ServiceEntry> community(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return [
      _entry(
        context,
        title: l10n.news,
        subtitle: l10n.serviceNewsSub,
        icon: AppLineIcon.inbox,
        tone: colors.practice,
        routePath: '/feed/news',
      ),
      _entry(
        context,
        title: l10n.communitiesTitle,
        subtitle: l10n.serviceCommunitiesSub,
        icon: AppLineIcon.message,
        tone: colors.lab,
        routePath: '/services/communities',
      ),
      _entry(
        context,
        title: l10n.friendsTitle,
        subtitle: l10n.serviceFriendsSub,
        icon: AppLineIcon.people,
        tone: colors.lecture,
        routePath: '/services/friends',
      ),
      _entry(
        context,
        title: l10n.pollsServiceTitle,
        subtitle: l10n.servicePollsSub,
        icon: AppLineIcon.chart,
        routePath: '/services/polls',
      ),
      _entry(
        context,
        title: l10n.homePeople,
        subtitle: l10n.servicePeopleSub,
        icon: AppLineIcon.people,
        tone: colors.lecture,
        routePath: '/services/people',
      ),
      _entry(
        context,
        title: l10n.servicesFriendsMap,
        subtitle: l10n.serviceFriendsMapSub,
        icon: AppLineIcon.pin,
        tone: colors.lecture,
        routePath: '/services/friends-map',
      ),
      _entry(
        context,
        title: l10n.servicesTeamFinder,
        subtitle: l10n.serviceTeamFinderSub,
        icon: AppLineIcon.people,
        tone: colors.lab,
        routePath: '/services/team-finder',
      ),
      _entry(
        context,
        title: l10n.servicesMentorship,
        subtitle: l10n.serviceMentorshipSub,
        icon: AppLineIcon.book,
        tone: colors.practice,
        routePath: '/services/mentorship',
      ),
    ];
  }

  static List<ServiceEntry> studentLife(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return [
      _entry(
        context,
        title: l10n.servicesEvents,
        subtitle: l10n.serviceEventsSub,
        icon: AppLineIcon.spark,
        tone: colors.exam,
        routePath: '/services/events',
      ),
      _entry(
        context,
        title: l10n.serviceMarketTitle,
        subtitle: l10n.serviceMarketSub,
        icon: AppLineIcon.bag,
        tone: colors.lecture,
        routePath: '/services/marketplace',
      ),
      _entry(
        context,
        title: l10n.lostFoundTitle,
        subtitle: l10n.serviceLostSub,
        icon: AppLineIcon.search,
        tone: colors.practice,
        routePath: '/services/lost-and-found',
      ),
      _entry(
        context,
        title: l10n.walletTitle,
        subtitle: l10n.serviceWalletSub,
        icon: AppLineIcon.card,
        tone: colors.lab,
        routePath: '/services/wallet',
      ),
    ];
  }

  static List<ServiceEntry> useful(
    BuildContext context,
    UniversityConfig config,
  ) {
    final colors = context.colors;
    final l10n = context.l10n;
    return [
      _entry(
        context,
        title: l10n.miniAppsTitle,
        subtitle: l10n.serviceAppsSub,
        icon: AppLineIcon.grid,
        routePath: '/services/apps',
      ),
      if (config.isEnabled(.virtualTour))
        _entry(
          context,
          title: l10n.virtualTour,
          subtitle: l10n.serviceVirtualTourSub,
          icon: AppLineIcon.globe,
          tone: colors.practice,
          url: Uri.parse(
            config.websiteUrl,
          ).resolve('/mediapage/a-virtual-tour-of-the-university/').toString(),
        ),
    ];
  }

  static List<ServiceEntry> all(BuildContext context, UniversityConfig config) {
    final seen = <String>{};
    return [
      for (final entry in [
        ...campus(context, config),
        ...study(context),
        ...community(context),
        ...studentLife(context),
        ...useful(context, config),
      ])
        if (seen.add(entry.id)) entry,
    ];
  }

  static List<ServiceSectionEntries> sections(
    BuildContext context, {
    required UniversityConfig config,
    ServiceCatalog? catalog,
    int? examDays,
  }) {
    final l10n = context.l10n;
    const featuredRoutes = [
      '/services/apps',
      '/services/deadlines',
      '/services/events',
      '/services/mentorship',
      '/services/team-finder',
    ];
    final owned = [
      ...useful(context, config),
      ...study(context, examDays: examDays),
      ...community(context),
      ...studentLife(context),
    ];
    final builtIn = [
      ServiceSectionEntries(
        key: sectionFirstParty,
        title: l10n.servicesSectionFirstParty,
        entries: [
          for (final route in featuredRoutes)
            for (final entry in owned)
              if (entry.model.routePath == route) entry,
        ],
      ),
      ServiceSectionEntries(
        key: sectionCampus,
        title: l10n.servicesSectionCampus,
        entries: campus(context, config),
      ),
      ServiceSectionEntries(
        key: sectionStudy,
        title: l10n.servicesSectionStudy,
        entries: study(context, examDays: examDays)
            .where((entry) => !featuredRoutes.contains(entry.model.routePath))
            .toList(),
      ),
      ServiceSectionEntries(
        key: sectionCommunity,
        title: l10n.servicesSectionCommunity,
        entries: community(context)
            .where((entry) => !featuredRoutes.contains(entry.model.routePath))
            .toList(),
      ),
      ServiceSectionEntries(
        key: sectionStudentLife,
        title: l10n.servicesSectionStudentLife,
        entries: studentLife(context)
            .where((entry) => !featuredRoutes.contains(entry.model.routePath))
            .toList(),
      ),
      ServiceSectionEntries(
        key: sectionUseful,
        title: l10n.servicesSectionUseful,
        entries: useful(context, config)
            .where((entry) => !featuredRoutes.contains(entry.model.routePath))
            .toList(),
      ),
    ];
    final remote = [...?catalog?.sections]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final byKey = {for (final section in builtIn) section.key: section};
    final extra = <ServiceSectionEntries>[];
    for (final section in remote) {
      final entries = [
        for (final item in [
          ...section.items,
        ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)))
          catalogServiceEntry(context, item),
      ];
      if (entries.isEmpty) continue;
      final target = byKey[section.key];
      if (target != null) {
        byKey[section.key] = ServiceSectionEntries(
          key: target.key,
          title: target.title,
          entries: _unique([...target.entries, ...entries]),
        );
      } else {
        extra.add(
          ServiceSectionEntries(
            key: section.key,
            title: section.title,
            entries: _unique(entries),
          ),
        );
      }
    }
    return [
      for (final section in builtIn)
        if (byKey[section.key]!.entries.isNotEmpty) byKey[section.key]!,
      ...extra,
    ];
  }
}
