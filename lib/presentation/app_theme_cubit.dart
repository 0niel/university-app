import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


class AppThemeCubit extends Cubit<AppThemeState> {
  final GetAppSettings getAppSettings;
  final SetAppSettings setAppSettings;

  AppThemeCubit({required this.getAppSettings, required this.setAppSettings})
      : super(AppInitialState()) {
    init();
  }

  void init() async {
    final settings = await getAppSettings();

    AppThemeType themeType = AppThemeType.values.firstWhere(
      (element) => element.toString() == settings.theme,
      orElse: () => AppThemeType.dark,
    );

    _changeTheme(themeType);

    emit(AppLoadedState(themeType));
  }

  void updateTheme(AppThemeType themeType) async {
    _changeTheme(themeType);

    emit(AppLoadedState(themeType));

    await updateInStorage(themeType);
  }

  Future<void> updateInStorage(AppThemeType themeType) async {
    final settings = await getAppSettings();

    await setAppSettings(
      SetAppSettingsParams(
        AppSettings(
          onboardingShown: settings.onboardingShown,
          lastUpdateVersion: settings.lastUpdateVersion,
          theme: themeType.toString(),
        ),
      ),
    );
  }

  void _changeTheme(AppThemeType themeType) {
    AppTheme.changeThemeType(themeType);
    // Reset custom theme here if needed
  }
}

abstract class AppThemeState {
  ThemeMode get themeMode => AppTheme.themeMode;
}

class AppInitialState extends AppThemeState {}

class AppLoadedState extends AppThemeState {
  final AppThemeType themeType;

  AppLoadedState(this.themeType);
}
