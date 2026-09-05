import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';
import 'package:rtu_mirea_app/app/widgets/app_system_ui_surface.dart';
import 'package:rtu_mirea_app/app/widgets/root_app_wrapper.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/debug/debug_panel.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({
    required this.router,
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
    super.key,
  });

  static const double toastBottomInset = 104;

  final GoRouter router;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ru')],
      locale: context.watch<LocaleCubit>().state.locale,
      debugShowCheckedModeBanner: false,
      title: context.read<UniversityConfig>().appName,
      routerConfig: router,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      builder: _buildWithWrappers,
    );
  }

  Widget _buildWithWrappers(BuildContext context, Widget? child) {
    final responsive = ResponsiveBreakpoints.builder(
      child: child ?? const SizedBox.shrink(),
      breakpoints: const [
        Breakpoint(start: 0, end: 649, name: MOBILE),
        Breakpoint(start: 650, end: 1099, name: TABLET),
        Breakpoint(start: 1100, end: 1919, name: DESKTOP),
        Breakpoint(start: 1920, end: .infinity, name: '4K'),
      ],
    );

    return AppSystemUiSurface(
      child: RootAppWrapper(
        router: router,
        child: DebugOverlay(
          child: AppScale.create(
            child: AppTourOverlay(
              router: router,
              child: NinjaToastHost(
                bottomInset: toastBottomInset,
                child: responsive,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
