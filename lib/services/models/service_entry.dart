import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/services/data/favorite_services_repository.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServiceEntry {
  const ServiceEntry({
    required this.model,
    required this.subtitle,
    this.tone,
  });

  final ServiceModel model;
  final String subtitle;
  final Color? tone;

  String get title => model.title;

  String get id =>
      FavoriteServicesRepository.idOf(
        routePath: model.routePath,
        url: model.url,
      ) ??
      model.title;

  void open(BuildContext context) {
    if (model.isExternal) {
      final url = model.url;
      if (url != null) {
        unawaited(launchUrlString(url, mode: LaunchMode.externalApplication));
      }
      return;
    }
    final routePath = model.routePath;
    if (routePath != null) context.go(routePath);
  }
}

class ServiceSectionEntries {
  const ServiceSectionEntries({
    required this.key,
    required this.title,
    required this.entries,
  });

  final String key;
  final String title;
  final List<ServiceEntry> entries;
}
