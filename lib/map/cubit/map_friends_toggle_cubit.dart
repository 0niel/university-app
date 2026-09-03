import 'package:hydrated_bloc/hydrated_bloc.dart';

class MapFriendsToggleCubit extends HydratedCubit<bool> {
  MapFriendsToggleCubit() : super(false);

  void toggle() => emit(!state);

  void set({required bool enabled}) => emit(enabled);

  @override
  bool? fromJson(Map<String, dynamic> json) => json['enabled'] as bool?;

  @override
  Map<String, dynamic>? toJson(bool state) => {'enabled': state};
}
