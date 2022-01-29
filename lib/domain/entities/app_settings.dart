import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool onboardingShown;

  const AppSettings({
    required this.onboardingShown,
  });

  @override
  List<Object> get props => [onboardingShown];
}
