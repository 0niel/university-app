import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'teacher_picker_bloc.freezed.dart';
part 'teacher_picker_event.dart';
part 'teacher_picker_state.dart';

class TeacherPickerBloc extends Bloc<TeacherPickerEvent, TeacherPickerState> {
  TeacherPickerBloc({
    required this._scheduleRepository,
    Teacher? selected,
    this.debounce = const Duration(milliseconds: 350),
  }) : super(
         TeacherPickerState(
           query: selected?.name.trim() ?? '',
           selected: selected?.isPickerLinkable == true ? selected : null,
           results: const TeacherResource.loading(),
         ),
       ) {
    on<TeacherPickerSearchRequested>(
      _onSearchRequested,
      transformer: restartable(),
    );
    on<TeacherPickerSelectionChanged>((event, emit) {
      final selected = event.teacher?.isPickerLinkable == true
          ? event.teacher
          : null;
      emit(
        state.copyWith(
          selected: selected,
          ambiguousNames: _ambiguousNames(state.teachers, selected),
        ),
      );
    });
    on<TeacherPickerTeacherSelected>((event, emit) {
      if (!event.teacher.isPickerLinkable) return;
      emit(
        state.copyWith(
          selected: event.teacher,
          ambiguousNames: _ambiguousNames(state.teachers, event.teacher),
        ),
      );
    });
  }

  final ScheduleRepository _scheduleRepository;
  final Duration debounce;
  bool _closing = false;

  Future<void> _onSearchRequested(
    TeacherPickerSearchRequested event,
    Emitter<TeacherPickerState> emit,
  ) async {
    if (_closing) return;
    final query = event.query.trim();
    emit(
      state.copyWith(query: query, results: const TeacherResource.loading()),
    );
    if (!event.immediate) {
      await emit.forEach<void>(
        Future<void>.delayed(debounce).asStream(),
        onData: (_) => state,
      );
      if (emit.isDone || _closing) return;
    }
    try {
      await emit.forEach<SearchTeachersResponse>(
        _scheduleRepository.searchTeachers(query: query).asStream(),
        onData: _catalogReady,
        onError: (_, _) => _closing
            ? state
            : state.copyWith(results: const TeacherResource.failure()),
      );
    } on Exception catch (_) {
      if (emit.isDone || _closing) return;
      emit(state.copyWith(results: const TeacherResource.failure()));
    }
  }

  TeacherPickerState _catalogReady(SearchTeachersResponse response) {
    if (_closing) return state;
    final unique = <String, Teacher>{};
    for (final teacher in response.results) {
      if (teacher.name.trim().isNotEmpty) unique[teacher.pickerKey] = teacher;
    }
    final teachers = unique.values.toList();
    return state.copyWith(
      results: TeacherResource.ready(teachers),
      ambiguousNames: _ambiguousNames(teachers, state.selected),
    );
  }

  @override
  Future<void> close() {
    _closing = true;
    return super.close();
  }

  Set<String> _ambiguousNames(List<Teacher> teachers, Teacher? selected) {
    final names = <String, int>{};
    for (final teacher in teachers) {
      names[teacher.pickerName] = (names[teacher.pickerName] ?? 0) + 1;
    }
    if (selected != null &&
        !teachers.any((teacher) => teacher.pickerKey == selected.pickerKey)) {
      names[selected.pickerName] = (names[selected.pickerName] ?? 0) + 1;
    }
    return {
      ...state.ambiguousNames,
      for (final name in names.entries)
        if (name.value > 1) name.key,
    };
  }
}
