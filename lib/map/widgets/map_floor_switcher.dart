import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

part 'floor_choice.dart';

class MapFloorSwitcher extends StatelessWidget {
  const MapFloorSwitcher({
    required this.campus,
    required this.selectedFloor,
    super.key,
  });

  final CampusModel campus;
  final FloorModel selectedFloor;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.mapFloorSelection,
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            borderRadius: .circular(NinjaRadius.pill),
          ),
          child: Padding(
            padding: const .all(4),
            child: Row(
              children: [
                for (var index = 0; index < campus.floors.length; index++)
                  _FloorChoice(
                    floor: campus.floors[index],
                    selected: campus.floors[index].id == selectedFloor.id,
                    semanticLabel: l10n.mapFloorNumber(
                      campus.floors[index].number,
                    ),
                    onTap: () => context.read<MapBloc>().add(
                      MapEvent.floorSelected(
                        floor: campus.floors[index],
                        campus: campus,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
