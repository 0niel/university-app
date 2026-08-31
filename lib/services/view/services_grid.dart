import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_grid_tile.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({
    required this.services,
    required this.editMode,
    required this.onFavoriteCheck,
    required this.onServiceTap,
    super.key,
    this.tileSize = ServiceTileSize.category,
  });

  final List<ServiceModel> services;
  final bool editMode;
  final bool Function(ServiceModel) onFavoriteCheck;
  final ValueChanged<ServiceModel> onServiceTap;
  final ServiceTileSize tileSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final minimumCellWidth = textScale >= 1.75
            ? 108.0
            : textScale >= 1.3
            ? 88.0
            : 74.0;
        final columns = (constraints.maxWidth / minimumCellWidth).floor().clamp(
          2,
          5,
        );
        return LayoutGrid(
          autoPlacement: AutoPlacement.rowDense,
          columnSizes: List.filled(columns, 1.fr),
          rowSizes: List.generate(
            (services.length / columns).ceil(),
            (_) => auto,
          ),
          columnGap: 10,
          rowGap: textScale >= 1.5 ? 24 : 18,
          children: services
              .map(
                (service) => ServicesGridTile(
                  service: service,
                  editMode: editMode,
                  isFavorite: onFavoriteCheck(service),
                  tileSize: tileSize,
                  onTap: () => onServiceTap(service),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
