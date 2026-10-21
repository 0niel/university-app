import 'package:flutter/material.dart' show TooltipVisibility;
import 'package:flutter/widgets.dart';

class NavigationBranchContainer extends StatelessWidget {
  const NavigationBranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  }) : assert(
         currentIndex >= 0 && currentIndex < children.length,
         'The current index must identify a branch.',
       );

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);
    return Stack(
      fit: StackFit.expand,
      children: [
        for (var index = 0; index < children.length; index++)
          Offstage(
            key: ValueKey(('navigation-branch', index)),
            offstage: index != currentIndex,
            child: IgnorePointer(
              ignoring: index != currentIndex,
              child: ExcludeFocus(
                excluding: index != currentIndex,
                child: ExcludeSemantics(
                  excluding: index != currentIndex,
                  child: TickerMode(
                    enabled: index == currentIndex,
                    child: TooltipVisibility(
                      visible: index == currentIndex,
                      child: AnimatedSlide(
                        duration: duration,
                        curve: Curves.easeOutCubic,
                        offset: index == currentIndex
                            ? Offset.zero
                            : Offset(index < currentIndex ? -.018 : .018, 0),
                        child: children[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
