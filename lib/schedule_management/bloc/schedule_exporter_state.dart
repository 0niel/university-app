part of 'schedule_exporter_cubit.dart';

/// Represents the state of the ScheduleExporterCubit.
class ScheduleExporterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;

  /// Creates an instance of [ScheduleExporterState].
  ///
  /// [isLoading] indicates if the export process is in progress.
  /// [isSuccess] indicates if the export process was successful.
  /// [errorMessage] stores the error message in case of failure.
  const ScheduleExporterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
  });

  /// Copies the current state and updates the fields with new values.
  ScheduleExporterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ScheduleExporterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage];
}
