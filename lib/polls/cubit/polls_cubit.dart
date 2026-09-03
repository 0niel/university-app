import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'polls_state.dart';
part 'polls_cubit.freezed.dart';
part 'polls_status.dart';

class PollsCubit extends Cubit<PollsState> {
  PollsCubit({required this._campusRepository}) : super(const PollsState());

  final CampusRepository _campusRepository;
  Timer? _queryDebounce;
  int _request = 0;
  int _nextOffset = 0;
  bool _hasMore = false;
  bool _creating = false;
  final _pending = <String>{};
  bool get hasMore => _hasMore;
  bool isPending(String id) => _pending.contains(id);

  Future<void> load({bool more = false}) async {
    if (isClosed || (more && (!_hasMore || state.status == .loading))) return;
    final request = ++_request;
    final offset = more ? _nextOffset : 0;
    final previous = more ? state.polls : const <Poll>[];
    emit(state.copyWith(status: .loading));
    try {
      final polls = await _campusRepository.getPolls(
        filter: state.filter,
        category: state.category,
        query: state.query.trim().isEmpty ? null : state.query.trim(),
        offset: offset,
      );
      if (isClosed || request != _request) return;
      _nextOffset = offset + polls.length;
      _hasMore = polls.length == 20;
      final unique = {
        for (final poll in [...previous, ...polls]) poll.id: poll,
      };
      emit(state.copyWith(status: .populated, polls: unique.values.toList()));
    } on Exception catch (error, stackTrace) {
      if (isClosed || request != _request) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void setFilter(PollFilter filter) {
    if (isClosed || filter == state.filter) return;
    _queryDebounce?.cancel();
    _hasMore = false;
    emit(state.copyWith(filter: filter, polls: const []));
    unawaited(load());
  }

  void setCategory(PollCategory? category) {
    if (isClosed || category == state.category) return;
    _queryDebounce?.cancel();
    _hasMore = false;
    emit(state.copyWith(category: category, polls: const []));
    unawaited(load());
  }

  void setQuery(String query) {
    if (isClosed || query == state.query) return;
    _request++;
    _hasMore = false;
    emit(state.copyWith(query: query, polls: const [], status: .loading));
    _queryDebounce?.cancel();
    _queryDebounce = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(load()),
    );
  }

  Future<Poll?> createPoll({
    required String title,
    required List<PollQuestionDraft> questions,
    String description = '',
    PollCategory? category,
    bool isAnonymous = false,
    PollResultsVisibility resultsVisibility = PollResultsVisibility.always,
    DateTime? expiresAt,
    bool allowChange = false,
  }) async {
    if (isClosed ||
        _creating ||
        !validPollDraft(title, questions) ||
        description.length > 2000 ||
        (expiresAt != null && !expiresAt.isAfter(DateTime.now()))) {
      return null;
    }
    _creating = true;
    try {
      final poll = await _campusRepository.createPoll(
        title: title,
        description: description,
        category: category,
        isAnonymous: isAnonymous,
        resultsVisibility: resultsVisibility,
        expiresAt: expiresAt,
        allowChange: allowChange,
        questions: questions,
      );
      if (!isClosed) {
        if (state.filter == .all &&
            state.category == null &&
            state.query.trim().isEmpty &&
            state.status != .loading) {
          final isNew = !state.polls.any((item) => item.id == poll.id);
          emit(
            state.copyWith(
              status: .populated,
              polls: [poll, ...state.polls.where((item) => item.id != poll.id)],
            ),
          );
          if (isNew) _nextOffset++;
        } else {
          unawaited(load());
        }
      }
      return poll;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    } finally {
      _creating = false;
    }
  }

  Future<Poll?> submitAnswers({
    required Poll poll,
    required List<PollAnswer> answers,
  }) async {
    if (isClosed ||
        isPending(poll.id) ||
        poll.isEnded ||
        (poll.iParticipated && !poll.allowChange) ||
        !validPollAnswers(poll, answers)) {
      return null;
    }
    _pending.add(poll.id);
    try {
      final updated = await _campusRepository.submitPollAnswers(
        pollId: poll.id,
        answers: answers,
      );
      if (!isClosed) _replace(updated);
      return updated;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    } finally {
      _pending.remove(poll.id);
    }
  }

  Future<bool> closePoll(Poll poll) async {
    if (isClosed || !poll.isMine || poll.isEnded || isPending(poll.id)) {
      return false;
    }
    _pending.add(poll.id);
    try {
      final updated = await _campusRepository.closePoll(poll.id);
      if (!isClosed) _replace(updated);
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    } finally {
      _pending.remove(poll.id);
    }
  }

  Future<bool> deletePoll(Poll poll) async {
    if (isClosed || !poll.isMine || isPending(poll.id)) return false;
    _pending.add(poll.id);
    try {
      await _campusRepository.deletePoll(poll.id);
      if (!isClosed) {
        if (state.status == .loading) {
          unawaited(load());
        } else {
          final polls = state.polls
              .where((item) => item.id != poll.id)
              .toList();
          _nextOffset = (_nextOffset - (state.polls.length - polls.length))
              .clamp(0, _nextOffset);
          emit(state.copyWith(polls: polls));
        }
      }
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    } finally {
      _pending.remove(poll.id);
    }
  }

  void _replace(Poll updated) {
    if (state.status == .loading) {
      unawaited(load());
      return;
    }
    final matches = switch (state.filter) {
      .all => true,
      .active => !updated.isEnded,
      .closed => updated.isEnded,
      .mine => updated.isMine,
      .participated => updated.iParticipated,
    };
    final polls = [
      for (final poll in state.polls)
        if (poll.id != updated.id) poll else if (matches) updated,
    ];
    _nextOffset = (_nextOffset - (state.polls.length - polls.length)).clamp(
      0,
      _nextOffset,
    );
    emit(state.copyWith(polls: polls));
  }

  @override
  Future<void> close() {
    _queryDebounce?.cancel();
    _request++;
    return super.close();
  }
}

bool validPollDraft(String title, List<PollQuestionDraft> questions) {
  if (title.trim().isEmpty ||
      title.length > 200 ||
      questions.isEmpty ||
      questions.length > 10) {
    return false;
  }
  for (final question in questions) {
    if (question.text.trim().isEmpty || question.text.length > 300) {
      return false;
    }
    if (question.kind == .single ||
        question.kind == .multiple ||
        question.kind == .quiz) {
      final options = question.options.map((option) => option.trim()).toList();
      if (options.length < 2 ||
          options.length > 10 ||
          options.toSet().length != options.length ||
          options.any((option) => option.isEmpty || option.length > 200)) {
        return false;
      }
      if (question.kind == .quiz &&
          (question.correctIndex == null ||
              question.correctIndex! < 0 ||
              question.correctIndex! >= options.length)) {
        return false;
      }
    }
  }
  return true;
}

bool validPollAnswers(Poll poll, List<PollAnswer> answers) {
  if (answers.isEmpty ||
      answers.map((answer) => answer.questionId).toSet().length !=
          answers.length) {
    return false;
  }
  if (answers.any(
    (answer) =>
        !poll.questions.any((question) => question.id == answer.questionId),
  )) {
    return false;
  }
  for (final question in poll.questions) {
    final matches = answers.where((answer) => answer.questionId == question.id);
    if (matches.isEmpty) {
      if (question.isRequired) return false;
      continue;
    }
    final answer = matches.single;
    final hasAnswer =
        answer.optionIds.isNotEmpty ||
        (answer.text?.trim().isNotEmpty ?? false) ||
        answer.rating != null;
    if (!hasAnswer && !question.isRequired) continue;
    switch (question.kind) {
      case .single:
      case .quiz:
      case .multiple:
        if (answer.optionIds.isEmpty ||
            (question.kind != .multiple && answer.optionIds.length != 1) ||
            answer.text != null ||
            answer.rating != null) {
          return false;
        }
        if (answer.optionIds.toSet().length != answer.optionIds.length ||
            answer.optionIds.any(
              (id) => !question.options.any((option) => option.id == id),
            )) {
          return false;
        }
      case .text:
        if ((answer.text?.trim().isEmpty ?? true) ||
            answer.text!.length > 2000 ||
            answer.optionIds.isNotEmpty ||
            answer.rating != null) {
          return false;
        }
      case .rating:
        if (answer.rating == null ||
            answer.rating! < 1 ||
            answer.rating! > 5 ||
            answer.optionIds.isNotEmpty ||
            answer.text != null) {
          return false;
        }
    }
  }
  return answers.any(
    (answer) =>
        answer.optionIds.isNotEmpty ||
        (answer.text?.trim().isNotEmpty ?? false) ||
        answer.rating != null,
  );
}
