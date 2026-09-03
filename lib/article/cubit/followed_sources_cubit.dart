import 'package:hydrated_bloc/hydrated_bloc.dart';

class FollowedSourcesCubit extends HydratedCubit<List<String>> {
  FollowedSourcesCubit() : super(const <String>[]);

  bool isFollowed(String key) => state.contains(key);

  void toggle(String key) => emit(
    isFollowed(key)
        ? state.where((followed) => followed != key).toList(growable: false)
        : [...state, key],
  );

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    final keys = json['keys'];
    return keys is List
        ? keys
              .whereType<String>()
              .where((key) => key.isNotEmpty)
              .toSet()
              .toList()
        : null;
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) => {'keys': state};
}
