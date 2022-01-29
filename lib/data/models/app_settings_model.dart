import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required onboardingShown,
  }) : super(onboardingShown: onboardingShown);

  factory AppSettingsModel.fromRawJson(String str) =>
      AppSettingsModel.fromJson(json.decode(str));

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      onboardingShown: json["onboarding_shown"],
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "onboarding_shown": onboardingShown,
      };
}
