import 'package:app_ui/src/glass/app_pinned_surface.dart';
import 'package:flutter/widgets.dart';

class AppPinnedHeader extends StatelessWidget {
  const AppPinnedHeader({
    required this.child,
    this.extendTopSafeArea = false,
    super.key,
  });

  final Widget child;
  final bool extendTopSafeArea;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final inset = extendTopSafeArea ? MediaQuery.paddingOf(context).top : 0.0;
      final leading =
          constraints.viewportMainAxisExtent - constraints.remainingPaintExtent;
      final safeTop = (inset - leading).clamp(0.0, inset);
      return PinnedHeaderSliver(
        child: AppPinnedSurface(
          elevated: constraints.scrollOffset > 0 || leading <= inset,
          child: Padding(
            padding: EdgeInsets.only(top: safeTop),
            child: child,
          ),
        ),
      );
    },
  );
}
