part of 'nfc_hce_cubit.dart';

@freezed
abstract class NfcHceState with _$NfcHceState {
  const factory NfcHceState({
    @Default(false) bool available,
    @Default(true) bool enabled,
    @Default(false) bool loaded,
  }) = _NfcHceState;
}
