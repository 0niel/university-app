import 'dart:async';

import 'package:redis/redis.dart';
import 'package:university_app_server_api/config.dart';

final _appConfig = Config();

/// {@template redis_client}
/// A Redis client.
/// {@endtemplate}
class RedisClient {
  RedisClient._internal();

  static RedisClient? _instance;
  RedisConnection? _connection;
  Command? _command;

  /// Returns the [RedisClient] instance.
  static Future<RedisClient> get instance async {
    _instance ??= RedisClient._internal();
    await _instance!._ensureConnected();
    return _instance!;
  }

  Future<void> _ensureConnected() async {
    if (_connection == null || _command == null) {
      try {
        final conn = RedisConnection();
        print('Connecting to Redis... ${_appConfig.redisHost}, ${_appConfig.redisPort}');
        _command = await conn.connect(_appConfig.redisHost, _appConfig.redisPort);
        _connection = conn;
      } catch (e) {
        print('Failed to connect to Redis: $e\nFalling back to no-op Redis.');
        // Fallback to a no-op command so that errors related to Redis are suppressed.
        _command = NullCommand();
      }
    }
  }

  /// Closes the connection to the Redis server.
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
    _command = null;
  }

  /// Returns the [Command] for the Redis connection.
  Command get command {
    if (_command == null) {
      throw StateError('The Redis connection is not established.');
    }
    return _command!;
  }
}

/// A no-operation [Command] that safely ignores calls.
class NullCommand implements Command {
  @override
  // ignore: non_constant_identifier_names
  Future<dynamic> send_object(Object args) async {
    return null;
  }

  @override
  Future<dynamic> get(String key) async {
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
