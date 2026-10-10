import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_event.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_state.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_dashboard_repository.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_schedule_activator.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_dashboard_binding.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_query.dart';

export 'teacher_dashboard_event.dart';
export 'teacher_dashboard_state.dart';

class TeacherDashboardBloc
    extends Bloc<TeacherDashboardEvent, TeacherDashboardState> {
  TeacherDashboardBloc({
    required TeacherDashboardRepository repository,
    required this._activator,
    required AccountPersonaState account,
    required Stream<AccountPersonaState> accountChanges,
    DateTime Function()? clock,
  }) : _repository = repository,
       _clock = clock ?? DateTime.now,
       super(_initialState(repository, account, (clock ?? DateTime.now)())) {
    on<TeacherDashboardAccountChanged>(_onAccountChanged);
    on<TeacherDashboardScheduleRequested>(
      _onScheduleRequested,
      transformer: restartable(),
    );
    on<TeacherDashboardRatingRequested>(
      _onRatingRequested,
      transformer: restartable(),
    );
    on<TeacherDashboardRefreshRequested>(_onRefreshRequested);
    on<TeacherDashboardWeekChanged>(
      (event, emit) =>
          _selectDay(state.day.add(Duration(days: event.delta * 7)), emit),
    );
    on<TeacherDashboardDaySelected>(
      (event, emit) => _selectDay(event.day, emit),
    );
    on<TeacherDashboardTodayRequested>(
      (event, emit) => _selectDay(_clock(), emit),
    );
    on<TeacherDashboardClockTicked>(
      (event, emit) => emit(state.copyWith(now: event.now)),
    );
    on<TeacherDashboardActivityChanged>((event, emit) {
      _timer?.cancel();
      if (event.active) {
        emit(state.copyWith(now: _clock()));
        _startClock();
      }
    });
    on<TeacherDashboardNavigationCommand>(
      _onOpenScheduleRequested,
      transformer: restartable(),
    );
    on<TeacherDashboardNavigationHandled>(
      (event, emit) => emit(
        state.copyWith(navigation: const TeacherScheduleNavigation.idle()),
      ),
    );
    _accountSubscription = accountChanges.listen((account) {
      if (!isClosed) add(TeacherDashboardEvent.accountChanged(account));
    });
    _startClock();
    final query = state.query;
    if (query != null) {
      add(TeacherDashboardEvent.scheduleRequested(query));
      add(TeacherDashboardEvent.ratingRequested(query.teacher));
    }
  }

  final TeacherDashboardRepository _repository;
  final TeacherScheduleActivator _activator;
  final DateTime Function() _clock;
  late final StreamSubscription<AccountPersonaState> _accountSubscription;
  Timer? _timer;

  static TeacherDashboardState _initialState(
    TeacherDashboardRepository repository,
    AccountPersonaState account,
    DateTime now,
  ) {
    final day = DateTime(now.year, now.month, now.day);
    final week = day.subtract(Duration(days: day.weekday - 1));
    final binding = TeacherDashboardBinding.fromAccount(account);
    final teacher = binding.teacher;
    final cached = teacher == null
        ? null
        : repository.cachedSchedule(
            TeacherScheduleQuery(teacher: teacher, week: week),
          );
    return TeacherDashboardState(
      now: now,
      day: day,
      binding: binding,
      schedule: teacher == null
          ? const TeacherResource.idle()
          : TeacherResource.loading(previous: cached),
      rating: teacher == null
          ? const TeacherResource.idle()
          : const TeacherResource.loading(),
      workload: TeacherWorkload.fromSchedule(
        schedule: cached?.schedule ?? const [],
        weekStart: week,
      ),
    );
  }

  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isClosed) add(TeacherDashboardEvent.clockTicked(_clock()));
    });
  }

  void _onAccountChanged(
    TeacherDashboardAccountChanged event,
    Emitter<TeacherDashboardState> emit,
  ) {
    final binding = TeacherDashboardBinding.fromAccount(event.account);
    if (binding == state.binding) return;
    if (binding.teacher == state.teacher) {
      emit(state.copyWith(binding: binding));
      return;
    }
    final next = _initialState(
      _repository,
      event.account,
      state.now,
    ).copyWith(day: state.day);
    emit(_withWorkload(next));
    add(const TeacherDashboardEvent.navigationCancelled());
    final query = state.query;
    if (query != null) {
      add(TeacherDashboardEvent.scheduleRequested(query));
      add(TeacherDashboardEvent.ratingRequested(query.teacher));
    }
  }

  void _selectDay(DateTime selected, Emitter<TeacherDashboardState> emit) {
    final day = DateTime(selected.year, selected.month, selected.day);
    final previous = state.query;
    final next = state.copyWith(day: day);
    if (previous == next.query) {
      emit(next);
      return;
    }
    final query = next.query;
    add(const TeacherDashboardEvent.navigationCancelled());
    final cached = query == null ? null : _repository.cachedSchedule(query);
    emit(
      _withWorkload(
        next.copyWith(
          schedule: cached == null
              ? const TeacherResource.idle()
              : TeacherResource.ready(cached),
          changes: const TeacherResource.idle(),
          navigation: const TeacherScheduleNavigation.idle(),
        ),
      ),
    );
    if (query != null) add(TeacherDashboardEvent.scheduleRequested(query));
  }

  void _onRefreshRequested(
    TeacherDashboardRefreshRequested event,
    Emitter<TeacherDashboardState> emit,
  ) {
    final query = state.query;
    if (query == null) return;
    if (event.scope != TeacherDashboardRefreshScope.rating) {
      add(TeacherDashboardEvent.scheduleRequested(query));
    }
    if (event.scope != TeacherDashboardRefreshScope.schedule) {
      add(TeacherDashboardEvent.ratingRequested(query.teacher));
    }
  }

  Future<void> refresh() async {
    if (state.teacher == null || isClosed) return;
    final completion = stream
        .skipWhile(
          (state) => !state.schedule.isLoading && !state.rating.isLoading,
        )
        .where(
          (state) =>
              !state.schedule.isLoading &&
              !state.changes.isLoading &&
              !state.rating.isLoading,
        )
        .take(1)
        .drain<void>();
    add(const TeacherDashboardEvent.refreshRequested());
    await completion;
  }

  bool _accepts(
    TeacherScheduleQuery query,
    Emitter<TeacherDashboardState> emit,
  ) => !emit.isDone && state.query == query;

  TeacherDashboardState _withWorkload(TeacherDashboardState next) =>
      next.copyWith(
        workload: TeacherWorkload.fromSchedule(
          schedule: next.schedule.data?.schedule ?? const [],
          changes: next.changes.data ?? const [],
          weekStart: next.week,
        ),
      );

  Future<void> _onScheduleRequested(
    TeacherDashboardScheduleRequested event,
    Emitter<TeacherDashboardState> emit,
  ) async {
    final query = event.query;
    if (!_accepts(query, emit)) return;
    emit(
      state.copyWith(
        schedule: TeacherResource.loading(previous: state.schedule.data),
        changes: TeacherResource.loading(previous: state.changes.data),
      ),
    );
    await Future.wait([
      _loadSchedule(query, emit),
      _loadChanges(query, emit),
    ]);
  }

  Future<void> _loadSchedule(
    TeacherScheduleQuery query,
    Emitter<TeacherDashboardState> emit,
  ) async {
    try {
      final snapshot = await _repository.loadSchedule(query);
      if (_accepts(query, emit)) {
        emit(
          _withWorkload(
            state.copyWith(schedule: TeacherResource.ready(snapshot)),
          ),
        );
      }
    } on Exception {
      if (_accepts(query, emit)) {
        emit(
          state.copyWith(
            schedule: TeacherResource.failure(previous: state.schedule.data),
          ),
        );
      }
    }
  }

  Future<void> _loadChanges(
    TeacherScheduleQuery query,
    Emitter<TeacherDashboardState> emit,
  ) async {
    try {
      final changes = await _repository.loadChanges(query);
      if (_accepts(query, emit)) {
        emit(
          _withWorkload(
            state.copyWith(changes: TeacherResource.ready(changes)),
          ),
        );
      }
    } on Exception {
      if (_accepts(query, emit)) {
        emit(
          state.copyWith(
            changes: TeacherResource.failure(previous: state.changes.data),
          ),
        );
      }
    }
  }

  Future<void> _onRatingRequested(
    TeacherDashboardRatingRequested event,
    Emitter<TeacherDashboardState> emit,
  ) async {
    if (state.teacher != event.teacher) return;
    emit(
      state.copyWith(
        rating: TeacherResource.loading(previous: state.rating.data),
      ),
    );
    try {
      final profile = await _repository.loadRating(event.teacher);
      if (!emit.isDone && state.teacher == event.teacher) {
        emit(state.copyWith(rating: TeacherResource.ready(profile)));
      }
    } on Exception {
      if (!emit.isDone && state.teacher == event.teacher) {
        emit(
          state.copyWith(
            rating: TeacherResource.failure(previous: state.rating.data),
          ),
        );
      }
    }
  }

  Future<void> _onOpenScheduleRequested(
    TeacherDashboardNavigationCommand event,
    Emitter<TeacherDashboardState> emit,
  ) async {
    if (event is TeacherDashboardNavigationCancelled) {
      emit(state.copyWith(navigation: const TeacherScheduleNavigation.idle()));
      return;
    }
    final request = event as TeacherDashboardOpenScheduleRequested;
    final query = state.query;
    if (query == null) return;
    final destination = request.destination;
    emit(
      state.copyWith(
        navigation: TeacherScheduleNavigation.activating(destination),
      ),
    );
    await emit.forEach<ScheduleState>(
      _activator.activate(query.teacher, destination),
      onData: (selected) {
        if (!_accepts(query, emit)) return state;
        final failure =
            destination == TeacherScheduleDestination.calendar &&
            selected.status == ScheduleStatus.failure;
        return state.copyWith(
          navigation: failure
              ? TeacherScheduleNavigation.failure(destination)
              : TeacherScheduleNavigation.ready(destination),
        );
      },
      onError: (_, _) => !_accepts(query, emit)
          ? state
          : state.copyWith(
              navigation: TeacherScheduleNavigation.failure(destination),
            ),
    );
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _accountSubscription.cancel();
    await super.close();
  }
}
