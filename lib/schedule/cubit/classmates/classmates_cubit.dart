import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/friends_repository.dart';

part 'classmates_state.dart';
part 'classmates_cubit.freezed.dart';

class ClassmatesCubit extends Cubit<ClassmatesState> {
  ClassmatesCubit({required FriendsRepository friendsRepository})
    : _repository = friendsRepository,
      super(const ClassmatesState());

  final FriendsRepository _repository;

  Future<void> load(String group) async {
    if (_repository.currentUserId == null) return;
    if (group.trim().isEmpty) {
      emit(const ClassmatesState());
      return;
    }
    if (state.loading && state.group == group) return;
    emit(state.copyWith(loading: true, group: group));
    try {
      final friends = await _repository.getFriends();
      final classmates = friends
          .where((friend) => friend.group == group)
          .toList();
      emit(state.copyWith(classmates: classmates, loading: false));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(loading: false));
      addError(error, stackTrace);
    }
  }
}
