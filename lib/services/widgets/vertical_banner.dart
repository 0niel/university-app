import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A vertical banner card displaying a service with icon, title, description and action button
class VerticalBanner extends StatelessWidget {
  /// Creates a vertical banner.
  const VerticalBanner({
    super.key,
    required this.title,
    required this.description,
    required this.iconData,
    required this.color,
    required this.action,
    required this.onTap,
  });

  /// The title of the banner
  final String title;

  /// The description of the banner
  final String description;

  /// The icon to display
  final IconData iconData;

  /// The background color of the banner
  final Color color;

  /// The text for the action button
  final String action;

  /// Called when the banner is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width - AppSpacing.xlg * 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(iconData, color: Colors.white, size: 24),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: AppTextStyle.h6.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: AppTextStyle.body.copyWith(color: Colors.white.withOpacity(0.9)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(action, style: AppTextStyle.bodyBold.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
