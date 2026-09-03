import 'package:hydrated_bloc/hydrated_bloc.dart';

class JoinedCommunitiesCubit extends HydratedCubit<List<String>> {
  JoinedCommunitiesCubit() : super(const <String>[]);

  bool isJoined(String id) => state.contains(id);

  void toggle(String id) => emit(
    isJoined(id)
        ? state.where((joined) => joined != id).toList(growable: false)
        : [...state, id],
  );

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    final ids = json['ids'];
    if (ids is! List) return null;
    return ids
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) => {'ids': state};
}
