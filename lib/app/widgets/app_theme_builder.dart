import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/app/utils/system_ui_configurator.dart';
import 'package:rtu_mirea_app/app/widgets/app_router.dart';
import 'package:rtu_mirea_app/app/widgets/root_app_wrapper.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';

class AppThemeBuilder extends StatelessWidget {
  const AppThemeBuilder({
    required this.theme,
    required this.darkTheme,
    required this.themeState,
    required this.themeCubit,
    required this.router,
    super.key,
  });

  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeState themeState;
  final ThemeCubit themeCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    configureSystemUI(theme);
    _updateThemeIfNeeded(context);

    final themeMode = theme.brightness == .light
        ? ThemeMode.light
        : ThemeMode.dark;
    final themeKey = [
      themeState.isAmoled,
      theme.brightness,
    ].join('-');
    final lessonTypeColors = context
        .watch<UiPreferencesCubit>()
        .state
        .lessonTypeColors;

    return LessonTypePalette(
      colors: lessonTypeColors,
      child: RootAppWrapper(
        key: ValueKey('app-theme-$themeKey'),
        child: AppRouter(
          router: router,
          theme: themeCubit.getLightTheme(),
          darkTheme: darkTheme,
          themeMode: themeMode,
        ),
      ),
    );
  }

  void _updateThemeIfNeeded(BuildContext context) {
    final isLight = theme.brightness == .light;
    final currentPrimary = theme.colorScheme.primary;
    final lightTheme = themeCubit.getLightTheme();
    final desiredLightPrimary = lightTheme.colorScheme.primary;
    final desiredDarkTheme = themeCubit.getDarkTheme();
    final desiredDarkPrimary = desiredDarkTheme.colorScheme.primary;
    final desiredPrimary = isLight ? desiredLightPrimary : desiredDarkPrimary;
    final desiredBackground = isLight
        ? lightTheme.scaffoldBackgroundColor
        : desiredDarkTheme.scaffoldBackgroundColor;

    if (currentPrimary != desiredPrimary ||
        theme.scaffoldBackgroundColor != desiredBackground) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AdaptiveTheme.of(
          context,
        ).setTheme(light: lightTheme, dark: desiredDarkTheme);
      });
    }
  }
}
