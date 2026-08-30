import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_quick_action.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

class HomeServicesRail extends StatelessWidget {
  const HomeServicesRail({
    required this.config,
    super.key,
    this.catalog,
  });

  final UniversityConfig config;
  final ServiceCatalog? catalog;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteServicesCubit>().state;
    final all = [
      ...ServicesConfig.getAllBuiltInServices(context, config),
      for (final section
          in catalog?.sections ?? const <ServiceCatalogSection>[])
        for (final entry in section.items) catalogServiceTile(context, entry),
    ];
    final defaults = ServicesConfig.getHomeServices(context, config);
    final services = homeServiceSelection(
      all: all,
      defaults: defaults,
      favoriteIds: favorites.ids,
    );
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return SizedBox(
      height: textScale >= 1.6 ? 132 : 108,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = ((constraints.maxWidth - 28) / 3.55)
              .clamp(86, 108)
              .toDouble();
          return ListView.separated(
            key: const ValueKey('home-services-rail'),
            padding: EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              6,
              NinjaMetrics.screenPadding + width * 0.28,
              6,
            ),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: services.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final service = services[index];
              return SizedBox(
                width: width,
                child: HomeQuickAction(
                  icon: service.icon,
                  color: service.color,
                  label: service.title,
                  onTap: () => ServiceUtils.navigateToService(context, service),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

List<ServiceModel> homeServiceSelection({
  required List<ServiceModel> all,
  required List<ServiceModel> defaults,
  required Set<String> favoriteIds,
}) {
  final selected = <ServiceModel>[];
  final seen = <String>{};
  void add(ServiceModel service) {
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    if (id != null && seen.add(id)) selected.add(service);
  }

  for (final service in all) {
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    if (id != null && favoriteIds.contains(id)) add(service);
  }
  for (final service in defaults) {
    if (selected.length >= 7) break;
    add(service);
  }
  return selected.take(7).toList(growable: false);
}
