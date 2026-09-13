import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_verification_issue.dart';

export 'package:rtu_mirea_app/nfc_pass/bloc/nfc_verification_issue.dart';

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
  int _request = 0;
  bool _verificationInFlight = false;

  bool _isCurrent(int request) => !isClosed && request == _request;

  Future<void> checkBound() async {
    if (isClosed) return;
    final request = ++_request;
    emit(
      state.copyWith(
        status: .loading,
        errorMessage: null,
        verificationIssue: null,
        verificationRetryAt: null,
      ),
    );
    try {
      final bound = await _repository.isPassBound();
      if (!_isCurrent(request)) return;
      if (!bound) {
        emit(state.copyWith(status: .initial, passId: null));
      } else {
        final passId = await _repository.getPassId();
        if (!_isCurrent(request)) return;
        emit(state.copyWith(status: .bound, passId: passId));
      }
    } on Object catch (error, stackTrace) {
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(status: .error, errorMessage: error.toString()),
      );
      addError(error, stackTrace);
    }
  }

  Future<void> bindPass() async {
    if (isClosed || _verificationInFlight) return;
    _verificationInFlight = true;
    final request = ++_request;
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      final result = await _repository.bindPass();
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(
          status: switch (result) {
            NfcVerificationCodeSent() => .codeSent,
            NfcVerificationCooldown() => .verificationPending,
            NfcVerificationUnavailable() => .verificationUnavailable,
          },
          verificationRetryAt: switch (result) {
            NfcVerificationCodeSent(:final retryAt) => retryAt,
            NfcVerificationCooldown(:final retryAt) => retryAt,
            NfcVerificationUnavailable() => null,
          },
          verificationIssue: null,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(
          status: error is NfcPassSendCodeFailure
              ? .verificationPending
              : .error,
          verificationIssue: error is NfcPassSendCodeFailure
              ? .requestFailed
              : null,
        ),
      );
      addError(error, stackTrace);
    } finally {
      _verificationInFlight = false;
    }
  }

  Future<void> confirmBinding({
    required String sixDigitCode,
    required String deviceName,
  }) async {
    if (isClosed || _verificationInFlight) return;
    _verificationInFlight = true;
    final request = ++_request;
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      final passId = await _repository.confirmBinding(
        sixDigitCode: sixDigitCode,
        deviceName: deviceName,
      );
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(
          status: .bound,
          passId: passId,
          verificationIssue: null,
          verificationRetryAt: null,
        ),
      );
    } on NfcPassVerificationFailure catch (error) {
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(
          status: .verificationPending,
          verificationIssue: switch (error.reason) {
            NfcVerificationFailure.wrongCode => .wrongCode,
            NfcVerificationFailure.nfcError => .nfcError,
          },
        ),
      );
    } on Object catch (error, stackTrace) {
      if (!_isCurrent(request)) return;
      emit(
        state.copyWith(
          status: .verificationPending,
          verificationIssue: .requestFailed,
        ),
      );
      addError(error, stackTrace);
    } finally {
      _verificationInFlight = false;
    }
  }

  Future<void> unbindPass() async {
    if (isClosed || _verificationInFlight) return;
    final request = ++_request;
    emit(state.copyWith(status: .loading, errorMessage: null));
    try {
      await _repository.unbindPass();
      if (!_isCurrent(request)) return;
      emit(const NfcPassState());
    } on Object catch (error, stackTrace) {
      if (!_isCurrent(request)) return;
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
