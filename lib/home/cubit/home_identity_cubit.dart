import 'package:bloc/bloc.dart';
import 'package:gamification_repository/gamification_repository.dart';

enum HomeIdentityStatus { initial, loaded }

class HomeIdentityState {
  const HomeIdentityState({
    this.status = HomeIdentityStatus.initial,
    this.fullName,
    this.handle,
  });

  final HomeIdentityStatus status;
  final String? fullName;
  final String? handle;

  bool get isLoaded => status == HomeIdentityStatus.loaded;

  static const initial = HomeIdentityState();
}

class HomeIdentityCubit extends Cubit<HomeIdentityState> {
  HomeIdentityCubit(this._repository, this._organizationId)
    : super(HomeIdentityState.initial);

  final GamificationRepository _repository;
  final String _organizationId;

  Future<void> load() async {
    if (isClosed) return;
    try {
      final overview = await _repository.getProfileOverview(_organizationId);
      if (isClosed) return;
      emit(
        HomeIdentityState(
          status: HomeIdentityStatus.loaded,
          fullName: overview.academic.fullName,
          handle: overview.academic.handle,
        ),
      );
    } on Exception {
      if (isClosed) return;
      emit(
        HomeIdentityState(
          status: HomeIdentityStatus.loaded,
          fullName: state.fullName,
          handle: state.handle,
        ),
      );
    }
  }
}
