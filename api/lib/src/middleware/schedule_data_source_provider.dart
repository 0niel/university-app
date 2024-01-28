import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/data/schedule/rtu_mirea_schedule_data_source.dart';

final _scheduleDataSource = RtuMireaScheduleDataSource();

Middleware scheduleDataSourceProvider() {
  return (handler) {
    return handler.use(provider<ScheduleDataSource>((_) => _scheduleDataSource));
  };
}
