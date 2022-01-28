import 'package:auto_route/auto_route.dart';
import 'package:rtu_mirea_app/presentation/pages/auth/login_page.dart';
import 'package:rtu_mirea_app/presentation/pages/home_page.dart';
import 'package:rtu_mirea_app/presentation/pages/map/map_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_details_page.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_page.dart';
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/about_app_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_announces_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_attendance_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_detail_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_lectors_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_scores_page.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_page.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: HomePage,
      initial: true,
      children: [
        AutoRoute(
          path: 'news',
          name: 'NewsRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: NewsPage,
            ),
            AutoRoute(
              path: 'details',
              page: NewsDetailsPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'schedule',
          page: SchedulePage,
        ),
        AutoRoute(
          path: 'map',
          page: MapPage,
        ),
        AutoRoute(
          path: 'profile',
          name: 'ProfileRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: ProfilePage,
            ),
            AutoRoute(
              path: 'about',
              page: AboutAppPage,
            ),
            AutoRoute(
              path: 'announces',
              page: ProfileAnnouncesPage,
            ),
            AutoRoute(
              path: 'attendance',
              page: ProfileAttendancePage,
            ),
            AutoRoute(
              path: 'details',
              page: ProfileDetailPage,
            ),
            AutoRoute(
              path: 'lectors',
              page: ProfileLectrosPage,
            ),
            AutoRoute(
              path: 'scores',
              page: ProfileScoresPage,
            ),
          ],
        ),
      ],
    ),
    AutoRoute(
      path: '/login',
      page: LoginPage,
    ),
    AutoRoute(path: '/onboarding', page: OnBoardingPage),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
