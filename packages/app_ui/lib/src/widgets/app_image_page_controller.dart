import 'dart:async';

import 'package:flutter/widgets.dart';

class AppImagePageController extends PageController {
  AppImagePageController({super.initialPage});

  double? _imageDragOrigin;

  void beginImageDrag() {
    if (!hasClients) return;
    _imageDragOrigin = offset;
    position.hold(() {});
  }

  void updateImageDrag(double distance) {
    if (!hasClients || _imageDragOrigin == null) return;
    jumpTo(
      (_imageDragOrigin! - distance)
          .clamp(position.minScrollExtent, position.maxScrollExtent),
    );
    position.hold(() {});
  }

  void endImageDrag(double velocity, {bool reducedMotion = false}) {
    _imageDragOrigin = null;
    if (!hasClients) return;
    final current = page ?? initialPage.toDouble();
    final target = velocity.abs() > 700
        ? velocity < 0
            ? current.ceil()
            : current.floor()
        : current.round();
    if (reducedMotion) {
      jumpToPage(target);
      return;
    }
    unawaited(
      animateToPage(
        target,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
