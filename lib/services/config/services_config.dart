import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

abstract final class ServicesConfig {
  static List<ServiceModel> _models(Iterable<ServiceEntry> entries) => [
    for (final entry in entries) entry.model,
  ];

  static List<ServiceModel> getImportantServices(
    BuildContext context,
    UniversityConfig config,
  ) => _models(
    ServicesDirectory.campus(context, config).where(
      (entry) =>
          entry.model.routePath == '/services/map' ||
          entry.model.routePath == '/services/nfc',
    ),
  );

  static List<ServiceModel> getCommunityServices(BuildContext context) =>
      _models(ServicesDirectory.community(context));

  static List<ServiceModel> getMainServices(BuildContext context) =>
      _models(ServicesDirectory.study(context));

  static List<ServiceModel> getStudentLifeServices(BuildContext context) =>
      _models(ServicesDirectory.studentLife(context));

  static List<ServiceModel> getUsefulServices(
    BuildContext context,
    UniversityConfig config,
  ) => _models(ServicesDirectory.useful(context, config));

  static const List<String> _homeDefaults = [
    '/services/map',
    '/services/nfc',
    '/services/free-rooms',
    '/services/deadlines',
    '/schedule/session',
    '/services/collab-notes',
    '/services/tools',
    '/services/knowledge-bank',
    '/services/communities',
    '/services/events',
  ];

  static List<ServiceModel> getHomeServices(
    BuildContext context,
    UniversityConfig config,
  ) {
    final all = ServicesDirectory.all(context, config);
    return [
      for (final path in _homeDefaults)
        for (final entry in all)
          if (entry.model.routePath == path) entry.model,
    ];
  }

  static List<ServiceModel> getAllBuiltInServices(
    BuildContext context,
    UniversityConfig config,
  ) => _models(ServicesDirectory.all(context, config));
}
