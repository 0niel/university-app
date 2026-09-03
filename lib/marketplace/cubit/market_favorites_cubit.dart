import 'package:hydrated_bloc/hydrated_bloc.dart';

class MarketFavoritesCubit extends HydratedCubit<List<String>> {
  MarketFavoritesCubit() : super(const []);

  void toggle(String id) => emit(
    state.contains(id)
        ? state.where((value) => value != id).toList()
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
