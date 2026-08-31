import 'dart:async';
import 'dart:developer';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver({required this.analyticsRepository});

  final AnalyticsRepository analyticsRepository;

  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      log('${bloc.runtimeType} $change', name: 'AppBlocObserver');
    }
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (event != null) {
      unawaited(
        _trackEvent(
          AnalyticsEvent('${bloc.runtimeType}_${event.runtimeType}'),
        ),
      );
    }
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('${bloc.runtimeType} $error', name: 'AppBlocObserver');
  }

  Future<void> _trackEvent(AnalyticsEvent event) async {
    try {
      await analyticsRepository.track(event);
    } on Object catch (error, stackTrace) {
      log(
        'Analytics tracking failed',
        name: 'AppBlocObserver',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
