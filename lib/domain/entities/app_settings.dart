import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool onboardingShown;
  final String lastUpdateVersion; // Version on last update info from strapi
  final String theme; // Theme type

  const AppSettings({required this.onboardingShown, required this.lastUpdateVersion, required this.theme});

  // Create a copy of this AppSettings with optional new values
  AppSettings copyWith({bool? onboardingShown, String? lastUpdateVersion, String? theme}) {
    return AppSettings(
      onboardingShown: onboardingShown ?? this.onboardingShown,
      lastUpdateVersion: lastUpdateVersion ?? this.lastUpdateVersion,
      theme: theme ?? this.theme,
    );
  }

  // Create an AppSettings from json
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      onboardingShown: json['onboardingShown'] as bool,
      lastUpdateVersion: json['lastUpdateVersion'] as String,
      theme: json['theme'] as String,
    );
  }

  // Convert this AppSettings to json
  Map<String, dynamic> toJson() {
    return {'onboardingShown': onboardingShown, 'lastUpdateVersion': lastUpdateVersion, 'theme': theme};
  }

  // Default settings when no stored settings are available
  factory AppSettings.defaultSettings() {
    return const AppSettings(onboardingShown: false, lastUpdateVersion: '', theme: 'system');
  }

  @override
  List<Object> get props => [onboardingShown, lastUpdateVersion, theme];
}
