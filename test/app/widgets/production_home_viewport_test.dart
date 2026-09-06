import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/widgets/app_system_ui_surface.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_content.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/view/scaffold_navigation_shell.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../gallery/gallery_fonts.dart';
import '../../gallery/home_dashboard_fixture.dart';

void main() {
  setUpAll(loadGalleryFonts);

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final size in [
      const Size(320, 800),
      const Size(555, 877),
      const Size(877, 555),
      const Size(800, 1200),
    ]) {
      for (final textScale in [1.0, 2.0]) {
        testWidgets(
          'home shell fills $size at $textScale text scale on $platform',
          (tester) async {
            tester.view
              ..physicalSize = size * 3
              ..devicePixelRatio = 3;
            addTearDown(tester.view.reset);
            final controller = ScrollController();
            addTearDown(controller.dispose);
            final rootNavigator = GlobalKey<NavigatorState>();
            final now = DateTime(2026, 9, 1, 11, 22);
            final router = GoRouter(
              navigatorKey: rootNavigator,
              initialLocation: '/feed',
              routes: [
                StatefulShellRoute.indexedStack(
                  builder: (_, _, shell) =>
                      ScaffoldNavigationShell(navigationShell: shell),
                  branches: [
                    for (final path in [
                      '/feed',
                      '/schedule',
                      '/services/map',
                      '/services',
                      '/profile',
                    ])
                      StatefulShellBranch(
                        routes: [
                          GoRoute(
                            path: path,
                            builder: (_, _) => path == '/feed'
                                ? HomeDashboardContent(
                                    now: now,
                                    selectedDay: now,
                                    scrollController: controller,
                                    searchKey: GlobalKey(),
                                    onSelectedDay: (_) {},
                                    onRetry: () {},
                                  )
                                : Scaffold(body: Center(child: Text(path))),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            );
            addTearDown(router.dispose);
            await tester.pumpWidget(
              SentryScreenshotWidget(
                child: homeDashboardFixture(
                  controller: controller,
                  child: MaterialApp.router(
                    routerConfig: router,
                    theme: AppTheme.darkTheme,
                    locale: const Locale('ru'),
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    builder: (context, child) => MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        padding: const EdgeInsets.only(top: 24, bottom: 24),
                        viewPadding: const EdgeInsets.only(top: 24, bottom: 24),
                        textScaler: TextScaler.linear(textScale),
                        disableAnimations: true,
                      ),
                      child: AppSystemUiSurface(child: AppScale(child: child!)),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final shell = find.byType(ScaffoldNavigationShell);
            expect(tester.getTopLeft(shell), Offset.zero);
            final end = tester.getBottomRight(shell);
            expect(end.dx, closeTo(size.width, .01));
            expect(end.dy, closeTo(size.height, .01));
            expect(find.byType(HomeDashboardContent), findsOneWidget);

            controller.jumpTo(controller.position.maxScrollExtent);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final navigation = size.shortestSide >= 650
                ? find.byType(AppNavigationRail)
                : find.byType(AppBottomNavigationBar);
            expect(navigation.hitTestable(), findsOneWidget);
            await tester.tap(
              find.descendant(
                of: navigation,
                matching: size.shortestSide >= 650
                    ? find.text('Профиль')
                    : find.bySemanticsLabel('Профиль'),
              ),
            );
            await tester.pumpAndSettle();
            expect(router.routeInformationProvider.value.uri.path, '/profile');

            final result = showAppSheet<void>(
              rootNavigator.currentContext!,
              title: 'Проверка окна',
              child: Builder(
                builder: (context) => AppButton.primary(
                  label: 'Закрыть окно',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final close = find.text('Закрыть окно');
            expect(close.hitTestable(), findsOneWidget);
            final closeRect = tester.getRect(close);
            expect(closeRect.left, greaterThanOrEqualTo(0));
            expect(closeRect.right, lessThanOrEqualTo(size.width));
            expect(closeRect.bottom, lessThanOrEqualTo(size.height - 24));
            await tester.tap(close);
            await tester.pumpAndSettle();
            await result;
            expect(close, findsNothing);
            expect(tester.takeException(), isNull);
          },
          variant: TargetPlatformVariant({platform}),
        );
      }
    }
  }
}
