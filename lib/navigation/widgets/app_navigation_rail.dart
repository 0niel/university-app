part of 'app_bottom_navigation_bar.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return AppTourAnchor(
      target: .navigationBar,
      child: NinjaNavigationRail(
        currentIndex: currentIndex,
        onSelected: (index) => handleNavigationSelection(
          currentIndex: currentIndex,
          destinationIndex: index,
          onSelected: onSelected,
        ),
        items: _navigationDestinations(context)
            .map(
              (item) => NinjaBottomBarItem(
                icon: NavGlyphIcon(item.glyph),
                activeIcon: NavGlyphIcon(item.glyph, filled: true),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
