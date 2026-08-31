import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/map_campus_section.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_switcher.dart';
import 'package:rtu_mirea_app/map/widgets/map_panel_header.dart';
import 'package:rtu_mirea_app/map/widgets/map_panel_layout.dart';

class MapLevelPanel extends StatelessWidget {
  const MapLevelPanel({
    required this.controller,
    required this.layout,
    required this.campuses,
    required this.selectedCampus,
    required this.selectedFloor,
    required this.onToggle,
    super.key,
  });

  final DraggableScrollableController controller;
  final MapPanelLayout layout;
  final List<CampusModel> campuses;
  final CampusModel selectedCampus;
  final FloorModel selectedFloor;
  final void Function(double compactExtent, double expandedExtent) onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final media = MediaQuery.of(context);
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: layout.collapsedExtent,
      minChildSize: layout.collapsedExtent,
      maxChildSize: layout.expandedExtent,
      snap: true,
      snapSizes: [layout.collapsedExtent, layout.expandedExtent],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const .vertical(
              top: Radius.circular(NinjaRadius.card),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: MapPanelHeader(
                  controller: controller,
                  collapsedExtent: layout.collapsedExtent,
                  expandedExtent: layout.expandedExtent,
                  campus: selectedCampus,
                  floor: selectedFloor,
                  onTap: () => onToggle(
                    layout.collapsedExtent,
                    layout.expandedExtent,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const .only(top: 12),
                  child: MapFloorSwitcher(
                    campus: selectedCampus,
                    selectedFloor: selectedFloor,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  NinjaMetrics.screenPadding,
                  28,
                  NinjaMetrics.screenPadding,
                  media.padding.bottom + 28,
                ),
                sliver: SliverToBoxAdapter(
                  child: MapCampusSection(
                    campuses: campuses,
                    selectedCampus: selectedCampus,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
