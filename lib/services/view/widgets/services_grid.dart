import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({
    required this.entries,
    required this.editMode,
    required bool Function(ServiceEntry) isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    this.compact = false,
    super.key,
  }) : _favoriteBuilder = isFavorite;

  final List<ServiceEntry> entries;
  final bool editMode;
  final bool Function(ServiceEntry) _favoriteBuilder;
  final ValueChanged<ServiceEntry> onOpen;
  final ValueChanged<ServiceEntry> onToggleFavorite;
  final bool compact;

  static int columnsFor(BuildContext context, double width) =>
      AppAdaptiveGrid.columnsFor(context, width);

  @override
  Widget build(BuildContext context) => AppAdaptiveGrid(
    children: [
      for (final entry in entries)
        ServiceRow(
          entry: entry,
          editMode: editMode,
          favorite: _favoriteBuilder(entry),
          compact: compact,
          onTap: () => onOpen(entry),
          onToggleFavorite: () => onToggleFavorite(entry),
        ),
    ],
  );
}
