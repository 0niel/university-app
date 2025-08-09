import 'package:ads_ui/ads_ui.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:article_repository/article_repository.dart';
import 'package:community_repository/community_repository.dart';
import 'package:discourse_repository/discourse_repository.dart' hide User;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
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
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/analytics/bloc/analytics_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rtu_mirea_app/data/repositories/stories_repository_impl.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/stories/bloc/stories_bloc.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:rtu_mirea_app/splash_video/splash_video.dart';
import 'package:splash_video_repository/splash_video_repository.dart';

Future<void> yandexInterstitialAdLoader({
  required String adUnitId,
  required AdRequestConfiguration adRequestConfiguration,
  required void Function(InterstitialAd ad) onAdLoaded,
  required void Function(Object error) onAdFailedToLoad,
}) async {
  try {
    final loader = await InterstitialAdLoader.create(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);

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
    final loader = await RewardedAdLoader.create(onAdLoaded: onAdLoaded, onAdFailedToLoad: onAdFailedToLoad);
    await loader.loadAd(adRequestConfiguration: adRequestConfiguration);
  } catch (error) {
    onAdFailedToLoad(error);
  }
}

class App extends StatelessWidget {
  const App({
    super.key,
    required AnalyticsRepository analyticsRepository,
    required ScheduleRepository scheduleRepository,
    required CommunityRepository communityRepository,
    required DiscourseRepository discourseRepository,
    required NewsRepository newsRepository,
    required ArticleRepository articleRepository,
    required ScheduleExporterRepository scheduleExporterRepository,
    required NfcPassRepository nfcPassRepository,
    required LostFoundRepository lostFoundRepository,
    required UserRepository userRepository,
    required SplashVideoRepository splashVideoRepository,
    required User user,
  }) : _analyticsRepository = analyticsRepository,
       _scheduleRepository = scheduleRepository,
       _communityRepository = communityRepository,
       _discourseRepository = discourseRepository,
       _newsRepository = newsRepository,
       _articleRepository = articleRepository,
       _scheduleExporterRepository = scheduleExporterRepository,
       _nfcPassRepository = nfcPassRepository,
       _userRepository = userRepository,
       _lostFoundRepository = lostFoundRepository,
       _user = user,
       _splashVideoRepository = splashVideoRepository;

  final AnalyticsRepository _analyticsRepository;
  final ScheduleRepository _scheduleRepository;
  final CommunityRepository _communityRepository;
  final DiscourseRepository _discourseRepository;
  final NewsRepository _newsRepository;
  final ArticleRepository _articleRepository;
  final ScheduleExporterRepository _scheduleExporterRepository;
  final NfcPassRepository _nfcPassRepository;
  final LostFoundRepository _lostFoundRepository;
  final UserRepository _userRepository;
  final SplashVideoRepository _splashVideoRepository;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _analyticsRepository),
        RepositoryProvider.value(value: _scheduleRepository),
        RepositoryProvider.value(value: _communityRepository),
        RepositoryProvider.value(value: _discourseRepository),
        RepositoryProvider.value(value: _newsRepository),
        RepositoryProvider.value(value: _articleRepository),
        RepositoryProvider.value(value: _scheduleExporterRepository),
        RepositoryProvider.value(value: _nfcPassRepository),
        RepositoryProvider.value(value: _lostFoundRepository),
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _splashVideoRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeCubit()),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(
            create:
                (context) =>
                    CategoriesBloc(newsRepository: context.read<NewsRepository>())..add(const CategoriesRequested()),
          ),
          BlocProvider(create: (context) => FeedBloc(newsRepository: context.read<NewsRepository>())),
          BlocProvider(create: (_) => AdsBloc()),
          BlocProvider(create: (_) => ScheduleExporterCubit(_scheduleExporterRepository)),
          BlocProvider(
            create:
                (_) =>
                    AppBloc(firebaseMessaging: FirebaseMessaging.instance, userRepository: _userRepository, user: _user)
                      ..add(const AppOpened()),
          ),
          BlocProvider(create: (context) => AnalyticsBloc(analyticsRepository: _analyticsRepository), lazy: false),
          BlocProvider<ScheduleBloc>(
            create:
                (context) =>
                    ScheduleBloc(scheduleRepository: context.read<ScheduleRepository>())
                      ..add(const RefreshSelectedScheduleData()),
          ),
          BlocProvider<StoriesBloc>(
            create:
                (context) => StoriesBloc(storiesRepository: context.read<StoriesRepositoryImpl>())..add(LoadStories()),
          ),
          BlocProvider<NfcPassCubit>(create: (_) => NfcPassCubit(repository: _nfcPassRepository)),
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
            create: (context) => LostFoundBloc(repository: _lostFoundRepository, userRepository: _userRepository),
          ),
          BlocProvider(
            create:
                (context) => SplashVideoBloc(splashVideoRepository: _splashVideoRepository)..add(
                  const CheckSplashVideoStatus(
                    videoUrl: 'YOUR_VIDEO_URL_HERE', // Replace with your actual video URL
                    endDate: '2023-12-31', // Replace with your desired end date in ISO format
                  ),
                ),
          ),
        ],
        child: _AppView(),
      ),
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
                        themeMode: theme.brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
                        materialLightTheme: lightTheme,
                        materialDarkTheme: darkTheme,
                        cupertinoLightTheme: MaterialBasedCupertinoThemeData(materialTheme: lightTheme),
                        cupertinoDarkTheme: MaterialBasedCupertinoThemeData(materialTheme: darkTheme),
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
                            supportedLocales: const [Locale('en'), Locale('ru')],
                            locale: const Locale('ru'),
                            debugShowCheckedModeBanner: false,
                            title: 'Приложение РТУ МИРЭА',
                            routerConfig: _router,
                            builder:
                                (context, child) => ResponsiveBreakpoints.builder(
                                  child: child!,
                                  breakpoints: const [
                                    Breakpoint(start: 0, end: 450, name: MOBILE),
                                    Breakpoint(start: 451, end: 800, name: TABLET),
                                    Breakpoint(start: 801, end: 1920, name: DESKTOP),
                                    Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                                  ],
                                ),
                          );

                          return FirebaseInteractedMessageListener(child: WatchConnectivityWrapper(child: app));
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        statusBarIconBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
    );
  }
}
