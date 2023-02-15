part of 'nfc_pass_bloc.dart';

@freezed
class NfcPassEvent with _$NfcPassEvent {
  const factory NfcPassEvent.started() = _Started;
  const factory NfcPassEvent.connectNfcPass(
          String code, String studentId, String deviceId, String deviceName) =
      _ConnectNfcPass;
  const factory NfcPassEvent.getNfcPasses(
      String code, String studentId, String deviceId) = _GetNfcPasses;

  /// Event for fetching NFC code from server. If device is connected to the
  /// server, it will return NFC code. If not, it will clear NFC code from
  /// the device (Secure Storage)
  ///
  /// This event must be called after application is started, user is logged in
  /// and device is connected to the server.
  const factory NfcPassEvent.fetchNfcCode() = _FetchNfcCode;
}
