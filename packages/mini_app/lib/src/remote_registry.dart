import 'dart:convert';

class ModuleInfo {
  ModuleInfo({
    required this.id,
    required this.name,
    required this.author,
    required this.version,
    required this.enabled,
    this.updateUrl,
  });

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      author: json['author'] as String,
      version: json['version'] as String,
      enabled: json['enabled'] as bool,
      updateUrl: json['updateUrl'] as String?,
    );
  }
  final String id;
  final String name;
  final String author;
  final String version;
  final bool enabled;
  final String? updateUrl;
}

/// Симуляция запроса к удалённому реестру модулей.
/// Здесь можно заменить на http-запрос к файлу на GitHub.
Future<List<ModuleInfo>> fetchRemoteModuleRegistry() async {
  await Future.delayed(const Duration(seconds: 1)); // Симуляция задержки
  const jsonString = '''
  [
    {
      "id": "calendar",
      "name": "Календарь",
      "author": "Команда Календаря",
      "version": "1.0.0",
      "enabled": true,
      "updateUrl": "https://example.com/modules/calendar/update"
    },
    {
      "id": "news",
      "name": "Новости",
      "author": "Команда Новостей",
      "version": "1.0.0",
      "enabled": false
    }
  ]
  ''';
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((json) => ModuleInfo.fromJson(json)).toList();
}
