import 'package:event_bus/event_bus.dart';

/// Глобальный экземпляр EventBus для обмена событиями между модулями
EventBus eventBus = EventBus();

/// Пример события для модулей
class ModuleEvent {
  ModuleEvent(this.moduleId, this.message);
  final String moduleId;
  final String message;
}

/// Фоновая инициализация удалённых настроек
Future<void> _initializeRemoteSettings() async {
  try {
    // Получаем удалённую конфигурацию из файла на GitHub
    const configUrl = 'https://raw.githubusercontent.com/yourusername/yourrepo/main/config.json';
    final remoteConfigClient = RemoteConfigClient(configUrl: configUrl);
    final config = await remoteConfigClient.fetchConfig();
    RemoteConfigService.setConfig(config);

    // Получаем удалённый реестр модулей (в фоне)
    final remoteModules = await fetchRemoteModuleRegistry();
    for (final moduleInfo in remoteModules) {
      // Пример проверки: флаг из удалённой конфигурации, включение модуля и проверка версии
      final bool featureEnabled = RemoteConfigService.isModuleEnabled(moduleInfo.id);
      final String? requiredVersion = RemoteConfigService.getModuleVersion(moduleInfo.id);
      if (moduleInfo.enabled && featureEnabled && (requiredVersion == moduleInfo.version)) {
        if (moduleInfo.id == 'calendar') {
          registerCalendarMiniApp();
        }
        // Здесь можно добавить регистрацию других модулей, например:
        // if (moduleInfo.id == 'news') { registerNewsMiniApp(); }
      } else {
        print('Модуль ${moduleInfo.id} не соответствует требованиям или отключён');
      }
    }
  } catch (e) {
    print('Ошибка при загрузке удалённой конфигурации или реестра модулей: $e');
  }
}
