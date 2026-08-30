import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/categories/widgets/category_tab_data.dart';

part 'category_tab.dart';

class CategoriesScrollableTabBar extends StatefulWidget {
  const CategoriesScrollableTabBar({
    required this.controller,
    required this.tabs,
    super.key,
  });

  final TabController controller;
  final List<CategoryTabData> tabs;

  @override
  State<CategoriesScrollableTabBar> createState() =>
      _CategoriesScrollableTabBarState();
}

class _CategoriesScrollableTabBarState
    extends State<CategoriesScrollableTabBar> {
  late int _selectedIndex = widget.controller.index;

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

  void _onTabChanged() =>
      setState(() => _selectedIndex = widget.controller.index);

  void _onTap(int index, {required bool reduceMotion}) {
    final tab = widget.tabs.elementAtOrNull(index);
    if (tab == null) return;
    if (_selectedIndex == index) {
      tab.onDoubleTap?.call();
    } else if (reduceMotion) {
      widget.controller.index = index;
    } else {
      widget.controller.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.tabs.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            _CategoryTab(
              label: widget.tabs[i].categoryName,
              selected: i == _selectedIndex,
              reduceMotion: reduceMotion,
              onTap: () => _onTap(i, reduceMotion: reduceMotion),
            ),
          ],
        ],
      ),
    );
  }
}
