import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

part 'campus_choice.dart';

class CampusSelector extends StatelessWidget {
  const CampusSelector({
    required this.campuses,
    required this.selectedCampus,
    required this.onCampusSelected,
    super.key,
  });

  final List<CampusModel> campuses;
  final CampusModel selectedCampus;
  final ValueChanged<CampusModel> onCampusSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        for (final (index, campus) in campuses.indexed) ...[
          if (index > 0) const SizedBox(height: 10),
          _CampusChoice(
            campus: campus,
            selected: campus.id == selectedCampus.id,
            onTap: () => onCampusSelected(campus),
          ),
        ],
      ],
    );
  }
}
