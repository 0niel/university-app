import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A horizontal tab bar for category selection.
///
/// This widget displays a scrollable horizontal list of category tabs
/// and handles selection state and callbacks.
class CategoryTabBar extends StatelessWidget {
  /// Creates a new instance of [CategoryTabBar].
  const CategoryTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.height = 40,
    this.scrollable = true,
    this.physics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.padding = const EdgeInsets.symmetric(),
    super.key,
  });

  /// The list of tab labels to display.
  final List<String> tabs;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Called when a tab is tapped.
  final void Function(int index) onTap;

  /// The height of the tab bar. Defaults to 40.
  final double height;

  /// Whether the tab bar should be scrollable. Defaults to true.
  final bool scrollable;

  /// The physics of the scrollable tab bar. Defaults to BouncingScrollPhysics.
  final ScrollPhysics physics;

  /// The scroll direction of the tab bar. Defaults to horizontal.
  final Axis scrollDirection;

  /// The padding around the tab bar. Defaults to zero horizontal padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final notifier = ValueNotifier<int>(selectedIndex);

    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: scrollable
            ? ListView.builder(
                scrollDirection: scrollDirection,
                physics: physics,
                itemCount: tabs.length,
                itemBuilder: (context, index) => _buildTab(context, index, notifier),
              )
            : Row(
                children: List.generate(
                  tabs.length,
                  (index) => _buildTab(context, index, notifier),
                ),
              ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, ValueNotifier<int> notifier) {
    return PrimaryTabButton(
      text: tabs[index],
      itemIndex: index,
      notifier: notifier,
      onClick: () {
        onTap(index);
      },
    );
  }
}

/// A variant of CategoryTabBar that uses animated containers instead of PrimaryTabButton.
///
/// This style matches the design used in the Services page.
class CategoryAnimatedTabBar extends StatefulWidget {
  /// Creates a new instance of [CategoryAnimatedTabBar].
  const CategoryAnimatedTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.height = 40,
    this.scrollable = true,
    this.physics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  /// The list of tab labels to display.
  final List<String> tabs;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Called when a tab is tapped.
  final void Function(int index) onTap;

  /// The height of the tab bar. Defaults to 40.
  final double height;

  /// Whether the tab bar should be scrollable. Defaults to true.
  final bool scrollable;

  /// The physics of the scrollable tab bar. Defaults to BouncingScrollPhysics.
  final ScrollPhysics physics;

  /// The scroll direction of the tab bar. Defaults to horizontal.
  final Axis scrollDirection;

  /// The padding around the tab bar. Defaults to zero horizontal padding.
  final EdgeInsetsGeometry padding;

  @override
  State<CategoryAnimatedTabBar> createState() => _CategoryAnimatedTabBarState();
}

class _CategoryAnimatedTabBarState extends State<CategoryAnimatedTabBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(CategoryAnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Обновляем текущий индекс, если он изменился извне
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _currentIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: widget.padding,
        child: widget.scrollable
            ? ListView.builder(
                scrollDirection: widget.scrollDirection,
                physics: widget.physics,
                itemCount: widget.tabs.length,
                itemBuilder: _buildTab,
              )
            : Row(
                children: List.generate(
                  widget.tabs.length,
                  (index) => _buildTab(context, index),
                ),
              ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isSelected = index == _currentIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        widget.onTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.background02,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            widget.tabs[index],
            style: TextStyle(
              color: isSelected ? Colors.white : colors.deactive,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
