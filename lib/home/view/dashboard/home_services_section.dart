import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_services_rail.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({
    required this.config,
    required this.catalog,
    super.key,
  });

  final UniversityConfig config;
  final ServiceCatalog? catalog;

  @override
  Widget build(BuildContext context) {
    return AppTourAnchor(
      target: .homeServices,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          HomeSectionHeader(
            title: context.l10n.services,
            action: context.l10n.all,
            onAction: () => context.go('/services'),
          ),
          HomeServicesRail(
            key: const ValueKey('home-services'),
            config: config,
            catalog: catalog,
          ),
        ],
      ),
    );
  }
}
