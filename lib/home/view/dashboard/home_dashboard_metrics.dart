import 'package:rtu_mirea_app/schedule/models/models.dart';

bool homeHeaderShowsLoading({
  required bool deadlinesLoading,
  required bool scheduleLoading,
}) => deadlinesLoading || scheduleLoading;

bool homeWaitsForScheduleRefresh(SelectedSchedule? selected) =>
    selected != null && selected is! SelectedCustomSchedule;
