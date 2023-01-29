import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool onboardingShown;
  final String lastUpdateVersion; // Version on last update info from strapi
  final String theme; // Theme type

  const AppSettings({
    required this.onboardingShown,
    required this.lastUpdateVersion,
    required this.theme,
  });

  @override
  List<Object> get props => [
        onboardingShown,
        lastUpdateVersion,
        theme,
      ];
}
