import 'package:ads_ui/ads_ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:news_repository/news_repository.dart';
import 'package:platform/platform.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rtu_mirea_app/ads/bloc/ads_bloc.dart';
import 'package:rtu_mirea_app/ads/bloc/full_screen_ads_bloc.dart';
import 'package:rtu_mirea_app/app/app.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:user_repository/user_repository.dart';
import 'package:rtu_mirea_app/di/app_scope.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> yandexInterstitialAdLoader({
  required String adUnitId,
  required AdRequestConfiguration adRequestConfiguration,
  required void Function(InterstitialAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
}) async {
  try {
    final loader = await InterstitialAdLoader.create(
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );

    await loader.loadAd(adRequestConfiguration: adRequestConfiguration);
  } catch (error) {
    onAdFailedToLoad(error);
  }
}

Future<void> yandexRewardedAdLoader({
  required String adUnitId,
  required AdRequestConfiguration adRequestConfiguration,
  required void Function(RewardedAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
}) async {
  try {
    final loader = await RewardedAdLoader.create(
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
    await loader.loadAd(adRequestConfiguration: adRequestConfiguration);
  } catch (error) {
    onAdFailedToLoad(error);
  }
}

class App extends StatelessWidget {
  const App({super.key, required User user}) : _user = user;

  final User _user;

  @override
  Widget build(BuildContext context) {
    return ScopeBuilder<AppScopeContainer>(
      builder: (context, scope) {
        final AppScope appScope = scope!;
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: appScope.analyticsRepository),
            RepositoryProvider.value(value: appScope.scheduleRepository),
            RepositoryProvider.value(value: appScope.communityRepository),
            RepositoryProvider.value(value: appScope.discourseRepository),
            RepositoryProvider.value(value: appScope.newsRepository),
            RepositoryProvider.value(value: appScope.articleRepository),
            RepositoryProvider.value(
              value: appScope.scheduleExporterRepository,
            ),
            RepositoryProvider.value(value: appScope.nfcPassRepository),
            RepositoryProvider.value(value: appScope.lostFoundRepository),
            RepositoryProvider.value(value: appScope.userRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => HomeCubit()),
              BlocProvider(create: (_) => ThemeCubit()),
              BlocProvider(
                create:
                    (context) => CategoriesBloc(
                      newsRepository: context.read<NewsRepository>(),
                    )..add(const CategoriesRequested()),
              ),
              BlocProvider(
                create:
                    (context) => FeedBloc(
                      newsRepository: context.read<NewsRepository>(),
                    ),
              ),
              BlocProvider(create: (_) => AdsBloc()),
              BlocProvider(
                create:
                    (_) => ScheduleExporterCubit(
                      appScope.scheduleExporterRepository,
                    ),
              ),
              BlocProvider(
                create:
                    (_) => AppBloc(
                      firebaseMessaging: FirebaseMessaging.instance,
                      userRepository: appScope.userRepository,
                      user: _user,
                    )..add(const AppOpened()),
              ),
              BlocProvider(
                create:
                    (context) => AnalyticsBloc(
                      analyticsRepository: appScope.analyticsRepository,
                    ),
                lazy: false,
              ),
              BlocProvider<ScheduleBloc>(
                create:
                    (context) => ScheduleBloc(
                      scheduleRepository: context.read<ScheduleRepository>(),
                    )..add(const RefreshSelectedScheduleData()),
              ),
              BlocProvider<NfcPassCubit>(
                create:
                    (_) => NfcPassCubit(repository: appScope.nfcPassRepository),
              ),
              BlocProvider(
                create:
                    (context) =>
                        FullScreenAdsBloc(
                            interstitialAdLoader: yandexInterstitialAdLoader,
                            rewardedAdLoader: yandexRewardedAdLoader,
                            adsRetryPolicy: const AdsRetryPolicy(),
                            localPlatform: const LocalPlatform(),
                          )
                          ..add(const LoadInterstitialAdRequested())
                          ..add(const LoadRewardedAdRequested()),
                lazy: false,
              ),
              BlocProvider(
                create:
                    (context) => LostFoundBloc(
                      repository: appScope.lostFoundRepository,
                      userRepository: appScope.userRepository,
                    ),
              ),
            ],
            child: _AppView(),
          ),
        );
      },
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
                            localizationsDelegates: [
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
                            routerConfig: _router,
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
