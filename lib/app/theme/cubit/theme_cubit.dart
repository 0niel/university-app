import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void setColorScheme(AppColorScheme scheme) {
    if (state.colorScheme == scheme) return;
    emit(state.copyWith(colorScheme: scheme));
  }

  void setGlassEnabled({required bool enabled}) {
    emit(state.copyWith(glassEnabled: enabled));
  }

  ThemeData getLightTheme() => AppTheme.generateTheme(
    AppColorSchemes.getLightColors(state.colorScheme),
    Brightness.light,
    glassEnabled: state.glassEnabled,
  );

  ThemeData getDarkTheme() => AppTheme.generateTheme(
    AppColorSchemes.getDarkColors(state.colorScheme),
    Brightness.dark,
    glassEnabled: state.glassEnabled,
  );

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    try {
      final version = json['accentSelectionVersion'] as int? ?? 1;
      if (version < 2) {
        final restored = ThemeState.fromJson(json);
        return restored.colorScheme == AppColorScheme.green
            ? restored.copyWith(colorScheme: AppColorScheme.blue)
            : restored;
      }
      return ThemeState.fromJson(json);
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return const ThemeState();
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) => {
    ...state.toJson(),
    'accentSelectionVersion': 2,
  };
}
