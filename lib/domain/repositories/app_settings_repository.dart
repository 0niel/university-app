import 'package:rtu_mirea_app/domain/entities/app_settings.dart';

abstract class AppSettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> setSettings(AppSettings settings);
}
