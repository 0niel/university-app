import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';
import 'package:rtu_mirea_app/app/widgets/app_theme_builder.dart';

class AdaptiveThemeWrapper extends StatelessWidget {
  const AdaptiveThemeWrapper({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final themeCubit = context.read<ThemeCubit>();
        final lightTheme = themeCubit.getLightTheme();
        final darkTheme = themeCubit.getDarkTheme();

        return AdaptiveTheme(
          light: lightTheme,
          dark: darkTheme,
          initial: .dark,
          builder: (theme, _) => AppThemeBuilder(
            theme: theme,
            themeState: themeState,
            themeCubit: themeCubit,
            router: router,
          ),
        );
      },
    );
  }
}
