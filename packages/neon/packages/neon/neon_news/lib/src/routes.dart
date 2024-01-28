import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_news/src/pages/main.dart';
import 'package:nextcloud/nextcloud.dart';

part 'routes.g.dart';

@TypedGoRoute<NewsAppRoute>(
  path: '$appsBaseRoutePrefix${AppIDs.news}',
  name: AppIDs.news,
)
@immutable
class NewsAppRoute extends NeonBaseAppRoute {
  const NewsAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const NewsMainPage();
}
