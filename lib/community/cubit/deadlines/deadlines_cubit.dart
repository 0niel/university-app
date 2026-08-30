import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadline_filter.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines_status.dart';
import 'package:rtu_mirea_app/community/models/deadline_draft.dart';
import 'package:rtu_mirea_app/community/view/deadline_buckets.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'deadlines_cubit.freezed.dart';
part 'deadlines_state.dart';

class DeadlinesCubit extends Cubit<DeadlinesState> {
  factory DeadlinesCubit({required ScheduleRepository repository}) =>
      DeadlinesCubit._(repository);

  DeadlinesCubit._(this._repository) : super(const DeadlinesState());

  final ScheduleRepository _repository;

  var _loadRevision = 0;
  var _deadlinesRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final deadlines = await _repository.getDeadlines();
      if (!_isCurrentLoad(revision)) return false;
      _deadlinesRevision++;
      emit(state.copyWith(status: .ready, deadlines: deadlines));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrentLoad(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  void filterChanged(DeadlineFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
  }

  Future<bool> toggleDone(String deadlineId) async {
    if (state.pendingDeadlineIds.contains(deadlineId)) return true;
    final previous = _deadlineById(deadlineId);
    if (previous == null || !previous.isMine) return false;

    final done = !previous.isDone;
    final deadlinesRevision = _deadlinesRevision;
    ++_loadRevision;
    _replaceDeadline(
      previous.copyWith(isDone: done),
      pendingDeadlineId: deadlineId,
    );

    try {
      await _repository.setDeadlineState(id: deadlineId, done: done);
      if (isClosed) return false;
      _clearPending(deadlineId);
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (isClosed) return false;
      if (_deadlinesRevision == deadlinesRevision) {
        _replaceDeadline(previous);
      } else {
        _clearPending(deadlineId);
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> createDeadline(DeadlineDraft draft) async {
    if (state.isCreating) return false;
    emit(state.copyWith(isCreating: true));
    try {
      await _repository.createDeadline(
        title: draft.title,
        subjectName: draft.subjectName,
        dueAt: draft.dueAt,
        source: draft.source,
        priority: draft.priority,
        remind: draft.remind,
      );
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      addError(error, stackTrace);
      return false;
    }
  }

  bool _isCurrentLoad(int revision) => !isClosed && revision == _loadRevision;

  Deadline? _deadlineById(String deadlineId) => state.deadlines
      .where((deadline) => deadline.id == deadlineId)
      .firstOrNull;

  void _replaceDeadline(
    Deadline replacement, {
    String? pendingDeadlineId,
  }) {
    final pending = {...state.pendingDeadlineIds};
    if (pendingDeadlineId == null) {
      pending.remove(replacement.id);
    } else {
      pending.add(pendingDeadlineId);
    }
    emit(
      state.copyWith(
        deadlines: [
          for (final deadline in state.deadlines)
            if (deadline.id == replacement.id) replacement else deadline,
        ],
        pendingDeadlineIds: pending,
      ),
    );
  }

  void _clearPending(String deadlineId) {
    emit(
      state.copyWith(
        pendingDeadlineIds: {...state.pendingDeadlineIds}..remove(deadlineId),
      ),
    );
  }
}
