import 'dart:io';

/// {@template config}
/// Configuration for the application.
/// {@endtemplate}
class Config {
  /// Creates a new instance of the [Config] from the environment variables.
  factory Config() {
    if (_instance == null) {
      final env = Platform.environment;

      _instance = Config._(
        redisHost: env['REDIS_HOST'] ?? 'localhost',
        redisPort: int.parse(env['REDIS_PORT'] ?? '6379'),
      );
    }

    return _instance!;
  }

  /// {@macro config}
  Config._({required this.redisHost, required this.redisPort});

  /// The host of the Redis server.
  final String redisHost;

  /// The port of the Redis server.
  final int redisPort;

  static Config? _instance;
}
