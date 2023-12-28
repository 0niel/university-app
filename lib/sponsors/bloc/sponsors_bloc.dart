import 'dart:async';

import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sponsors_event.dart';
part 'sponsors_state.dart';

class SponsorsBloc extends Bloc<SponsorsEvent, SponsorsState> {
  SponsorsBloc({
    required CommunityRepository communityRepository,
  })  : _communityRepository = communityRepository,
        super(const SponsorsState.initial()) {
    on<SponsorsLoadRequest>(_onSponsorsLoadRequest);
  }

  final CommunityRepository _communityRepository;

  FutureOr<void> _onSponsorsLoadRequest(
    SponsorsLoadRequest event,
    Emitter<SponsorsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SponsorsStatus.loading,
      ),
    );
    try {
      final results = await _communityRepository.getSponsors();

      emit(
        state.copyWith(
          sponsors: results,
          status: SponsorsStatus.loaded,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SponsorsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
