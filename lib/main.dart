import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/home/home_navigator_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/map/map_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/news/news_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/schedule_screen.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/profile_screen.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/service_locator.dart' as dependency_injection;
import 'service_locator.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependency_injection.setup();
  var prefs = getIt<SharedPreferences>();
  const String onboardingKey = 'show_onboarding';
  bool showOnboarding = prefs.getBool(onboardingKey) ?? true;
  if (showOnboarding) prefs.setBool(onboardingKey, false);

  // to debug:
  //await prefs.clear();
  setDataForIOSHomeWidget();
  initializeDateFormatting();
  runApp(App(showOnboarding: showOnboarding));
}

class App extends StatelessWidget {
  final bool showOnboarding;

  /// if [showOnboarding] is true, when start the application,
  /// the intro screen will be displayed
  const App({Key? key, required this.showOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // blocking the orientation of the application to
    // vertical only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // deleting the system status bar color
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider<ScheduleBloc>(create: (context) => getIt<ScheduleBloc>()),
        BlocProvider<HomeNavigatorBloc>(
            create: (context) => getIt<HomeNavigatorBloc>()),
        BlocProvider<OnboardingCubit>(
            create: (context) => getIt<OnboardingCubit>()),
        BlocProvider<MapCubit>(create: (context) => getIt<MapCubit>()),
        BlocProvider<NewsBloc>(create: (context) => getIt<NewsBloc>()),
        BlocProvider<AboutAppBloc>(
            create: (context) =>
                getIt<AboutAppBloc>()..add(AboutAppGetMembers())),
      ],
      child: AdaptiveTheme(
        light: lightTheme,
        dark: darkTheme,
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Приложение РТУ МИРЭА',
          theme: theme,
          home: showOnboarding
              ? const OnBoardingScreen()
              : const HomeNavigatorScreen(),
          routes: {
            ScheduleScreen.routeName: (context) => const ScheduleScreen(),
            MapScreen.routeName: (context) => const MapScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
            NewsScreen.routeName: (context) => NewsScreen()
          },
        ),
      ),
    );
  }
}

/// Update timetable for IOS
/// // TODO Обновлять список недель с началом нового года
void setDataForIOSHomeWidget() async {
  HomeWidget.setAppGroupId('group.com.MireaNinja.rtuMireaApp');
  HomeWidget.saveWidgetData(
    'testString',
    'Updated from Background',
  );
  var a = await getIt<ScheduleLocalData>().getScheduleFromCache();
  var a2 = await getIt<ScheduleLocalData>().getActiveGroupFromCache();
  for (ScheduleModel schedule in a) {
    if (schedule.group == a2) {
      HomeWidget.saveWidgetData(
        'schedule',
        schedule.toRawJson(),
      );
    }
  }
  Map<String, int> days = {};
  DateTime now = DateTime.now();
  DateTime firstDayOfYear = DateTime(now.year, 1, 1, 0, 0);
  for (DateTime indexDay = DateTime(now.year, now.month, now.day);
      indexDay.year == now.year;
      indexDay = indexDay.add(const Duration(days: 1))) {
    //  print(indexDay.toString());
    days[indexDay.difference(firstDayOfYear).inDays.toString()] = min(
        Calendar.getCurrentWeek(mCurrentDate: indexDay),
        Calendar.kMaxWeekInSemester);
  }
  HomeWidget.saveWidgetData(
    'daysStuff',
    json.encode(days),
  );
  HomeWidget.updateWidget(
    name: 'HomeWidgetExampleProvider',
    androidName: 'HomeWidgetProvider',
    iOSName: 'HomeWidget',
  );
  final b = 1 + 1;
  // if (Platform.isIOS) {
  //   print('save some data');
  //   WidgetKit.setItem(
  //       'testString', 'Hello World', 'group.com.MireaNinja.rtuMireaApp');
  //   WidgetKit.reloadAllTimelines();
  // }
}
