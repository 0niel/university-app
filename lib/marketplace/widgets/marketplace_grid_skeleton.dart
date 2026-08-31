import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/widgets/marketplace_card_skeleton.dart';

class MarketplaceGridSkeleton extends StatelessWidget {
  const MarketplaceGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          NinjaMetrics.screenPadding,
          0,
          NinjaMetrics.screenPadding,
          100,
        ),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, _) => const MarketplaceCardSkeleton(),
      ),
    );
  }
}
