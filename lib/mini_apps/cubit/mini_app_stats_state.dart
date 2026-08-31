part of 'mini_app_stats_cubit.dart';

@freezed
abstract class MiniAppStatsState with _$MiniAppStatsState {
  const factory MiniAppStatsState({
    @Default(MiniAppStatsStatus.initial) MiniAppStatsStatus status,
    @Default(MiniAppStatsRange.month) MiniAppStatsRange range,
    @Default(<MiniAppDailyStat>[]) List<MiniAppDailyStat> stats,
  }) = _MiniAppStatsState;
}
