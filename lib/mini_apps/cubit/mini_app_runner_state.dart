part of 'mini_app_runner_cubit.dart';

@immutable
class MiniAppRunnerState {
  const MiniAppRunnerState({
    this.status = MiniAppRunnerStatus.initial,
    this.app,
    this.screen,
    this.fromCache = false,
    this.refreshing = false,
    this.refreshFailed = false,
  });

  final MiniAppRunnerStatus status;
  final MiniApp? app;
  final Map<String, dynamic>? screen;
  final bool fromCache;
  final bool refreshing;
  final bool refreshFailed;

  MiniAppRunnerState copyWith({
    MiniAppRunnerStatus? status,
    MiniApp? app,
    Map<String, dynamic>? screen,
    bool? fromCache,
    bool? refreshing,
    bool? refreshFailed,
  }) => MiniAppRunnerState(
    status: status ?? this.status,
    app: app ?? this.app,
    screen: screen ?? this.screen,
    fromCache: fromCache ?? this.fromCache,
    refreshing: refreshing ?? this.refreshing,
    refreshFailed: refreshFailed ?? this.refreshFailed,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiniAppRunnerState &&
          other.status == status &&
          other.app == app &&
          other.fromCache == fromCache &&
          other.refreshing == refreshing &&
          other.refreshFailed == refreshFailed &&
          jsonEquals(other.screen, screen);

  @override
  int get hashCode => Object.hash(
    status,
    app,
    fromCache,
    refreshing,
    refreshFailed,
    screen?.length,
  );

  @override
  String toString() =>
      'MiniAppRunnerState(status: $status, app: ${app?.slug}, '
      'screen: ${screen == null ? 'null' : '${screen!.length} keys'}, '
      'fromCache: $fromCache, refreshing: $refreshing, '
      'refreshFailed: $refreshFailed)';
}
