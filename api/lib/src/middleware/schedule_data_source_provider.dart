import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/data/schedule/cached_schedule_data_source.dart';
import 'package:university_app_server_api/src/data/schedule/rtu_mirea_schedule_data_source.dart';
import 'package:university_app_server_api/src/data/schedule/schedule_data_source.dart';
import 'package:university_app_server_api/src/redis.dart';

final _delegate = RtuMireaScheduleDataSource();

Middleware scheduleDataSourceProvider() {
  return (handler) {
    return (context) async {
      final redis = context.read<RedisClient>();
      final dataSource = CachedScheduleDataSource(
        delegate: _delegate,
        redisClient: redis,
      );
      return handler.use(provider<ScheduleDataSource>((_) => dataSource))(context);
    };
  };
}
