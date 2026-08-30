import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';

part 'nfc_hce_cubit.freezed.dart';
part 'nfc_hce_state.dart';

class NfcHceCubit extends Cubit<NfcHceState> {
  NfcHceCubit({required this._repository}) : super(const NfcHceState());

  final NfcPassRepository _repository;

  Future<void> refresh() async {
    try {
      final available = await _repository.isNfcAvailable();
      final enabled = available && await _repository.isNfcEnabled();
      emit(NfcHceState(available: available, enabled: enabled, loaded: true));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const NfcHceState(loaded: true));
    }
  }

  Future<void> setEnabled({required bool enabled}) async {
    if (!state.available) return;
    try {
      await _repository.setNfcEnabled(enabled: enabled);
      emit(state.copyWith(enabled: enabled));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
