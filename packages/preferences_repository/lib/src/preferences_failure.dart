import 'package:equatable/equatable.dart';

/// {@template preferences_failure}
/// Base failure for the preferences repository operations.
/// {@endtemplate}
abstract class PreferencesFailure with EquatableMixin implements Exception {
  /// {@macro preferences_failure}
  const PreferencesFailure(this.error);

  /// The underlying error that was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@macro preferences_failure}
class GetPreferencesFailure extends PreferencesFailure {
  /// {@macro preferences_failure}
  const GetPreferencesFailure(super.error);
}

/// {@macro preferences_failure}
class SetPreferenceFailure extends PreferencesFailure {
  /// {@macro preferences_failure}
  const SetPreferenceFailure(super.error);
}

/// Indicates that a compare-and-set preference write used a stale revision.
class PreferenceConflictFailure extends SetPreferenceFailure {
  /// Creates a failed compare-and-set operation.
  const PreferenceConflictFailure(super.error);
}

/// {@macro preferences_failure}
class DeletePreferenceFailure extends PreferencesFailure {
  /// {@macro preferences_failure}
  const DeletePreferenceFailure(super.error);
}

/// Indicates a malformed response from the preference API.
class PreferencesResponseException implements Exception {
  /// Creates a response exception with [message].
  const PreferencesResponseException(this.message);

  /// Human-readable protocol error.
  final String message;

  @override
  String toString() => 'PreferencesResponseException: $message';
}

/// Indicates that the expected server revision is stale.
class PreferenceRevisionConflictException implements Exception {
  /// Creates a revision conflict.
  const PreferenceRevisionConflictException();

  @override
  String toString() => 'PreferenceRevisionConflictException';
}
