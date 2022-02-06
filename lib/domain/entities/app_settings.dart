import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool onboardingShown;
  final String lastUpdateVersion; // Version on last update info from strapi

  const AppSettings({
    required this.onboardingShown,
    required this.lastUpdateVersion,
  });

  @override
  List<Object> get props => [
        onboardingShown,
        lastUpdateVersion,
      ];
}
