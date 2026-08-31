import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:rtu_mirea_app/services/models/service_section.dart';
import 'package:rtu_mirea_app/services/view/services_drop_group.dart';
import 'package:rtu_mirea_app/services/view/services_section_label.dart';

class ServicesSectionGroup extends StatelessWidget {
  const ServicesSectionGroup({
    required this.section,
    required this.services,
    required this.draggable,
    required this.editMode,
    required this.onFavoriteCheck,
    required this.onServiceTap,
    required this.onMoveService,
    super.key,
  });

  final ServiceSection section;
  final List<ServiceModel> services;
  final bool draggable;
  final bool editMode;
  final bool Function(ServiceModel) onFavoriteCheck;
  final ValueChanged<ServiceModel> onServiceTap;
  final void Function(String id, String toKey, {String? beforeId})
  onMoveService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ServicesSectionLabel(title: section.title),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            16,
            NinjaMetrics.screenPadding,
            24,
          ),
          child: ServicesDropGroup(
            groupKey: section.key,
            services: services,
            draggable: draggable,
            editMode: editMode,
            onFavoriteCheck: onFavoriteCheck,
            onServiceTap: onServiceTap,
            onMoveService: onMoveService,
          ),
        ),
      ],
    );
  }
}
