import 'package:bloc/bloc.dart';

class HomeStoriesCubit extends Cubit<Set<String>> {
  HomeStoriesCubit() : super(const {});

  void markSeen(String sourceId) {
    if (state.contains(sourceId)) return;
    emit(Set.unmodifiable({...state, sourceId}));
  }
}
