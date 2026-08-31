import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart' as analytics;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.dart';
part 'analytics_bloc.freezed.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({required this._analyticsRepository})
    : super(const AnalyticsState.initial()) {
    on<AnalyticsEventTracked>(_onAnalyticsEventTracked);
  }

  final analytics.AnalyticsRepository _analyticsRepository;

  Future<void> _onAnalyticsEventTracked(
    AnalyticsEventTracked event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await _analyticsRepository.track(event.event);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
