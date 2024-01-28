import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required bool onboardingShown,
    required String lastUpdateVersion,
    required String theme,
  }) : super(
          onboardingShown: onboardingShown,
          lastUpdateVersion: lastUpdateVersion,
          theme: theme,
        );

  factory AppSettingsModel.fromRawJson(String str) => AppSettingsModel.fromJson(json.decode(str));

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      onboardingShown: json["onboarding_shown"],
      lastUpdateVersion: json["last_update_version"] ?? '',
      theme: json["theme"] ?? 'dark',
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "onboarding_shown": onboardingShown,
        "last_update_version": lastUpdateVersion,
        "theme": theme,
      };
}
