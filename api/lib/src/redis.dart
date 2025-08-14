import 'dart:async';

import 'package:redis/redis.dart';
import 'package:university_app_server_api/config.dart';
import 'package:university_app_server_api/src/logger.dart';

final _appConfig = Config.instance;
final _logger = getLogger('RedisClient');

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
    if (_instance == null) {
      _instance = RedisClient._internal();
      await _instance!._ensureConnected();
    }
    return _instance!;
  }

  Future<void> _ensureConnected() async {
    if (_connection == null || _command == null) {
      try {
        final conn = RedisConnection();
        _logger.i('Connecting to Redis... ${_appConfig.redisHost}, ${_appConfig.redisPort}');
        _command = await conn.connect(_appConfig.redisHost, _appConfig.redisPort);
        _connection = conn;
        _logger.i('Connected to Redis successfully');
      } catch (e) {
        _logger
          ..e('Failed to connect to Redis', error: e)
          ..i('Falling back to no-op Redis.');

        _command = NullCommand();
      }
    }
  }

  /// Closes the connection to the Redis server.
  Future<void> close() async {
    _logger.i('Closing Redis connection');
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
