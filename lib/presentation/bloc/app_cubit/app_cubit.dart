import 'dart:io' show Platform;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final GetAppSettings getAppSettings;
  final SetAppSettings setAppSettings;

  AppCubit({required this.getAppSettings, required this.setAppSettings})
      : super(AppInitial());

  void checkOnboarding() async {
    final settings = await getAppSettings();

    final isMobileApp = Platform.isAndroid || Platform.isIOS;

    if (settings.onboardingShown == false && isMobileApp) {
      await setAppSettings(
        SetAppSettingsParams(
          AppSettings(
            onboardingShown: true,
            lastUpdateVersion: settings.lastUpdateVersion,
            theme: settings.theme,
          ),
        ),
      );
      emit(AppOnboarding());
    } else {
      closeOnboarding();
    }
  }

  void closeOnboarding() => emit(AppClean());
}
