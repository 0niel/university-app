import 'dart:async';

import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contributors_event.dart';
part 'contributors_state.dart';

class ContributorsBloc extends Bloc<ContributorsEvent, ContributorsState> {
  ContributorsBloc({
    required CommunityRepository communityRepository,
  })  : _communityRepository = communityRepository,
        super(const ContributorsState.initial()) {
    on<ContributorsLoadRequest>(_onContributorsLoadRequest);
  }

  final CommunityRepository _communityRepository;

  FutureOr<void> _onContributorsLoadRequest(
    ContributorsLoadRequest event,
    Emitter<ContributorsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ContributorsStatus.loading,
      ),
    );
    try {
      final results = await _communityRepository.getContributors();

      emit(
        state.copyWith(
          contributors: results,
          status: ContributorsStatus.loaded,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ContributorsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
