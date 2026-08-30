part of 'nfc_pass_cubit.dart';

@freezed
abstract class NfcPassState with _$NfcPassState {
  const factory NfcPassState({
    @Default(NfcPassStatus.initial) NfcPassStatus status,
    int? passId,
    String? errorMessage,
    String? localFilePath,
  }) = _NfcPassState;

  const NfcPassState._();

  bool get isVideo {
    final path = localFilePath;
    return path != null &&
        (path.endsWith('.mp4') ||
            path.endsWith('.mov') ||
            path.endsWith('.avi') ||
            path.endsWith('.mkv') ||
            path.endsWith('.webm'));
  }
}
