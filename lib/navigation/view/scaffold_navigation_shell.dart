import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';

/// Controller to manage bottom navigation bar visibility
class BottomNavigationBarVisibilityController extends ChangeNotifier {
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
  }

  static final instance = BottomNavigationBarVisibilityController();
}

class ScaffoldNavigationShell extends StatefulWidget {
  const ScaffoldNavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static final isDesktop =
      !(defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  @override
  State<ScaffoldNavigationShell> createState() => _ScaffoldNavigationShellState();
}

class _ScaffoldNavigationShellState extends State<ScaffoldNavigationShell> {
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.navigationShell.currentIndex;
  }

  @override
  void didUpdateWidget(ScaffoldNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If navigation branch changed, ensure bottom bar is visible
    if (widget.navigationShell.currentIndex != _previousIndex) {
      BottomNavigationBarVisibilityController.instance.show();
      _previousIndex = widget.navigationShell.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > tabletBreakpoint) {
          return Scaffold(
            body: Row(
              children: [
                // Sidebar(
                //   currentIndex: navigationShell.currentIndex,
                //   onClick: (index) => _setActiveIndex(index),
                // ),
                Expanded(child: widget.navigationShell),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
            body: widget.navigationShell,
            extendBody: true,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              index: widget.navigationShell.currentIndex,
              onClick: (index) => _setActiveIndex(index),
            ),
          );
        }
      },
    );
  }

  void _setActiveIndex(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }
}
