import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rtu_mirea_app/data/models/app_settings_model.dart';

abstract class AppSettingsLocal {
  Future<AppSettingsModel> getSettingsFromCache();
  Future<void> setSettingsToCache(AppSettingsModel settings);
}

class AppSettingsLocalImpl implements AppSettingsLocal {
  final SharedPreferences sharedPreferences;

  AppSettingsLocalImpl({
    required this.sharedPreferences,
  });

  @override
  Future<AppSettingsModel> getSettingsFromCache() {
    String? settings = sharedPreferences.getString('app_settings');
    if (settings == null) throw CacheException('The app settings are not set');
    return Future.value(AppSettingsModel.fromRawJson(settings));
  }

  @override
  Future<void> setSettingsToCache(AppSettingsModel settings) {
    return sharedPreferences.setString('app_settings', settings.toRawJson());
  }
}
