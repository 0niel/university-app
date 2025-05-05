import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A horizontal card for displaying service information with icon, title and description
class HorizontalServiceCard extends StatelessWidget {
  /// Creates a horizontal service card.
  const HorizontalServiceCard({
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
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).extension<AppColors>()!.background02,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, color: color, size: 22),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).extension<AppColors>()!.deactive),
                  ],
                ),
                const Spacer(),
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
        ),
      ),
    );
  }
}
