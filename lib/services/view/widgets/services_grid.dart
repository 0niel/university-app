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
  }) : _favoriteBuilder = isFavorite,
       _sliver = false;

  const ServicesGrid.sliver({
    required this.entries,
    required this.editMode,
    required bool Function(ServiceEntry) isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    this.compact = false,
    super.key,
  }) : _favoriteBuilder = isFavorite,
       _sliver = true;

  final List<ServiceEntry> entries;
  final bool editMode;
  final bool Function(ServiceEntry) _favoriteBuilder;
  final ValueChanged<ServiceEntry> onOpen;
  final ValueChanged<ServiceEntry> onToggleFavorite;
  final bool compact;
  final bool _sliver;

  static int columnsFor(BuildContext context, double width) =>
      AppAdaptiveGrid.columnsFor(context, width);

  Widget _buildItem(BuildContext context, int index) {
    final entry = entries.elementAtOrNull(index)!;
    return ServiceRow(
      key: ValueKey(entry.id),
      entry: entry,
      editMode: editMode,
      favorite: _favoriteBuilder(entry),
      compact: compact,
      onTap: () => onOpen(entry),
      onToggleFavorite: () => onToggleFavorite(entry),
    );
  }

  @override
  Widget build(BuildContext context) => _sliver
      ? AppSliverAdaptiveGrid(
          itemCount: entries.length,
          itemBuilder: _buildItem,
        )
      : AppAdaptiveGrid(
          children: [
            for (var index = 0; index < entries.length; index++)
              _buildItem(context, index),
          ],
        );
}
