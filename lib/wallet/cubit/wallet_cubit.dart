import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';

part 'wallet_state.dart';
part 'wallet_status.dart';
part 'wallet_tab.dart';
part 'wallet_cubit.freezed.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.gamificationRepository,
    required this.organizationId,
  }) : super(const WalletState());

  final GamificationRepository gamificationRepository;
  final String organizationId;

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final (profile, overview, history) = await (
        gamificationRepository.getProfile().catchError(
          (_) => UserGamificationProfile.empty,
        ),
        gamificationRepository
            .getProfileOverview(organizationId)
            .catchError((_) => ProfileOverview.empty),
        gamificationRepository
            .getShurikenHistory(organizationId)
            .catchError((_) => const <ShurikenEntry>[]),
      ).wait;
      emit(
        state.copyWith(
          status: .populated,
          profile: profile,
          overview: overview,
          history: history,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void tabChanged(WalletTab tab) => emit(state.copyWith(tab: tab));
}
