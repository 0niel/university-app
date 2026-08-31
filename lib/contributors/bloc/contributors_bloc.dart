import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contributors_event.dart';
part 'contributors_bloc.freezed.dart';
part 'contributors_state.dart';
part 'contributors_status.dart';

class ContributorsBloc extends Bloc<ContributorsEvent, ContributorsState> {
  ContributorsBloc({required this.communityRepository})
    : super(const ContributorsState()) {
    on<ContributorsRequested>(
      _onContributorsRequested,
      transformer: droppable(),
    );
  }

  final CommunityRepository communityRepository;

  FutureOr<void> _onContributorsRequested(
    ContributorsRequested event,
    Emitter<ContributorsState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final results = await communityRepository.getContributors();

      emit(
        state.copyWith(
          contributors: results,
          status: .loaded,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
