import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';

part 'nfc_pass_cubit.freezed.dart';
part 'nfc_pass_state.dart';
part 'nfc_pass_status.dart';

class NfcPassCubit extends HydratedCubit<NfcPassState> {
  NfcPassCubit({
    required this._repository,
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       super(const NfcPassState());

  final NfcPassRepository _repository;
  final ImagePicker _imagePicker;

  Future<void> checkBound() async {
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      final bound = await _repository.isPassBound();
      if (!bound) {
        emit(state.copyWith(status: .initial, passId: null));
      } else {
        final passId = await _repository.getPassId();
        emit(state.copyWith(status: .bound, passId: passId));
      }
    } on Object catch (error, stackTrace) {
      emit(
        state.copyWith(status: .error, errorMessage: error.toString()),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> bindPass() async {
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      await _repository.bindPass();
      emit(state.copyWith(status: .codeSent));
    } on Object catch (error, stackTrace) {
      emit(
        state.copyWith(status: .error, errorMessage: error.toString()),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> confirmBinding({
    required String sixDigitCode,
    required String deviceName,
  }) async {
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      final passId = await _repository.confirmBinding(
        sixDigitCode: sixDigitCode,
        deviceName: deviceName,
      );
      emit(state.copyWith(status: .bound, passId: passId));
    } on Object catch (error, stackTrace) {
      emit(
        state.copyWith(status: .error, errorMessage: error.toString()),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> unbindPass() async {
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      await _repository.unbindPass();
      emit(const NfcPassState());
    } on Object catch (error, stackTrace) {
      emit(
        state.copyWith(status: .error, errorMessage: error.toString()),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> claimTurnstilePriority() =>
      _repository.setForegroundPreference(enabled: true);

  Future<void> releaseTurnstilePriority() =>
      _repository.setForegroundPreference(enabled: false);

  Future<void> pickFile() async {
    try {
      final pickedFile = await _imagePicker.pickMedia();
      if (pickedFile != null) {
        emit(state.copyWith(localFilePath: pickedFile.path));
      }
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void removeFile() {
    emit(state.copyWith(localFilePath: null));
  }

  @override
  NfcPassState? fromJson(Map<String, dynamic> json) {
    try {
      return NfcPassState(
        localFilePath: json['localFilePath'] as String?,
      );
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(NfcPassState state) {
    return {
      'localFilePath': state.localFilePath,
    };
  }
}
