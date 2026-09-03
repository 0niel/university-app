import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_card_skeleton.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_layout.dart';

class MarketplaceGridSkeleton extends StatelessWidget {
  const MarketplaceGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final columns = MarketplaceLayout.columns(
      MediaQuery.sizeOf(context).width,
      scale,
    );
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.zero,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.cardGap,
          mainAxisSpacing: AppSpacing.cardGap,
          mainAxisExtent: MarketplaceLayout.cardExtent(scale),
        ),
        itemBuilder: (_, _) => const MarketplaceCardSkeleton(),
      ),
    );
  }
}
