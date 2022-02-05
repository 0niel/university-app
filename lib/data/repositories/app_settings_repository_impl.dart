import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/datasources/app_settings_local.dart';
import 'package:rtu_mirea_app/data/models/app_settings_model.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocal localDataSource;

  AppSettingsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<AppSettings> getSettings() async {
    try {
      final settings = await localDataSource.getSettingsFromCache();
      return settings;
    } on CacheException {
      const newLocalSettings = AppSettingsModel(
        onboardingShown: false,
        lastUpdateVersion: '',
      );
      await localDataSource.setSettingsToCache(newLocalSettings);
      return newLocalSettings;
    }
  }

  @override
  Future<void> setSettings(AppSettings settings) async {
    localDataSource.setSettingsToCache(
      AppSettingsModel(
        onboardingShown: settings.onboardingShown,
        lastUpdateVersion: settings.lastUpdateVersion,
      ),
    );
  }
}
