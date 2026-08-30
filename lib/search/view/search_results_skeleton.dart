import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/view/best_match_skeleton_card.dart';

part 'result_row_skeleton.dart';

class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  static const _rowCount = 5;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xxlg),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: NinjaSkeleton(width: 156, height: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: BestMatchSkeletonCard(),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: NinjaSkeleton(width: 174, height: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: List.generate(
                _rowCount,
                (_) => const _ResultRowSkeleton(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
