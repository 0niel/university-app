import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({
    required this.section,
    required this.editMode,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    super.key,
  });

  final ServiceSectionEntries section;
  final bool editMode;
  final bool Function(ServiceEntry entry) isFavorite;
  final ValueChanged<ServiceEntry> onOpen;
  final ValueChanged<ServiceEntry> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppOverline(section.title),
        AppListGroup(
          radius: AppRadius.lg,
          color: section.key == ServicesDirectory.sectionFirstParty
              ? context.colors.tint
              : null,
          children: [
            for (final entry in section.entries)
              ServiceRow(
                entry: entry,
                editMode: editMode,
                favorite: isFavorite(entry),
                onTap: () => onOpen(entry),
                onToggleFavorite: () => onToggleFavorite(entry),
              ),
          ],
        ),
      ],
    );
  }
}
