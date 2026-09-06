import 'package:hydrated_bloc/hydrated_bloc.dart';

enum StartupScreen {
  home('/feed'),
  schedule('/schedule'),
  map('/services/map'),
  services('/services'),
  profile('/profile');

  const StartupScreen(this.location);

  final String location;
}

class StartupScreenCubit extends HydratedCubit<StartupScreen> {
  StartupScreenCubit({required this.userId}) : super(StartupScreen.home);

  final String userId;

  @override
  String get id => userId;

  @override
  String get storagePrefix => 'StartupScreenCubit';

  void select(StartupScreen screen) => emit(screen);

  @override
  StartupScreen fromJson(Map<String, dynamic> json) =>
      StartupScreen.values
          .where((screen) => screen.name == json['screen'])
          .firstOrNull ??
      StartupScreen.home;

  @override
  Map<String, dynamic> toJson(StartupScreen state) => {'screen': state.name};
}
