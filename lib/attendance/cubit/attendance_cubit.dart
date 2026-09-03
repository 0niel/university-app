import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_state.dart';
import 'package:rtu_mirea_app/attendance/data/absences_repository.dart';
import 'package:rtu_mirea_app/attendance/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({
    required this._repository,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const AttendanceState());

  final AbsencesRepository _repository;
  final DateTime Function() _now;

  var _loadRevision = 0;
  var _nextId = 0;
  Future<void> _saveOperation = Future.value();

  Future<void> load() async {
    final revision = ++_loadRevision;
    await _saveOperation;
    if (isClosed || revision != _loadRevision) return;
    emit(state.copyWith(status: .loading, now: _now()));
    try {
      final absences = await _repository.load();
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .ready, absences: absences, now: _now()));
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void lessonsChanged(List<LessonSchedulePart> lessons) {
    if (lessons == state.lessons) return;
    emit(state.copyWith(lessons: lessons, now: _now()));
  }

  void toggleSubject(String subject) {
    final next = state.expandedSubject == subject ? null : subject;
    emit(state.copyWith(expandedSubject: () => next));
  }

  Future<bool> addAbsence({
    required String subject,
    required DateTime date,
    required AbsenceReason reason,
  }) {
    if (state.status != AttendanceStatus.ready ||
        subject.trim().isEmpty ||
        date.isBefore(state.semesterStart) ||
        DateTime(date.year, date.month, date.day).isAfter(state.today)) {
      return Future.value(false);
    }
    final now = _now();
    final absence = Absence(
      id: '${now.microsecondsSinceEpoch}-${_nextId++}',
      subject: subject.trim(),
      date: DateTime(date.year, date.month, date.day),
      reason: reason,
    );
    return _persist((current) => [...current, absence]);
  }

  Future<bool> attachCertificate(String id) => _persist(
    (current) => [
      for (final absence in current)
        absence.id == id ? absence.copyWith(reason: .sick) : absence,
    ],
  );

  Future<bool> removeAbsence(String id) => _persist(
    (current) => [
      for (final absence in current)
        if (absence.id != id) absence,
    ],
  );

  Future<bool> _persist(List<Absence> Function(List<Absence>) update) {
    final save = _saveOperation.then((_) async {
      if (isClosed || state.status != AttendanceStatus.ready) return false;
      final absences = update(state.absences);
      try {
        await _repository.save(absences);
        if (!isClosed) emit(state.copyWith(absences: absences, now: _now()));
        return true;
      } on Object catch (error, stackTrace) {
        if (!isClosed) addError(error, stackTrace);
        return false;
      }
    });
    _saveOperation = save.then((_) {});
    return save;
  }
}
