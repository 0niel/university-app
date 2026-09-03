import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_state.dart';
import 'package:rtu_mirea_app/grades/data/grades_repository.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';

export 'grades_state.dart';

class GradesCubit extends Cubit<GradesState> {
  GradesCubit({
    required this._repository,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const GradesState());

  final GradesRepository _repository;
  final DateTime Function() _now;

  var _loadRevision = 0;
  Future<void> _saveOperation = Future.value();

  Future<void> load() async {
    final revision = ++_loadRevision;
    await _saveOperation;
    if (isClosed || revision != _loadRevision) return;
    final now = _now();
    final terms = GradesTerm.recent(now);
    emit(
      state.copyWith(
        status: .loading,
        terms: terms,
        termId: state.termId.isEmpty ? terms.first.id : state.termId,
        now: now,
      ),
    );
    try {
      final book = await _repository.load();
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .ready, book: book, now: _now()));
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void termChanged(String termId) {
    if (termId == state.termId) return;
    emit(state.copyWith(termId: termId));
  }

  void scheduleSubjectsChanged(List<SubjectGrades> subjects) {
    if (subjects == state.scheduleSubjects) return;
    emit(state.copyWith(scheduleSubjects: subjects));
  }

  Future<bool> addMark({
    required String subject,
    required int value,
    String teacher = '',
  }) {
    if (state.status != GradesStatus.ready ||
        subject.trim().isEmpty ||
        value < 2 ||
        value > 5) {
      return Future.value(false);
    }
    final now = _now();
    final termId = state.termId;
    final subjectName = subject.trim();
    return _persist(termId, (existing) {
      final index = existing.indexWhere(
        (entry) => entry.subject == subjectName,
      );
      final target = index >= 0
          ? existing[index]
          : SubjectGrades(subject: subjectName, teacher: teacher.trim());
      final updated = target.copyWith(
        marks: [
          ...target.marks,
          GradeMark(value: value, date: now),
        ],
      );
      return [
        if (index >= 0)
          for (var i = 0; i < existing.length; i++)
            i == index ? updated : existing[i]
        else ...[...existing, updated],
      ];
    });
  }

  Future<bool> removeLastMark(String subject) {
    return _persist(state.termId, (existing) {
      final index = existing.indexWhere((entry) => entry.subject == subject);
      if (index < 0 || existing[index].marks.isEmpty) return existing;
      final target = existing[index];
      final updated = target.copyWith(
        marks: target.marks.sublist(0, target.marks.length - 1),
      );
      return [
        for (var i = 0; i < existing.length; i++)
          i == index ? updated : existing[i],
      ];
    });
  }

  Future<bool> _persist(
    String termId,
    List<SubjectGrades> Function(List<SubjectGrades>) update,
  ) {
    final save = _saveOperation.then((_) async {
      if (isClosed || state.status != GradesStatus.ready) return false;
      final now = _now();
      final book = state.book.withTerm(
        termId,
        update(state.book.of(termId)),
        savedAt: now,
      );
      try {
        await _repository.save(book);
        if (!isClosed) emit(state.copyWith(book: book, now: now));
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
