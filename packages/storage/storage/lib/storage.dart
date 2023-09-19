/// {@template storage_exception}
/// Исключение, если операция в хранилище не удалась.
/// {@endtemplate}
class StorageException implements Exception {
  /// {@macro storage_exception}
  const StorageException(this.error);

  /// Связанная ошибка.
  final Object error;
}

/// Интерфейс клиентского хранилища.
abstract class Storage {
  /// Возвращает значение по указанному ключу [key].
  /// Вернёт `null`, если по ключу [key] нет значения.
  /// * Выбросит [StorageException], если чтение не удалось.
  Future<String?> read({required String key});

  /// Записывает указанную пару [key], [value] асинхронно.
  /// * Выбросит [StorageException], если запись не удалась.
  Future<void> write({required String key, required String value});

  /// Удаляет значение по указанному ключу [key] асинхронно.
  /// * Выбросит [StorageException], если удаление не удалось.
  Future<void> delete({required String key});

  /// Удаляет все значения из хранилища асинхронно.
  /// * Выбросит [StorageException], если очистка не удалась.
  Future<void> clear();
}
