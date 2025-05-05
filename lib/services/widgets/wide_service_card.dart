import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A wide card displaying service information with icon, title and description
class WideServiceCard extends StatelessWidget {
  /// Creates a wide service card.
  const WideServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  /// The title of the card
  final String title;

  /// The description of the service
  final String description;

  /// The icon to display
  final IconData iconData;

  /// The color of the icon background
  final Color color;

  /// Called when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).extension<AppColors>()!.background02,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
                child: Icon(iconData, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bodyBold.copyWith(color: Theme.of(context).extension<AppColors>()!.active),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).extension<AppColors>()!.deactive),
            ],
          ),
        ),
      ),
    );
  }
}
