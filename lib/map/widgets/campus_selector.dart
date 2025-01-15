import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/map/map.dart';

class CampusSelector extends StatelessWidget {
  final List<CampusModel> campuses;
  final CampusModel selectedCampus;
  final Function(CampusModel) onCampusSelected;

  const CampusSelector({
    super.key,
    required this.campuses,
    required this.selectedCampus,
    required this.onCampusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.colorsOf(context).background02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.colorsOf(context).divider,
          width: 1,
        ),
      ),
      child: DropdownButton<CampusModel>(
        value: selectedCampus,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppTheme.colorsOf(context).active,
        ),
        style: AppTextStyle.bodyBold.copyWith(color: AppTheme.colorsOf(context).active),
        dropdownColor: AppTheme.colorsOf(context).background02,
        items: campuses.map((campus) {
          return DropdownMenuItem<CampusModel>(
            value: campus,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                campus.displayName,
                style: AppTextStyle.bodyBold.copyWith(color: AppTheme.colorsOf(context).active),
              ),
            ),
          );
        }).toList(),
        onChanged: (campus) {
          if (campus != null) {
            onCampusSelected(campus);
          }
        },
      ),
    );
  }
}
