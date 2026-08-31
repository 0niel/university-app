import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/navigation/widgets/nav_glyph.dart';
import 'package:rtu_mirea_app/tour/tour.dart';

part 'app_navigation_rail.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
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
      child: NinjaBottomBar(
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

typedef _NavigationDestination = ({
  NavGlyph glyph,
  String label,
});

List<_NavigationDestination> _navigationDestinations(BuildContext context) {
  final l10n = context.l10n;
  return [
    (glyph: NavGlyph.home, label: l10n.navHome),
    (glyph: NavGlyph.schedule, label: l10n.navSchedule),
    (glyph: NavGlyph.map, label: l10n.navMap),
    (glyph: NavGlyph.services, label: l10n.navServices),
    (glyph: NavGlyph.profile, label: l10n.navProfile),
  ];
}

int navigationVisualIndex(String path) {
  if (path.startsWith('/schedule')) return 1;
  if (path.startsWith('/services/map')) return 2;
  if (path.startsWith('/services')) return 3;
  if (path.startsWith('/profile')) return 4;
  return 0;
}

void handleNavigationSelection({
  required int currentIndex,
  required int destinationIndex,
  required ValueChanged<int> onSelected,
}) {
  assert(
    currentIndex >= 0 && currentIndex < 5,
    'The current index must identify a navigation branch.',
  );
  assert(
    destinationIndex >= 0 && destinationIndex < 5,
    'The destination index must identify a navigation branch.',
  );
  if (currentIndex == destinationIndex) {
    TabReselectNotifier.instance.reselect(destinationIndex);
    onSelected(destinationIndex);
    return;
  }
  unawaited(HapticFeedback.selectionClick());
  onSelected(destinationIndex);
}
