part of 'watch_connectivity_cubit.dart';

@freezed
abstract class WatchConnectivityState with _$WatchConnectivityState {
  const factory WatchConnectivityState({
    @Default(false) bool isConnected,
    WatchMessage? lastMessage,
    DateTime? lastScheduleSyncTime,
  }) = _WatchConnectivityState;
}
