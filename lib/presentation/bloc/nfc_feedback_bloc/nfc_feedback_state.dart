part of 'nfc_feedback_bloc.dart';

@freezed
class NfcFeedbackState with _$NfcFeedbackState {
  const factory NfcFeedbackState.initial() = _Initial;
  const factory NfcFeedbackState.loading() = _Loading;
  const factory NfcFeedbackState.success() = _Success;
  const factory NfcFeedbackState.failure(String message) = _Failure;
}
