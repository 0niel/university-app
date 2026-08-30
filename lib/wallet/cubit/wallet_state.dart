part of 'wallet_cubit.dart';

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    @Default(WalletStatus.initial) WalletStatus status,
    @Default(UserGamificationProfile.empty) UserGamificationProfile profile,
    @Default(ProfileOverview.empty) ProfileOverview overview,
    @Default(<ShurikenEntry>[]) List<ShurikenEntry> history,
    @Default(WalletTab.earn) WalletTab tab,
  }) = _WalletState;

  const WalletState._();
}
