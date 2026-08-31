import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/widgets/campus_selector.dart';

class MapCampusSection extends StatelessWidget {
  const MapCampusSection({
    required this.campuses,
    required this.selectedCampus,
    super.key,
  });

  final List<CampusModel> campuses;
  final CampusModel selectedCampus;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          l10n.mapBuildingLabel,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.mapChangeBuildingHint,
          style: NinjaText.subtext.copyWith(color: colors.mutedDark),
        ),
        const SizedBox(height: 12),
        CampusSelector(
          campuses: campuses,
          selectedCampus: selectedCampus,
          onCampusSelected: (campus) => context.read<MapBloc>().add(
            MapEvent.campusSelected(campus),
          ),
        ),
      ],
    );
  }
}
