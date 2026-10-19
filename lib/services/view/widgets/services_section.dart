import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/view/widgets/services_grid.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({
    required this.section,
    required this.editMode,
    required bool Function(ServiceEntry) isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    super.key,
  }) : _favoriteBuilder = isFavorite;

  final ServiceSectionEntries section;
  final bool editMode;
  final bool Function(ServiceEntry entry) _favoriteBuilder;
  final ValueChanged<ServiceEntry> onOpen;
  final ValueChanged<ServiceEntry> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            section.title,
            style: AppText.heading.copyWith(color: context.colors.ink),
          ),
        ),
        ServicesGrid(
          entries: section.entries,
          editMode: editMode,
          isFavorite: _favoriteBuilder,
          onOpen: onOpen,
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }
}
