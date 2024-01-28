import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_dashboard/src/pages/main.dart';
import 'package:neon_framework/utils.dart';
import 'package:nextcloud/nextcloud.dart';

part 'routes.g.dart';

/// Route for the dashboard app.
@TypedGoRoute<DashboardAppRoute>(
  path: '$appsBaseRoutePrefix${AppIDs.dashboard}',
  name: AppIDs.dashboard,
)
@immutable
class DashboardAppRoute extends NeonBaseAppRoute {
  /// Creates a new dashboard app route.
  const DashboardAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DashboardMainPage();
}
