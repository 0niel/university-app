import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

final class ServiceTile extends StatelessWidget {
  const ServiceTile({
    required this.title,
    required this.icon,
    required this.color,
    this.size = ServiceTileSize.category,
    this.onTap,
    super.key,
  });

  final String title;
  final AppLineIcon icon;
  final Color color;
  final ServiceTileSize size;
  final VoidCallback? onTap;

  bool get _pinned => size == ServiceTileSize.pinned;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final box = _pinned ? 60.0 : 56.0;
    final tone = colors.accentInk(color);
    return AppServiceTile.icon(
      icon: AppLineIconWidget(
        icon,
        color: tone,
        size: _pinned ? 26 : 23,
      ),
      color: color,
      label: title,
      size: box,
      onTap: onTap,
    );
  }
}

enum ServiceTileSize { pinned, category }
