import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

abstract final class PreviewServiceFixtures {
  static ServiceEntry _entry(
    BuildContext context, {
    required String title,
    required String subtitle,
    required AppLineIcon icon,
    required String path,
    Color? color,
  }) => ServiceEntry(
    model: ServiceModel(
      title: title,
      icon: icon,
      color: color ?? context.colors.accent,
      isExternal: false,
      routePath: path,
    ),
    subtitle: subtitle,
    tone: color ?? context.colors.accent,
  );

  static ServiceEntry feature(BuildContext context) => _entry(
    context,
    title: context.l10n.miniAppsTitle,
    subtitle: context.l10n.serviceAppsSub,
    icon: AppLineIcon.grid,
    path: '/services/apps',
  );

  static List<ServiceSectionEntries> sections(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return [
      ServiceSectionEntries(
        key: 'campus',
        title: l10n.servicesSectionCampus,
        entries: [
          _entry(
            context,
            title: l10n.campusMap,
            subtitle: l10n.serviceMapSub,
            icon: AppLineIcon.map,
            path: '/services/map',
          ),
          _entry(
            context,
            title: l10n.freeClassrooms,
            subtitle: l10n.serviceRoomsSub,
            icon: AppLineIcon.door,
            path: '/services/free-rooms',
            color: colors.lecture,
          ),
        ],
      ),
      ServiceSectionEntries(
        key: 'study',
        title: l10n.servicesSectionStudy,
        entries: [
          _entry(
            context,
            title: l10n.homeDeadlines,
            subtitle: l10n.serviceDeadlinesSub,
            icon: AppLineIcon.clock,
            path: '/services/deadlines',
            color: colors.exam,
          ),
          _entry(
            context,
            title: l10n.servicesNotes,
            subtitle: l10n.serviceNotesSub,
            icon: AppLineIcon.pencil,
            path: '/services/collab-notes',
            color: colors.lab,
          ),
          _entry(
            context,
            title: l10n.serviceExamsTitle,
            subtitle: l10n.serviceExamsSub,
            icon: AppLineIcon.calendar,
            path: '/schedule/session',
            color: colors.lecture,
          ),
          _entry(
            context,
            title: l10n.servicesKnowledgeBank,
            subtitle: l10n.serviceKbSub,
            icon: AppLineIcon.book,
            path: '/services/knowledge-bank',
            color: colors.practice,
          ),
        ],
      ),
      ServiceSectionEntries(
        key: 'community',
        title: l10n.servicesSectionCommunity,
        entries: [
          _entry(
            context,
            title: l10n.friendsTitle,
            subtitle: l10n.serviceFriendsSub,
            icon: AppLineIcon.people,
            path: '/services/friends',
            color: colors.lecture,
          ),
          _entry(
            context,
            title: l10n.navProfile,
            subtitle: l10n.profileAchievements,
            icon: AppLineIcon.user,
            path: '/profile',
          ),
        ],
      ),
    ];
  }
}
