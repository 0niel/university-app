import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';

enum NfcPassStatus {
  initial,
  loading,
  codeSent,
  bound,
  error,
}

class NfcPassState extends Equatable {
  const NfcPassState({
    this.status = NfcPassStatus.initial,
    this.passId,
    this.errorMessage,
    this.localFilePath,
  });

  final NfcPassStatus status;
  final int? passId;
  final String? errorMessage;
  final String? localFilePath;

  bool get isVideo =>
      localFilePath != null &&
      (localFilePath!.endsWith('.mp4') ||
          localFilePath!.endsWith('.mov') ||
          localFilePath!.endsWith('.avi') ||
          localFilePath!.endsWith('.mkv') ||
          localFilePath!.endsWith('.webm'));

  @override
  List<Object?> get props => [status, passId, errorMessage, localFilePath];

  NfcPassState copyWith({
    NfcPassStatus? status,
    int? passId,
    String? errorMessage,
    String? localFilePath,
  }) {
    return NfcPassState(
      status: status ?? this.status,
      passId: passId ?? this.passId,
      errorMessage: errorMessage ?? this.errorMessage,
      localFilePath: localFilePath ?? this.localFilePath,
    );
  }
}

class NfcPassCubit extends HydratedCubit<NfcPassState> {
  NfcPassCubit({
    required NfcPassRepository repository,
    ImagePicker? imagePicker,
  })  : _repository = repository,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(const NfcPassState());

  final NfcPassRepository _repository;
  final ImagePicker _imagePicker;

  Future<void> checkBound() async {
    emit(state.copyWith(status: NfcPassStatus.loading, errorMessage: null));
    try {
      final bound = await _repository.isPassBound();
      if (!bound) {
        emit(state.copyWith(status: NfcPassStatus.initial, passId: null));
      } else {
        final passId = await _repository.getPassId();
        emit(state.copyWith(
          status: NfcPassStatus.bound,
          passId: passId,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: NfcPassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> bindPass() async {
    emit(state.copyWith(status: NfcPassStatus.loading, errorMessage: null));
    try {
      await _repository.bindPass();
      emit(state.copyWith(status: NfcPassStatus.codeSent));
    } catch (e) {
      emit(state.copyWith(
        status: NfcPassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> confirmBinding({
    required String sixDigitCode,
    required String deviceName,
  }) async {
    emit(state.copyWith(status: NfcPassStatus.loading, errorMessage: null));
    try {
      final passId = await _repository.confirmBinding(
        sixDigitCode: sixDigitCode,
        deviceName: deviceName,
      );
      emit(state.copyWith(
        status: NfcPassStatus.bound,
        passId: passId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NfcPassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> unbindPass() async {
    emit(state.copyWith(status: NfcPassStatus.loading, errorMessage: null));
    try {
      await _repository.unbindPass();
      emit(const NfcPassState(status: NfcPassStatus.initial));
    } catch (e) {
      emit(state.copyWith(
        status: NfcPassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> pickFile() async {
    final pickedFile = await _imagePicker.pickMedia();
    if (pickedFile != null) {
      emit(state.copyWith(localFilePath: pickedFile.path));
    }
  }

  void removeFile() {
    emit(state.copyWith(localFilePath: null));
  }

  @override
  NfcPassState? fromJson(Map<String, dynamic> json) {
    try {
      return NfcPassState(
        status: NfcPassStatus.values[json['status'] as int],
        passId: json['passId'] as int?,
        errorMessage: json['errorMessage'] as String?,
        localFilePath: json['localFilePath'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(NfcPassState state) {
    return {
      'status': state.status.index,
      'passId': state.passId,
      'errorMessage': state.errorMessage,
      'localFilePath': state.localFilePath,
    };
  }
}
