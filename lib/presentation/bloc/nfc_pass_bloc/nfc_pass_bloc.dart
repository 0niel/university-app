
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/domain/usecases/connect_nfc_pass.dart';
import 'package:rtu_mirea_app/domain/usecases/get_nfc_passes.dart';

part 'nfc_pass_event.dart';
part 'nfc_pass_state.dart';
part 'nfc_pass_bloc.freezed.dart';

class NfcPassBloc extends Bloc<NfcPassEvent, NfcPassState> {
  final GetNfcPasses getNfcPasses;
  final ConnectNfcPass connectNfcPass;
  final DeviceInfoPlugin deviceInfo;

  NfcPassBloc({
    required this.getNfcPasses,
    required this.connectNfcPass,
    required this.deviceInfo,
  }) : super(const _Initial()) {
    on<_GetNfcPasses>((event, emit) async {
      final failureOrNfcPasses = await getNfcPasses(
        GetNfcPassesParams(
          event.code,
          event.studentId,
          event.deviceId,
        ),
      );
      failureOrNfcPasses.fold(
        (failure) => emit(NfcPassState.error(failure.cause ?? "Ошибка")),
        (nfcPasses) => emit(NfcPassState.loaded(nfcPasses)),
      );
    });

    on<_ConnectNfcPass>((event, emit) async {
      emit(const NfcPassState.loading());
      final failureOrNfcPasses = await connectNfcPass(
        ConnectNfcPassParams(
          event.code,
          event.studentId,
          event.deviceId,
          event.deviceName,
        ),
      );
      failureOrNfcPasses.fold(
        (failure) => emit(NfcPassState.error(failure.cause ?? "Ошибка")),
        (nfcPasses) => add(_GetNfcPasses(
          event.code,
          event.studentId,
          event.deviceId,
        )),
      );
    });

    on<_Started>((event, emit) async {
      emit(const NfcPassState.loading());
      if (kDebugMode) {
        emit(const NfcPassState.initial());
        return;
      }
      final availability = await FlutterNfcKit.nfcAvailability;

      if (availability == NFCAvailability.not_supported) {
        emit(const NfcPassState.nfcNotSupported());
      } else if (availability == NFCAvailability.disabled) {
        emit(const NfcPassState.nfcDisabled());
      } else {
        emit(const NfcPassState.initial());
      }
    });
  }
}
