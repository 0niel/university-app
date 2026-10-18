part of 'app_bottom_navigation_bar.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    required this.currentIndex,
    required this.onSelected,
    this.scheduleBadge = false,
    this.extended = false,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;
  final bool scheduleBadge;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return AppTourAnchor(
      target: .navigationBar,
      child: NinjaNavigationRail(
        extended: extended,
        currentIndex: currentIndex,
        onSelected: (index) => handleNavigationSelection(
          currentIndex: currentIndex,
          destinationIndex: index,
          onSelected: onSelected,
        ),
        items: navigationBarItems(context, scheduleBadge: scheduleBadge),
      ),
    );
  }
}
