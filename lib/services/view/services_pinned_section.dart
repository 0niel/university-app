import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_grid.dart';
import 'package:rtu_mirea_app/services/view/services_section_label.dart';

class ServicesPinnedSection extends StatelessWidget {
  const ServicesPinnedSection({
    required this.services,
    required this.editMode,
    required this.onServiceTap,
    super.key,
  });

  final List<ServiceModel> services;
  final bool editMode;
  final ValueChanged<ServiceModel> onServiceTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServicesSectionLabel(title: context.l10n.servicesSectionPinned),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NinjaMetrics.screenPadding,
            16,
            NinjaMetrics.screenPadding,
            24,
          ),
          child: services.isEmpty
              ? Text(
                  context.l10n.servicesPinnedEmptyHint,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                )
              : ServicesGrid(
                  services: services,
                  editMode: editMode,
                  onFavoriteCheck: (_) => true,
                  tileSize: ServiceTileSize.pinned,
                  onServiceTap: onServiceTap,
                ),
        ),
      ],
    );
  }
}
