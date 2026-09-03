import 'package:bloc/bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';

class HomeGamificationCubit extends Cubit<UserGamificationProfile?> {
  HomeGamificationCubit(this._repository) : super(null);

  final GamificationRepository _repository;

  Future<void> load() async {
    try {
      final profile = await _repository.getProfile();
      if (!isClosed) emit(profile);
    } on Exception catch (_) {
      if (!isClosed && state == null) emit(null);
    }
  }
}
