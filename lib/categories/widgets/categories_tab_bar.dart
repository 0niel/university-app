import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/categories/widgets/categories_scrollable_tab_bar.dart';
import 'package:rtu_mirea_app/categories/widgets/category_tab_data.dart';
import 'package:rtu_mirea_app/categories/widgets/category_tab_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class CategoriesTabBar extends StatelessWidget {
  const CategoriesTabBar({
    required this.tabs,
    this.controller,
    this.isLoading = false,
    super.key,
  });

  final TabController? controller;

  final List<CategoryTabData> tabs;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.xs,
          bottom: AppSpacing.sm,
        ),
        child: isLoading
            ? NinjaSkeletonGroup(
                semanticsLabel: context.l10n.loadingContent,
                child: const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: NinjaMetrics.screenPadding,
                  ),
                  child: Row(
                    children: [
                      CategoryTabSkeleton(),
                      SizedBox(width: AppSpacing.sm),
                      CategoryTabSkeleton(),
                      SizedBox(width: AppSpacing.sm),
                      CategoryTabSkeleton(),
                      SizedBox(width: AppSpacing.sm),
                      CategoryTabSkeleton(),
                      SizedBox(width: AppSpacing.sm),
                      CategoryTabSkeleton(),
                    ],
                  ),
                ),
              )
            : controller == null
            ? const SizedBox.shrink()
            : CategoriesScrollableTabBar(controller: controller, tabs: tabs),
      ),
    );
  }
}
