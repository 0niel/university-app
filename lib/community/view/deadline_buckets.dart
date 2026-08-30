import 'package:rtu_mirea_app/community/view/deadline_bucket.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'deadline_bucket.dart';

DeadlineBucket deadlineBucket(Deadline deadline, {DateTime? now}) {
  final currentTime = now ?? DateTime.now();
  if (deadline.isDone) return .done;
  if (deadline.isUrgentAt(currentTime)) return .hot;
  if (deadline.timeLeftAt(currentTime) <= const Duration(days: 7)) {
    return .week;
  }
  return .later;
}
