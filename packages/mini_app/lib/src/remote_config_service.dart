class RemoteConfigService {
  static Map<String, dynamic> _config = {};

  static void setConfig(Map<String, dynamic> config) {
    _config = config;
    print('Remote config установлен: $_config');
  }

  static dynamic getValue(String key) => _config[key];

  /// Проверка флага включения для модуля.
  /// В конфигурации ожидаются ключи вида "module_calendar_enabled"
  static bool isModuleEnabled(String moduleId) {
    return _config['module_${moduleId}_enabled'] ?? false;
  }

  /// Получение требуемой версии модуля из удалённой конфигурации.
  /// В конфигурации ожидается ключ "module_calendar_version"
  static String? getModuleVersion(String moduleId) {
    return _config['module_${moduleId}_version'];
  }
}
