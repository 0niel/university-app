import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear/schedule/cubit/schedule_status.dart';

part 'schedule_state.dart';
part 'schedule_cubit.freezed.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit({
    WatchConnectivity? watchConnectivity,
    FlutterSecureStorage? secureStorage,
  }) : _watchConnectivity = watchConnectivity ?? WatchConnectivity(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       super(const ScheduleState());

  final WatchConnectivity _watchConnectivity;
  final FlutterSecureStorage _secureStorage;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _contextSubscription;

  int _calculateInitialDayIndex(List<SchedulePart> parts) {
    final lessons = parts.whereType<LessonSchedulePart>().toList();
    if (lessons.isEmpty) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final uniqueDays = <DateTime>{};
    for (final lesson in lessons) {
      for (final date in lesson.dates) {
        uniqueDays.add(DateTime(date.year, date.month, date.day));
      }
    }
    if (uniqueDays.isEmpty) return 0;

    final sortedDays = uniqueDays.toList()..sort();
    final [..., lastDay] = sortedDays;
    final upcomingDay = sortedDays.firstWhere(
      (day) => !day.isBefore(today),
      orElse: () => lastDay,
    );
    final difference = upcomingDay.difference(today).inDays;
    return difference >= 0 ? difference : 0;
  }

  Future<void> initialize() async {
    emit(state.copyWith(status: ScheduleStatus.loading));

    await _loadCachedSchedule();
    await _checkConnectivity();
    _listenToMessages();

    if (state.scheduleParts == null) {
      await requestScheduleFromPhone();
    } else {
      emit(state.copyWith(status: ScheduleStatus.loaded));
    }
  }

  Future<void> _loadCachedSchedule() async {
    try {
      final cachedJson = await _secureStorage.read(key: 'cached_schedule');
      if (cachedJson != null) {
        final json = _decodeSchedulePayload(jsonDecode(cachedJson));
        final scheduleName = json['scheduleName'];
        final scheduleParts = json['scheduleParts'];
        if (scheduleName is! String || scheduleParts is! List<Object?>) {
          throw const FormatException('Invalid cached schedule payload');
        }
        final parts = scheduleParts.map(_schedulePartFromJson).toList();
        final dayIndex = _calculateInitialDayIndex(parts);
        emit(
          state.copyWith(
            scheduleName: scheduleName,
            scheduleParts: parts,
            currentDayIndex: dayIndex,
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint('Failed to load cached schedule: $e');
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final isPaired = await _watchConnectivity.isPaired;
      final isReachable = await _watchConnectivity.isReachable;
      emit(
        state.copyWith(
          isPaired: isPaired,
          isReachable: isReachable,
        ),
      );
    } on Exception catch (e) {
      debugPrint('Failed to check connectivity: $e');
    }
  }

  void _listenToMessages() {
    _messageSubscription = _watchConnectivity.messageStream.listen(
      _handleMessage,
      onError: (Object error) => debugPrint('Message stream error: $error'),
    );

    _contextSubscription = _watchConnectivity.contextStream.listen(
      _handleMessage,
      onError: (Object error) => debugPrint('Context stream error: $error'),
    );
  }

  void _handleMessage(Map<String, Object?> message) {
    try {
      if (message.containsKey('scheduleName') &&
          message.containsKey('scheduleParts')) {
        final scheduleName = message['scheduleName'];
        final scheduleParts = message['scheduleParts'];
        if (scheduleName is! String || scheduleParts is! List<Object?>) {
          throw const FormatException('Invalid schedule payload');
        }
        final parts = scheduleParts.map(_schedulePartFromJson).toList();
        final dayIndex = _calculateInitialDayIndex(parts);
        unawaited(_cacheSchedule(scheduleName, parts));
        emit(
          state.copyWith(
            scheduleName: scheduleName,
            scheduleParts: parts,
            status: ScheduleStatus.loaded,
            currentDayIndex: dayIndex,
          ),
        );
      }
    } on Exception catch (e) {
      debugPrint('Failed to handle message: $e');
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  Future<void> _cacheSchedule(
    String scheduleName,
    List<SchedulePart> parts,
  ) async {
    try {
      final json = jsonEncode({
        'scheduleName': scheduleName,
        'scheduleParts': parts.map((p) => p.toJson()).toList(),
      });
      await _secureStorage.write(key: 'cached_schedule', value: json);
    } on Exception catch (e) {
      debugPrint('Failed to cache schedule: $e');
    }
  }

  Map<String, Object?> _decodeSchedulePayload(Object? value) {
    if (value case final Map<String, Object?> payload) return payload;
    throw const FormatException('Schedule payload must be a JSON object');
  }

  SchedulePart _schedulePartFromJson(Object? value) {
    if (value case final Map<String, Object?> json) {
      return SchedulePart.fromJson(json);
    }
    throw const FormatException('Schedule part must be a JSON object');
  }

  Future<void> requestScheduleFromPhone() async {
    emit(state.copyWith(status: ScheduleStatus.loading));

    try {
      await _watchConnectivity.sendMessage({'action': 'requestSchedule'});
    } on Exception catch (e) {
      debugPrint('Failed to request schedule: $e');
      emit(state.copyWith(status: ScheduleStatus.error));
    }
  }

  void setCurrentDayIndex(int index) {
    if (index < 0) return;
    emit(state.copyWith(currentDayIndex: index));
  }

  void nextDay() {
    if (state.scheduleParts == null) return;
    emit(state.copyWith(currentDayIndex: state.currentDayIndex + 1));
  }

  void previousDay() {
    if (state.scheduleParts == null || state.currentDayIndex == 0) return;
    emit(state.copyWith(currentDayIndex: state.currentDayIndex - 1));
  }

  @override
  Future<void> close() async {
    await Future.wait([
      ?_messageSubscription?.cancel(),
      ?_contextSubscription?.cancel(),
    ]);
    await super.close();
  }
}
