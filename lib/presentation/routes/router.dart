import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:rtu_mirea_app/presentation/pages/dashboard/dashboard_page.dart';
import 'package:rtu_mirea_app/presentation/pages/dashboard/lost_and_found_create_page.dart';
import 'package:rtu_mirea_app/presentation/pages/dashboard/lost_and_found_service_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_page.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_page.dart';

import '../pages/home/home_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: NewsDetailsPage, path: 'news-details'),
    AutoRoute(page: LostAndFoundCreatePage, path: 'lostandfound-create'),
    AutoRoute(
      page: HomePage,
      initial: true,
      path: '/',
      children: [
        AutoRoute(
          page: EmptyRouterPage,
          name: 'NewsRouter',
          path: 'news',
          children: [
            AutoRoute(page: NewsPage, path: ''),
          ],
        ),
        AutoRoute(
          page: EmptyRouterPage,
          name: 'ScheduleRouter',
          path: 'schedule',
          children: [
            AutoRoute(page: SchedulePage, path: ''),
          ],
        ),
        AutoRoute(
          page: EmptyRouterPage,
          name: 'DashboardRouter',
          path: 'dashboard',
          children: [
            AutoRoute(page: DashboardPage, path: ''),
            AutoRoute(page: LostAndFoundServicePage, path: 'lost-and-found'),
          ],
        ),
        AutoRoute(
          page: EmptyRouterPage,
          name: 'ProfileRouter',
          path: 'profile',
          children: [
            AutoRoute(page: ProfilePage, path: ''),
            AutoRoute(page: AboutAppPage, path: 'about'),
          ],
        ),
      ],
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
