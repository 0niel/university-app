import 'dart:async';

import 'package:community_repository/community_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'neon_event.dart';
part 'neon_state.dart';

class NeonBloc extends HydratedBloc<NeonEvent, NeonState> {
  NeonBloc() : super(const NeonState.initial()) {
    on<VieweRegisterOffer>(_vieweRegisterOffer);
  }

  void _vieweRegisterOffer(
    VieweRegisterOffer event,
    Emitter<NeonState> emit,
  ) {
    emit(state.copyWith(isRegisterOfferViewed: true));
  }

  @override
  NeonState? fromJson(Map<String, dynamic> json) {
    return NeonState(
      isRegisterOfferViewed: json['isRegisterOfferViewed'] as bool,
    );
  }

  @override
  Map<String, dynamic>? toJson(NeonState state) {
    return {
      'isRegisterOfferViewed': state.isRegisterOfferViewed,
    };
  }
}
