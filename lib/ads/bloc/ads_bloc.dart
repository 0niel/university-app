import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'ads_event.dart';
part 'ads_state.dart';
part 'ads_bloc.freezed.dart';
part 'ads_bloc.g.dart';

class AdsBloc extends HydratedBloc<AdsEvent, AdsState> {
  AdsBloc() : super(const AdsState()) {
    on<AdsVisibilityChanged>((event, emit) {
      emit(state.copyWith(showAds: event.showAds));
    });
  }

  @override
  AdsState fromJson(Map<String, dynamic> json) {
    try {
      return AdsState.fromJson(json);
    } on Object catch (_) {
      return const AdsState();
    }
  }

  @override
  Map<String, dynamic> toJson(AdsState state) => state.toJson();
}
