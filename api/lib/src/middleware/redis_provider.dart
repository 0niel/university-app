import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/redis.dart';

/// Provider a [RedisClient] to the current [RequestContext].
Middleware redisProvider() {
  return (handler) {
    return (context) async {
      final redis = await RedisClient.instance;
      return handler.use(provider<RedisClient>((_) => redis))(context);
    };
  };
}
