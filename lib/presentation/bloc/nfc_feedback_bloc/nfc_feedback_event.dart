part of 'nfc_feedback_bloc.dart';

@freezed
class NfcFeedbackEvent with _$NfcFeedbackEvent {
  const factory NfcFeedbackEvent.started() = _Started;
  const factory NfcFeedbackEvent.sendFeedback({
    required String fullName,
    required String group,
    required String personalNumber,
    required String studentId,
  }) = _SendFeedback;
}
