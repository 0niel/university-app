import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/services/services.dart';

class ServicesGridTile extends StatelessWidget {
  const ServicesGridTile({
    required this.service,
    required this.editMode,
    required this.isFavorite,
    required this.onTap,
    super.key,
    this.tileSize = ServiceTileSize.category,
  });

  final ServiceModel service;
  final bool editMode;
  final bool isFavorite;
  final ServiceTileSize tileSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tile = ServiceTile(
      title: service.title,
      icon: service.icon,
      color: service.color,
      size: tileSize,
      onTap: onTap,
    );
    if (!editMode) return tile;
    final colors = context.ninja;
    final editor = Stack(
      clipBehavior: Clip.none,
      children: [
        tile,
        Positioned(
          top: -4,
          right: tileSize == ServiceTileSize.pinned ? 4 : -2,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFavorite ? colors.ink : colors.surface,
            ),
            child: AppLineIconWidget(
              isFavorite ? .close : .plus,
              size: 14,
              color: isFavorite ? colors.onInk : colors.muted,
            ),
          ),
        ),
      ],
    );
    return Semantics(
      button: true,
      selected: isFavorite,
      label: service.title,
      excludeSemantics: true,
      onTap: onTap,
      child: editor,
    );
  }
}
