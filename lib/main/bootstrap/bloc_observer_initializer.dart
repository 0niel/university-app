import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/main/bootstrap/app_bloc_observer.dart';
import 'package:analytics_repository/analytics_repository.dart';
import 'package:yx_scope/yx_scope.dart';

class BlocObserverInitializer implements AsyncLifecycle {
  BlocObserverInitializer({required AnalyticsRepository analyticsRepository})
    : _observer = AppBlocObserver(analyticsRepository: analyticsRepository);

  final AppBlocObserver _observer;

  @override
  Future<void> init() async {
    Bloc.observer = _observer;
  }

  @override
  Future<void> dispose() async {
    Bloc.observer = _DefaultBlocObserver();
  }
}

class _DefaultBlocObserver extends BlocObserver {
  const _DefaultBlocObserver();
}
