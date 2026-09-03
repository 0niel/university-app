import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/watch/models/models.dart';
import 'package:schedule/schedule.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

part 'watch_connectivity_state.dart';
part 'watch_connectivity_cubit.freezed.dart';

class WatchConnectivityCubit extends Cubit<WatchConnectivityState> {
  WatchConnectivityCubit({WatchConnectivity? watchConnectivity})
    : _watchConnectivity = watchConnectivity ?? WatchConnectivity(),
      super(const WatchConnectivityState());

  final WatchConnectivity _watchConnectivity;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  void initialize() {
    if (isClosed || _messageSubscription != null || !_isSupportedPlatform) {
      return;
    }

    try {
      _messageSubscription = _watchConnectivity.messageStream.listen(
        _handleMessage,
        onError: (Object error) {
          log(
            'Watch connectivity error: $error',
            name: 'WatchConnectivityCubit',
          );
        },
      );
    } on MissingPluginException catch (error) {
      log(
        'Watch connectivity plugin is not available: $error',
        name: 'WatchConnectivityCubit',
      );
    }
  }

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == .android || defaultTargetPlatform == .iOS);

  void _handleMessage(Map<String, dynamic> messageData) {
    if (isClosed) return;
    final message = WatchMessage.fromMap(messageData);
    emit(state.copyWith(lastMessage: message));

    switch (message.action) {
      case .requestPassId:
        log('Watch requested pass ID', name: 'WatchConnectivityCubit');
      case .requestSchedule:
        log('Watch requested schedule', name: 'WatchConnectivityCubit');
      case .openPhoneAppForBinding:
        log(
          'Watch requested to open binding screen',
          name: 'WatchConnectivityCubit',
        );
      case .unknown:
        log(
          'Unknown watch action: ${messageData['action']}',
          name: 'WatchConnectivityCubit',
        );
    }
  }

  Future<void> sendPassId(String passId) async {
    if (!_isSupportedPlatform) {
      return;
    }

    final data = {'passId': passId};

    try {
      await _watchConnectivity.sendMessage(data);
      log(
        'Sent passId=$passId to watch (sendMessage)',
        name: 'WatchConnectivityCubit',
      );
    } on MissingPluginException catch (e) {
      log(
        'Watch connectivity plugin is not available: $e',
        name: 'WatchConnectivityCubit',
      );
    } on Exception catch (e) {
      log(
        'Failed to send message to watch: $e',
        name: 'WatchConnectivityCubit',
      );
    }

    try {
      await _watchConnectivity.updateApplicationContext(data);
      log(
        'Updated applicationContext passId=$passId',
        name: 'WatchConnectivityCubit',
      );
    } on MissingPluginException catch (e) {
      log(
        'Watch connectivity plugin is not available: $e',
        name: 'WatchConnectivityCubit',
      );
    } on Exception catch (e) {
      log(
        'Failed to update applicationContext: $e',
        name: 'WatchConnectivityCubit',
      );
    }
  }

  Future<void> sendSchedule(
    String scheduleName,
    List<SchedulePart> scheduleParts,
  ) async {
    if (!_isSupportedPlatform) {
      return;
    }

    final data = {
      'scheduleName': scheduleName,
      'scheduleParts': scheduleParts.map((part) => part.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      await _watchConnectivity.sendMessage(data);
      if (isClosed) return;
      emit(state.copyWith(lastScheduleSyncTime: DateTime.now()));
      log(
        'Sent schedule to watch: $scheduleName',
        name: 'WatchConnectivityCubit',
      );
    } on MissingPluginException catch (e) {
      log(
        'Watch connectivity plugin is not available: $e',
        name: 'WatchConnectivityCubit',
      );
    } on Exception catch (e) {
      log(
        'Failed to send schedule to watch: $e',
        name: 'WatchConnectivityCubit',
      );
    }

    try {
      await _watchConnectivity.updateApplicationContext(data);
      log(
        'Updated applicationContext with schedule',
        name: 'WatchConnectivityCubit',
      );
    } on MissingPluginException catch (e) {
      log(
        'Watch connectivity plugin is not available: $e',
        name: 'WatchConnectivityCubit',
      );
    } on Exception catch (e) {
      log(
        'Failed to update applicationContext: $e',
        name: 'WatchConnectivityCubit',
      );
    }
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    await super.close();
  }
}
