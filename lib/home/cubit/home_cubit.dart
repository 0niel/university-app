import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
part 'home_state.dart';

class HomeCubit extends HydratedBloc<HomeEvent, HomeState> {
  HomeCubit() : super(AppInitial()) {
    on<CheckOnboardingEvent>(_onCheckOnboarding);
    on<CloseOnboardingEvent>(_onCloseOnboarding);
  }

  void _onCheckOnboarding(CheckOnboardingEvent event, Emitter<HomeState> emit) {
    final settings = state.settings;
    final isMobileApp = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;

    if (settings.onboardingShown == false && isMobileApp) {
      emit(AppOnboarding(settings: settings.copyWith(onboardingShown: true)));
    } else {
      emit(AppClean(settings: settings));
    }
  }

  void _onCloseOnboarding(CloseOnboardingEvent event, Emitter<HomeState> emit) {
    emit(AppClean(settings: state.settings));
  }

  void checkOnboarding() => add(CheckOnboardingEvent());

  void closeOnboarding() => add(CloseOnboardingEvent());

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    try {
      final settingsJson = json['settings'] as Map<String, dynamic>?;
      if (settingsJson == null) {
        return AppInitial(settings: AppSettings.defaultSettings());
      }

      final settings = AppSettings.fromJson(settingsJson);
      return AppInitial(settings: settings);
    } catch (e) {
      // If there's an error parsing the JSON, return default settings
      return AppInitial(settings: AppSettings.defaultSettings());
    }
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return {'settings': state.settings.toJson()};
  }
}

// Events
abstract class HomeEvent {}

class CheckOnboardingEvent extends HomeEvent {}

class CloseOnboardingEvent extends HomeEvent {}
