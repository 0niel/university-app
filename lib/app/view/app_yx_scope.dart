import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';
import 'package:rtu_mirea_app/app/widgets/firebase_interacted_message_listener.dart';
import 'package:rtu_mirea_app/app/widgets/watch_connectivity_wrapper.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/scopes/app_scope.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

class AppWithYxScope extends StatefulWidget {
  const AppWithYxScope({super.key, required this.appScopeHolder});

  final AppScopeHolder appScopeHolder;

  @override
  State<AppWithYxScope> createState() => _AppWithYxScopeState();
}

class _AppWithYxScopeState extends State<AppWithYxScope> {
  @override
  void dispose() {
    widget.appScopeHolder.drop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopeProvider(
      holder: widget.appScopeHolder,
      child: ScopeBuilder<AppScope>.withPlaceholder(
        builder: (context, appScope) {
          return _AppView(appScope: appScope);
        },
        placeholder: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({required this.appScope});

  final AppScope appScope;

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appScope = widget.appScope;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: appScope.homeCubit),
        BlocProvider.value(value: appScope.themeCubit),
        BlocProvider.value(value: appScope.categoriesBloc),
        BlocProvider.value(value: appScope.feedBloc),
        BlocProvider.value(value: appScope.adsBloc),
        BlocProvider.value(value: appScope.analyticsBloc),
        BlocProvider.value(value: appScope.scheduleBloc),
        BlocProvider.value(value: appScope.nfcPassCubit),
        BlocProvider.value(value: appScope.fullScreenAdsBloc),
        BlocProvider.value(value: appScope.lostFoundBloc),
        BlocProvider.value(value: appScope.appScopeBloc),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final themeCubit = context.read<ThemeCubit>();

              final lightTheme = themeCubit.getLightTheme();
              final darkTheme = themeCubit.getDarkTheme();

              return PlatformProvider(
                builder:
                    (context) => AdaptiveTheme(
                      light: lightTheme,
                      dark: darkTheme,
                      initial: AdaptiveThemeMode.dark,
                      builder: (theme, darkTheme) {
                        _configureSystemUI(theme);

                        return PlatformTheme(
                          themeMode:
                              theme.brightness == Brightness.light
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                          materialLightTheme: lightTheme,
                          materialDarkTheme: darkTheme,
                          cupertinoLightTheme: MaterialBasedCupertinoThemeData(
                            materialTheme: lightTheme,
                          ),
                          cupertinoDarkTheme: MaterialBasedCupertinoThemeData(
                            materialTheme: darkTheme,
                          ),
                          builder: (context) {
                            final app = PlatformApp.router(
                              restorationScopeId: 'app',
                              localizationsDelegates: const [
                                AppLocalizations.delegate,
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                                GlobalCupertinoLocalizations.delegate,
                                SfGlobalLocalizations.delegate,
                              ],
                              supportedLocales: const [
                                Locale('en'),
                                Locale('ru'),
                              ],
                              locale: const Locale('ru'),
                              debugShowCheckedModeBanner: false,
                              title: 'Приложение РТУ МИРЭА',
                              routerConfig: appScope.router,
                              builder:
                                  (context, child) =>
                                      ResponsiveBreakpoints.builder(
                                        child: child!,
                                        breakpoints: const [
                                          Breakpoint(
                                            start: 0,
                                            end: 450,
                                            name: MOBILE,
                                          ),
                                          Breakpoint(
                                            start: 451,
                                            end: 800,
                                            name: TABLET,
                                          ),
                                          Breakpoint(
                                            start: 801,
                                            end: 1920,
                                            name: DESKTOP,
                                          ),
                                          Breakpoint(
                                            start: 1921,
                                            end: double.infinity,
                                            name: '4K',
                                          ),
                                        ],
                                      ),
                            );

                            return FirebaseInteractedMessageListener(
                              child: WatchConnectivityWrapper(child: app),
                            );
                          },
                        );
                      },
                    ),
              );
            },
          );
        },
      ),
    );
  }

  /// Hide status bar background and set transparent navigation bar while keeping top overlay visible.
  void _configureSystemUI(ThemeData theme) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        statusBarIconBrightness:
            theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarIconBrightness:
            theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );
  }
}
