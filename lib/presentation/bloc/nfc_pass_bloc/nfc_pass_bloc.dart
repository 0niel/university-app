import 'dart:io' show Platform;
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/domain/usecases/connect_nfc_pass.dart';
import 'package:rtu_mirea_app/domain/usecases/fetch_nfc_code.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_nfc_passes.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';

import '../user_bloc/user_bloc.dart';

part 'nfc_pass_event.dart';
part 'nfc_pass_state.dart';
part 'nfc_pass_bloc.freezed.dart';

class NfcPassBloc extends Bloc<NfcPassEvent, NfcPassState> {
  /// This variable is used to prevent multiple fetches of NFC code.
  static bool isNfcFetched = false;

  final GetNfcPasses getNfcPasses;
  final ConnectNfcPass connectNfcPass;
  final GetAuthToken getAuthToken;
  final DeviceInfoPlugin deviceInfo;
  final FetchNfcCode fetchNfcCode;
  final GetUserData getUserData;
  final UserBloc userBloc;

  NfcPassBloc({
    required this.getNfcPasses,
    required this.connectNfcPass,
    required this.deviceInfo,
    required this.getAuthToken,
    required this.getUserData,
    required this.fetchNfcCode,
    required this.userBloc,
  }) : super(const _Initial()) {
    if (Platform.isAndroid) {
      on<_Started>(_onStarted);
      on<_GetNfcPasses>(_onGetNfcPasses);
      on<_ConnectNfcPass>(_onConnectNfcPass);
      on<_FetchNfcCode>(_onFetchNfcCode);
    }
  }

  void _onGetNfcPasses(
    _GetNfcPasses event,
    Emitter<NfcPassState> emit,
  ) async {
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
  }

  void _onConnectNfcPass(
    _ConnectNfcPass event,
    Emitter<NfcPassState> emit,
  ) async {
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
      (failure) => emit(NfcPassState.error(failure.cause ??
          "Не удалось подключить устройство. Попробуйте еще раз.")),
      (nfcPasses) {
        isNfcFetched = false;
        add(_GetNfcPasses(
          event.code,
          event.studentId,
          event.deviceId,
        ));
      },
    );
  }

  void _onStarted(
    _Started event,
    Emitter<NfcPassState> emit,
  ) async {
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
  }

  void _onFetchNfcCode(
    _FetchNfcCode event,
    Emitter<NfcPassState> emit,
  ) async {
    // Token is not empty if user is logged in
    bool isAunthenticated = false;
    final tokenRes = await getAuthToken();
    tokenRes.fold(
      (failure) => isAunthenticated = false,
      (token) => isAunthenticated = true,
    );

    if (!isAunthenticated) {
      return;
    }

    final userDataRes = await getUserData();
    String? studentId;
    String? code;
    userDataRes.fold(
      (failure) => studentId = null,
      (userData) {
        // Prevent multiple fetches of user profile data
        userBloc.add(UserEvent.setAuntificatedData(user: userData));

        var student = userData.students
            .firstWhereOrNull((element) => element.status == 'активный');
        student ??= userData.students.first;

        studentId = student.id;
        code = student.code;
      },
    );

    if (studentId == null || code == null) {
      return;
    }

    final deviceInfoRes = await deviceInfo.androidInfo;
    final deviceId = deviceInfoRes.id;
    final deviceName = deviceInfoRes.model;

    final failureOrNfcCode = await fetchNfcCode(
      FetchNfcCodeParams(
        code!,
        studentId!,
        deviceId,
        deviceName,
      ),
    );

    failureOrNfcCode.fold((failure) {
      if (failure is NfcStaffnodeNotExistFailure) {
        emit(const NfcPassState.nfcNotExist());
      } else {
        emit(NfcPassState.error(failure.cause ?? "Неизвестная ошибка"));
      }
    }, (nfcCode) {
      add(_GetNfcPasses(
        code!,
        studentId!,
        deviceId,
      ));

      isNfcFetched = true;
    });
  }
}
