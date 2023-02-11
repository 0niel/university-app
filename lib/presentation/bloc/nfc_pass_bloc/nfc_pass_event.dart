part of 'nfc_pass_bloc.dart';

@freezed
class NfcPassEvent with _$NfcPassEvent {
  const factory NfcPassEvent.started() = _Started;
  const factory NfcPassEvent.connectNfcPass(
          String code, String studentId, String deviceId, String deviceName) =
      _ConnectNfcPass;
  const factory NfcPassEvent.getNfcPasses(
      String code, String studentId, String deviceId) = _GetNfcPasses;
}
