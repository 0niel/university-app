part of 'nfc_pass_bloc.dart';

@freezed
class NfcPassState with _$NfcPassState {
  const factory NfcPassState.initial() = _Initial;

  /// Loading state when the app is tring to get Device NFC availability status
  /// and get NFC passes from the server
  const factory NfcPassState.loading() = _Loading;
  const factory NfcPassState.loaded(List<NfcPass> nfcPasses) = _Loaded;
  const factory NfcPassState.nfcNotExist() = _NfcNotExist;
  const factory NfcPassState.error(String cause) = _Error;
  const factory NfcPassState.nfcDisabled() = _NfcDisabled;
  const factory NfcPassState.nfcNotSupported() = _NfcNotSupported;
}
