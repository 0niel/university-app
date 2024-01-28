import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/utils/request_manager.dart';

/// A Bloc for implementing the Business Logic Component pattern.
///
/// This design pattern helps to separate presentation from business logic.
/// Following the BLoC pattern facilitates testability and reusability.
///
/// If you are new to Flutter you might want to read:
/// https://www.didierboelens.com/blog/en/reactive-programming-streams-bloc
abstract class Bloc implements Disposable {
  @override
  @mustCallSuper
  void dispose();
}

/// A bloc implementing basic data fetching.
///
/// See:
///   * [Bloc]: for a generic bloc.
abstract class InteractiveBloc extends Bloc {
  @override
  void dispose() {
    unawaited(_errorsStreamController.close());
  }

  final _errorsStreamController = StreamController<Object>();

  /// A stream of error events.
  late Stream<Object> errors = _errorsStreamController.stream.asBroadcastStream();

  /// Refreshes the state of the bloc.
  ///
  /// Commonly involves re-fetching data from the server.
  Future<void> refresh();

  /// Adds an error to the [errors] state.
  @protected
  void addError(Object error) {
    _errorsStreamController.add(error);
  }

  /// Wraps the given [action].
  ///
  /// If [disableTimeout] is `true` [RequestManager] will apply the default
  /// timeout. On success the state will be refreshed through the [refresh]
  /// callback falling back to [this.refresh] if not supplied. Any errors will
  /// be forwarded to [addError].
  @protected
  // ignore: avoid_void_async
  void wrapAction(
    AsyncCallback action, {
    bool disableTimeout = false,
    AsyncCallback? refresh,
  }) async {
    try {
      if (disableTimeout) {
        await action();
      } else {
        await RequestManager.instance.timeout(action);
      }

      await (refresh ?? this.refresh)();
    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      addError(error);
    }
  }
}
