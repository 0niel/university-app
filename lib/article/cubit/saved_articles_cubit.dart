import 'package:hydrated_bloc/hydrated_bloc.dart';

class SavedArticlesCubit extends HydratedCubit<List<String>> {
  SavedArticlesCubit() : super(const <String>[]);

  bool isSaved(String id) => state.contains(id);

  void toggle(String id) => emit(
    isSaved(id)
        ? state.where((saved) => saved != id).toList(growable: false)
        : [...state, id],
  );

  @override
  List<String>? fromJson(Map<String, dynamic> json) {
    final ids = json['ids'];
    return ids is List
        ? ids.whereType<String>().where((id) => id.isNotEmpty).toSet().toList()
        : null;
  }

  @override
  Map<String, dynamic>? toJson(List<String> state) => {'ids': state};
}
