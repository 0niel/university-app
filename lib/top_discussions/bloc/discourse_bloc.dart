import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discourse_event.dart';
part 'discourse_bloc.freezed.dart';
part 'discourse_state.dart';
part 'discourse_status.dart';

class DiscourseBloc extends Bloc<DiscourseEvent, DiscourseState> {
  DiscourseBloc(this._communityRepository) : super(const DiscourseState()) {
    on<DiscourseTopTopicsRequested>(
      _onTopTopicsRequested,
      transformer: droppable(),
    );
  }

  final CommunityRepository _communityRepository;

  FutureOr<void> _onTopTopicsRequested(
    DiscourseTopTopicsRequested event,
    Emitter<DiscourseState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final results = await _communityRepository.getTopTopics();

      emit(state.copyWith(topTopics: results, status: .loaded));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
