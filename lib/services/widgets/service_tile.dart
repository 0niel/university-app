import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A service tile widget that displays an icon and title in a grid layout
class ServiceTile extends StatelessWidget {
  /// Creates a service tile.
  const ServiceTile({super.key, required this.title, required this.iconData, required this.color, required this.onTap});

  /// The title of the service
  final String title;

  /// The icon to display
  final IconData iconData;

  /// The color of the icon background
  final Color color;

  /// Called when the tile is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
              child: Icon(iconData, color: color, size: 24),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: AppTextStyle.captionL.copyWith(
              height: 1.1,
              leadingDistribution: TextLeadingDistribution.even,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).extension<AppColors>()!.active,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
