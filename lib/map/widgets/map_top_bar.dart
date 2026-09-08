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
    this.compact = false,
    this.showCampusSelector = true,
    super.key,
  });

  final TextEditingController controller;
  final List<CampusModel> campuses;
  final CampusModel? selectedCampus;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CampusModel> onCampusSelected;
  final VoidCallback onFriends;
  final bool compact;
  final bool showCampusSelector;

  Future<void> _chooseCampus(BuildContext context) => showAppSheet<void>(
    context,
    title: 'Кампусы',
    child: AppListGroup(
      children: [
        for (final campus in campuses)
          AppListRow(
            title: campus.displayName,
            leading: const AppIconTile(icon: AppLineIcon.school),
            trailing: campus.id == selectedCampus?.id
                ? const AppLineIconWidget(AppLineIcon.check)
                : null,
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              if (campus.id != selectedCampus?.id) onCampusSelected(campus);
            },
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            controller: controller,
            hintText: l10n.mapSearchPlaceholder,
            onCanvas: true,
            trailingIcon: AppLineIcon.people,
            onTrailingTap: onFriends,
            trailingSemanticLabel: l10n.mapFriendsToggle,
            onChanged: onQueryChanged,
            onClear: () => onQueryChanged(''),
          ),
          if (showCampusSelector) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.secondary(
                label: selectedCampus?.displayName ?? 'Кампус',
                trailingIcon: const AppLineIconWidget(
                  AppLineIcon.chevronD,
                  size: 16,
                ),
                size: AppButtonSize.small,
                onPressed: campuses.isEmpty
                    ? null
                    : () => _chooseCampus(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
