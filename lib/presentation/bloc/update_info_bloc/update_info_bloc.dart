import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_update_info.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';

part 'update_info_event.dart';
part 'update_info_state.dart';

class UpdateInfoBloc extends Bloc<UpdateInfoEvent, UpdateInfoState> {
  final GetUpdateInfo getUpdateInfo;
  final GetAppSettings getAppSettings;
  final SetAppSettings setAppSettings;

  UpdateInfoBloc({
    required this.getUpdateInfo,
    required this.getAppSettings,
    required this.setAppSettings,
  }) : super(const NoUpdateDialog()) {
    on<SetUpdateInfo>(_onSetInfo);
    on<DialogIsShown>(_setShown);
  }

  /// Download update info from api
  void init() async {
    final res = await getUpdateInfo.call();
    res.fold(
      (l) => log('Fail happened : ${l.cause}'),
      (r) => add(SetUpdateInfo(data: r)),
    );
  }

  /// If server sent new version update, show info dialog
  void _onSetInfo(SetUpdateInfo event, emit) async {
    final settings = await getAppSettings.call();
    if (settings.lastUpdateVersion != event.data.serverVersion) {
      emit(ShowUpdateDialog(data: event.data));
    }
  }

  /// Don't show the dialog a second time
  void _setShown(DialogIsShown event, emit) async {
    final settings = await getAppSettings.call();
    final result = await setAppSettings.call(
      SetAppSettingsParams(
        AppSettings(
          onboardingShown: settings.onboardingShown,
          lastUpdateVersion: event.versionToSave,
        ),
      ),
    );
    result.fold(
      (l) => log('Fail happened when saving settings : ${l.cause}'),
      (r) {},
    );
    emit(const NoUpdateDialog());
  }
}
