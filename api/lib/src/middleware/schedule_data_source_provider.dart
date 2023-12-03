import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

final _scheduleDataSource = InMemoryScheduleDataSource();

Middleware scheduleDataSourceProvider() {
  return (handler) {
    return handler
        .use(provider<ScheduleDataSource>((_) => _scheduleDataSource));
  };
}
