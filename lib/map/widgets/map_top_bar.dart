import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class MapTopBar extends StatelessWidget {
  const MapTopBar({
    required this.controller,
    required this.campuses,
    required this.selectedCampus,
    required this.onQueryChanged,
    required this.onCampusSelected,
    required this.onFriends,
    super.key,
  });

  final TextEditingController controller;
  final List<CampusModel> campuses;
  final CampusModel? selectedCampus;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CampusModel> onCampusSelected;
  final VoidCallback onFriends;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        top: math.max(56, MediaQuery.paddingOf(context).top + 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: AppSearchField(
              controller: controller,
              hintText: l10n.mapSearchPlaceholder,
              onCanvas: true,
              onChanged: onQueryChanged,
              onClear: () => onQueryChanged(''),
              trailing: AppIconButton(
                icon: const AppLineIconWidget(AppLineIcon.people, size: 18),
                shape: AppIconButtonShape.circle,
                size: AppIconButtonSize.small,
                tone: AppIconButtonTone.primary,
                tooltip: l10n.mapFriendsToggle,
                onPressed: onFriends,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Row(
              children: [
                for (var index = 0; index < campuses.length; index++) ...[
                  if (index > 0) const SizedBox(width: 6),
                  AppChip.filter(
                    label: campuses[index].displayName,
                    selected: selectedCampus?.id == campuses[index].id,
                    onTap: () => onCampusSelected(campuses[index]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
