part of 'schedule_repository.dart';

/// Ключи для хранилища [ScheduleStorage].
abstract class ScheduleStorageKeys {
  /// Ключ для хранения расписания.
  static const schedules = '__schedule_key__';

  /// Возвращает ключ, связанный с группой [group] для хранения расписания
  /// указанной группы.
  static getScheduleKey(String group) => "$group$schedules";
}

/// {@template article_storage}
/// Хранилище для [ScheduleRepository].
/// {@endtemplate}
class ScheduleStorage {
  /// {@macro article_storage}
  const ScheduleStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Записывает расписание в хранилище.
  Future<void> setSchedule(ScheduleResponse schedule) async {
    await _storage.write(
      key: ScheduleStorageKeys.getScheduleKey(schedule.group),
      value: jsonEncode(schedule.toJson()),
    );
  }
}
