import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class NinjaPageTransitions {
  static const PageTransitionsTheme theme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _NinjaSlidePageTransitionsBuilder(),
      TargetPlatform.fuchsia: _NinjaSlidePageTransitionsBuilder(),
      TargetPlatform.windows: _NinjaSlidePageTransitionsBuilder(),
      TargetPlatform.linux: _NinjaSlidePageTransitionsBuilder(),
      TargetPlatform.iOS: _NinjaCupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: _NinjaCupertinoPageTransitionsBuilder(),
    },
  );
}

class _NinjaSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const _NinjaSlidePageTransitionsBuilder();

  @override
  Duration get transitionDuration => NinjaMotion.base;

  @override
  Duration get reverseTransitionDuration => NinjaMotion.fast;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (NinjaMotion.of(context) == Duration.zero) return child;
    return SlideTransition(
      position: animation
          .drive(
            CurveTween(
              curve: route.popGestureInProgress
                  ? Curves.linear
                  : NinjaMotion.enter,
            ),
          )
          .drive(
            Tween<Offset>(
              begin: route.fullscreenDialog
                  ? const Offset(0, 1)
                  : const Offset(1, 0),
              end: Offset.zero,
            ),
          ),
      textDirection: Directionality.of(context),
      child: child,
    );
  }
}

class _NinjaCupertinoPageTransitionsBuilder
    extends CupertinoPageTransitionsBuilder {
  const _NinjaCupertinoPageTransitionsBuilder();

  @override
  DelegatedTransitionBuilder get delegatedTransition {
    final delegated = super.delegatedTransition!;
    return (context, animation, secondaryAnimation, allowSnapshotting, child) {
      if (NinjaMotion.of(context) == Duration.zero) return child;
      return delegated(
        context,
        animation,
        secondaryAnimation,
        allowSnapshotting,
        child,
      );
    };
  }

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (NinjaMotion.of(context) == Duration.zero) return child;
    return super.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
