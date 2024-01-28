import 'dart:async';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';

/// Bloc for managing periodic timers.
sealed class TimerBloc extends Bloc {
  factory TimerBloc() => _instance ??= _TimerBloc._();

  @visibleForTesting
  factory TimerBloc.mocked(TimerBloc mock) => _instance ??= mock;

  static TimerBloc? _instance;

  @override
  void dispose() {
    TimerBloc._instance?.dispose();
    TimerBloc._instance = null;
  }

  /// Register a [callback] that will be called periodically.
  /// The time between the executions is defined by the [duration].
  NeonTimer registerTimer(Duration duration, VoidCallback callback);

  /// Unregister a timer that has been previously registered with the bloc.
  /// You can also use [NeonTimer.cancel].
  void unregisterTimer(NeonTimer timer);

  /// Registered timers.
  @visibleForTesting
  Map<int, Timer> get timers;

  /// Registered callbacks.
  @visibleForTesting
  Map<int, Set<VoidCallback>> get callbacks;
}

/// Execute callbacks at defined periodic intervals.
/// Components can register their callbacks and everything with the same periodicity will be executed at the same time.
///
/// The [TimerBloc] is a singleton.
/// Sub-second timers are not supported.
class _TimerBloc implements TimerBloc {
  _TimerBloc._();

  @override
  final Map<int, Timer> timers = {};
  @override
  final Map<int, Set<VoidCallback>> callbacks = {};

  @override
  void dispose() {
    for (final timer in timers.values) {
      timer.cancel();
    }
    timers.clear();
    callbacks.clear();
  }

  @override
  NeonTimer registerTimer(Duration duration, VoidCallback callback) {
    if (timers[duration.inSeconds] == null) {
      timers[duration.inSeconds] = Timer.periodic(duration, (_) {
        for (final callback in callbacks[duration.inSeconds]!) {
          callback();
        }
      });
      callbacks[duration.inSeconds] = {callback};
    } else {
      callbacks[duration.inSeconds]!.add(callback);
    }
    return NeonTimer._(duration, callback);
  }

  @override
  void unregisterTimer(NeonTimer timer) {
    if (timers[timer.duration.inSeconds] != null) {
      callbacks[timer.duration.inSeconds]!.remove(timer.callback);
    }
  }
}

/// A timer containing a [duration] and a [callback].
class NeonTimer {
  NeonTimer._(
    this.duration,
    this.callback,
  );

  /// Duration between executions
  final Duration duration;

  /// Callback to execute.
  final VoidCallback callback;

  /// Cancel the timer.
  void cancel() {
    TimerBloc().unregisterTimer(this);
  }
}
