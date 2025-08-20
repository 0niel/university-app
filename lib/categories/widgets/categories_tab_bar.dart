import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template categories_tab_bar}
/// A reusable categories tab bar widget.
/// {@endtemplate}
class CategoriesTabBar extends StatelessWidget {
  /// {@macro categories_tab_bar}
  const CategoriesTabBar({
    required this.controller,
    required this.tabs,
    super.key,
  });

  /// The controller for the tab bar.
  final TabController controller;

  /// The list of tabs to display.
  final List<CategoryTab> tabs;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(color: colors.background01),
        child: _CustomTabBar(controller: controller, tabs: tabs),
      ),
    );
  }
}

class _CustomTabBar extends StatefulWidget {
  const _CustomTabBar({required this.controller, required this.tabs});
  final TabController controller;
  final List<CategoryTab> tabs;

  @override
  State<_CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<_CustomTabBar> {
  int get selectedIndex => widget.controller.index;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CategoryAnimatedTabBar(
      tabs: widget.tabs.map((t) => t.categoryName).toList(),
      selectedIndex: selectedIndex,
      onTap:
          (index) =>
              selectedIndex == index
                  ? widget.tabs[index].onDoubleTap?.call()
                  : widget.controller.animateTo(index),
      onDoubleTap: (index) => widget.tabs[index].onDoubleTap?.call(),
      padding: EdgeInsets.zero,
    );
  }
}

/// {@template category_tab}
/// A reusable category tab widget.
/// {@endtemplate}
class CategoryTab extends StatelessWidget {
  /// {@macro category_tab}
  const CategoryTab({required this.categoryName, this.onDoubleTap, super.key});

  /// The name of the category.
  final String categoryName;

  /// Called when the tab is double tapped.
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    // Не используется напрямую, только как data-holder для _AnimatedCategoryTab
    return const SizedBox.shrink();
  }
}
