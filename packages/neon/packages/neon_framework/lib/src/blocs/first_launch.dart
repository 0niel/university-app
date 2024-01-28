import 'dart:async';

import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:rxdart/rxdart.dart';

/// Bloc that manages tasks that only need to run at the first launch of the app.
sealed class FirstLaunchBloc implements Disposable {
  @internal
  factory FirstLaunchBloc({
    bool disabled = false,
  }) =>
      _FirstLaunchBloc(disabled: disabled);

  /// Emits an event if the first launch tasks should be run.
  BehaviorSubject<void> get onFirstLaunch;
}

@immutable
class _FirstLaunchBloc extends Bloc implements FirstLaunchBloc {
  _FirstLaunchBloc({
    bool disabled = false,
  }) {
    const storage = SingleValueStorage(StorageKeys.firstLaunch);

    if (!disabled && !storage.hasValue()) {
      onFirstLaunch.add(null);
      unawaited(storage.setBool(false));
    }
  }

  @override
  void dispose() {
    unawaited(onFirstLaunch.close());
  }

  @override
  final BehaviorSubject<void> onFirstLaunch = BehaviorSubject();
}
