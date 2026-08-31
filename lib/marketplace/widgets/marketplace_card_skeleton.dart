import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part 'marketplace_card_content_skeleton.dart';

class MarketplaceCardSkeleton extends StatelessWidget {
  const MarketplaceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 340 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.35;
            if (stacked) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NinjaSkeletonMedia(height: 126),
                  SizedBox(height: 14),
                  _MarketplaceCardContentSkeleton(),
                ],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NinjaSkeletonMedia(width: 96, height: 112),
                SizedBox(width: 14),
                Expanded(child: _MarketplaceCardContentSkeleton()),
              ],
            );
          },
        ),
      ),
    );
  }
}
