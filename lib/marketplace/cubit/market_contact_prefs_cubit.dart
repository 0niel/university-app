import 'package:hydrated_bloc/hydrated_bloc.dart';

class MarketContactPrefsCubit extends HydratedCubit<String> {
  MarketContactPrefsCubit() : super('');

  void rememberHandle(String handle) {
    final trimmed = handle.trim().replaceFirst(RegExp('^@'), '');
    if (trimmed == state) return;
    emit(trimmed);
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    final handle = json['telegramHandle'];
    return handle is String ? handle : null;
  }

  @override
  Map<String, dynamic>? toJson(String state) => {'telegramHandle': state};
}
