import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rtu_app_core/rtu_app_core.dart';
import 'routes/router.gr.dart';

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (BuildContext context) => PlatformApp.router(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        material: (_, __) => MaterialAppRouterData(
          theme: NinjaAppTheme.theme,
        ),
        cupertino: (_, __) => CupertinoAppRouterData(
          theme: NinjaAppTheme.cupertinoLightTheme,
        ),
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
