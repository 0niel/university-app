import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AppNotifier extends ChangeNotifier {
  final GetAppSettings getAppSettings;
  final SetAppSettings setAppSettings;

  AppNotifier({required this.getAppSettings, required this.setAppSettings}) {
    init();
  }

  init() async {
    final settings = await getAppSettings();

    AppThemeType themeType = AppThemeType.values.firstWhere(
      (element) => element.toString() == settings.theme,
      orElse: () => AppThemeType.dark,
    );

    _changeTheme(themeType);

    notifyListeners();
  }

  updateTheme(AppThemeType themeType) {
    _changeTheme(themeType);

    notifyListeners();

    updateInStorage(themeType);
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
