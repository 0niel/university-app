part of 'mini_app_stats_cubit.dart';

enum MiniAppStatsRange {
  week(7),
  month(30),
  quarter(90);

  const MiniAppStatsRange(this.days);

  final int days;
}
