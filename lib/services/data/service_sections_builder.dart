import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/config/catalog_service_mapper.dart';
import 'package:rtu_mirea_app/services/config/services_config.dart';
import 'package:rtu_mirea_app/services/data/favorite_services_repository.dart';
import 'package:rtu_mirea_app/services/data/service_layout_repository.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:rtu_mirea_app/services/models/service_section.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

class ServiceSectionsBuilder {
  const ServiceSectionsBuilder({this.catalog, this.savedLayout});

  static const List<String> coreGroupKeys = [
    'important',
    'community',
    'main',
    'student-life',
    'useful',
  ];

  final ServiceCatalog? catalog;
  final Map<String, List<String>>? savedLayout;

  List<String> get groupKeys => [
    ...coreGroupKeys,
    for (final section in catalog?.sections ?? const <ServiceCatalogSection>[])
      if (!coreGroupKeys.contains(section.key)) section.key,
  ];

  List<ServiceSection> sections(BuildContext context) {
    final keys = groupKeys;
    final config = _config(context);
    final effective = _effectiveLayout(config.layout, keys);
    return [
      for (final key in keys)
        ServiceSection(
          key: key,
          title: _title(context, key),
          services: [
            for (final id in effective[key] ?? const <String>[])
              ?config.byId[id],
          ],
        ),
    ];
  }

  Map<String, List<String>>? moved(
    BuildContext context, {
    required String id,
    required String toKey,
    String? beforeId,
  }) {
    final keys = groupKeys;
    final effective = _effectiveLayout(_config(context).layout, keys);
    final next = {
      for (final entry in effective.entries) entry.key: [...entry.value],
    };
    for (final list in next.values) {
      list.remove(id);
    }
    final target = next[toKey];
    if (target == null) return null;
    final index = beforeId == null ? -1 : target.indexOf(beforeId);
    if (index < 0) {
      target.add(id);
    } else {
      target.insert(index, id);
    }
    return next;
  }

  Map<String, List<String>> _effectiveLayout(
    Map<String, List<String>> layout,
    List<String> keys,
  ) => ServiceLayoutRepository.merge(layout, savedLayout, keys);

  ({Map<String, List<String>> layout, Map<String, ServiceModel> byId}) _config(
    BuildContext context,
  ) {
    final keys = groupKeys;
    final byId = <String, ServiceModel>{};
    final layout = {for (final key in keys) key: <String>[]};
    final placed = <String>{};
    for (final key in keys) {
      for (final service in _servicesFor(context, key)) {
        final id = FavoriteServicesRepository.idOf(
          routePath: service.routePath,
          url: service.url,
        );
        if (id == null) continue;
        byId[id] = service;
        if (placed.add(id)) layout[key]?.add(id);
      }
    }
    return (layout: layout, byId: byId);
  }

  List<ServiceModel> _servicesFor(BuildContext context, String key) {
    final core = switch (key) {
      'important' => ServicesConfig.getImportantServices(
        context,
        context.read(),
      ),
      'community' => ServicesConfig.getCommunityServices(context),
      'main' => ServicesConfig.getMainServices(context),
      'student-life' => ServicesConfig.getStudentLifeServices(context),
      _ => ServicesConfig.getUsefulServices(
        context,
        context.read(),
      ),
    };
    return [
      ...core,
      for (final entry in _section(key)?.items ?? const <ServiceCatalogEntry>[])
        catalogServiceTile(context, entry),
    ];
  }

  String _title(BuildContext context, String key) {
    final catalogTitle = _section(key)?.title;
    if (catalogTitle != null) return catalogTitle;
    final l10n = context.l10n;
    return switch (key) {
      'important' => l10n.servicesSectionImportant,
      'community' => l10n.servicesSectionCommunity,
      'main' => l10n.servicesSectionMain,
      'student-life' => l10n.servicesSectionStudentLife,
      _ => l10n.servicesSectionUseful,
    };
  }

  ServiceCatalogSection? _section(String key) {
    for (final section
        in catalog?.sections ?? const <ServiceCatalogSection>[]) {
      if (section.key == key) return section;
    }
    return null;
  }
}
