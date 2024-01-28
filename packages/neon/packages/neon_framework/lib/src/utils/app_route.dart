import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// [RouteData] for the initial page of an app.
///
/// Subclasses must override one of [build] or [redirect].
/// Routes should be prefixed with [appsBaseRoutePrefix].
@immutable
abstract class NeonBaseAppRoute extends GoRouteData {
  /// Creates a new app base route.
  const NeonBaseAppRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => NoTransitionPage(
        child: build(context, state),
      );
}

/// Prefix for [NeonBaseAppRoute]s.
const appsBaseRoutePrefix = '/apps/';
