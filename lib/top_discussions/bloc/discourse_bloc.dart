import 'dart:async';

import 'package:discourse_repository/discourse_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'discourse_event.dart';
part 'discourse_state.dart';

class DiscourseBloc extends Bloc<DiscourseEvent, DiscourseState> {
  DiscourseBloc({required DiscourseRepository discourseRepository})
    : _discourseRepository = discourseRepository,
      super(const DiscourseState.initial()) {
    on<DiscourseTopTopicsLoadRequest>(_onTopTopicsRequested);
  }

  final DiscourseRepository _discourseRepository;

  FutureOr<void> _onTopTopicsRequested(DiscourseTopTopicsLoadRequest event, Emitter<DiscourseState> emit) async {
    emit(state.copyWith(status: DiscourseStatus.loading));
    try {
      final results = await _discourseRepository.getTop();

      emit(state.copyWith(topTopics: results, status: DiscourseStatus.loaded));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: DiscourseStatus.failure));
      addError(error, stackTrace);
    }
  }
}
