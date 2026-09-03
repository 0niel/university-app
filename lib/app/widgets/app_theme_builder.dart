import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/app/utils/system_ui_configurator.dart';
import 'package:rtu_mirea_app/app/widgets/app_router.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';

class AppThemeBuilder extends StatelessWidget {
  const AppThemeBuilder({
    required this.theme,
    required this.themeState,
    required this.themeCubit,
    required this.router,
    super.key,
  });

  final ThemeData theme;
  final ThemeState themeState;
  final ThemeCubit themeCubit;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final lightTheme = themeCubit.getLightTheme();
    final currentDarkTheme = themeCubit.getDarkTheme();
    configureSystemUI(
      theme.brightness == .light ? lightTheme : currentDarkTheme,
    );
    _updateThemeIfNeeded(context, lightTheme, currentDarkTheme);

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
      child: AppRouter(
        key: ValueKey('app-theme-$themeKey'),
        router: router,
        theme: lightTheme,
        darkTheme: currentDarkTheme,
        themeMode: themeMode,
      ),
    );
  }

  void _updateThemeIfNeeded(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData currentDarkTheme,
  ) {
    final manager = AdaptiveTheme.of(context);
    if (manager.lightTheme.colors != lightTheme.colors ||
        manager.darkTheme.colors != currentDarkTheme.colors) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted || themeCubit.isClosed) return;
        manager.setTheme(
          light: themeCubit.getLightTheme(),
          dark: themeCubit.getDarkTheme(),
        );
      });
    }
  }
}
