import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_layout.dart';

part 'marketplace_card_content_skeleton.dart';

class MarketplaceCardSkeleton extends StatelessWidget {
  const MarketplaceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NinjaSkeletonMedia(
            height: MarketplaceLayout.coverHeight,
            radius: AppRadius.lg,
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: _MarketplaceCardContentSkeleton(),
          ),
        ],
      ),
    );
  }
}
