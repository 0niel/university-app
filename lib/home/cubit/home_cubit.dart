import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';
part 'home_cubit.g.dart';

class HomeCubit extends HydratedCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  @override
  String get storagePrefix => 'HomeCubit';

  void closeOnboarding() => emit(
    state.copyWith(settings: state.settings.copyWith(onboardingShown: true)),
  );

  void resetOnboarding() => emit(
    state.copyWith(settings: state.settings.copyWith(onboardingShown: false)),
  );

  void dismissSearchCoach() => emit(state.copyWith(searchCoachShown: true));

  @override
  HomeState fromJson(Map<String, dynamic> json) {
    try {
      return HomeState.fromJson(json);
    } on Object catch (_) {
      return const HomeState();
    }
  }

  @override
  Map<String, dynamic> toJson(HomeState state) => state.toJson();
}
