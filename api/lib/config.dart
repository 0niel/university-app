import 'dart:io';
import 'package:university_app_server_api/src/logger.dart';

/// {@template config}
/// Configuration for the application.
/// {@endtemplate}
class Config {
  /// Creates a new instance of the [Config] from the environment variables.
  factory Config() {
    if (_instance == null) {
      final logger = getLogger('Config')..i('Loading configuration from environment');

      final env = Platform.environment;

      // Check for missing environment variables
      final redisHost = env['REDIS_HOST'];
      if (redisHost == null) {
        logger.w('REDIS_HOST environment variable is missing, using default: localhost');
      }

      final redisPortStr = env['REDIS_PORT'];
      if (redisPortStr == null) {
        logger.w('REDIS_PORT environment variable is missing, using default: 6379');
      }

      final supabaseUrl = env['SUPABASE_URL'];
      if (supabaseUrl == null) {
        logger.w('SUPABASE_URL environment variable is missing, using default URL');
      }

      final supabaseKey = env['SUPABASE_KEY'];
      if (supabaseKey == null) {
        logger.e('SUPABASE_KEY environment variable is missing! This may cause authentication issues.');
      }

      _instance = Config._(
        redisHost: redisHost ?? 'localhost',
        redisPort: redisPortStr != null ? int.parse(redisPortStr) : 6379,
        supabaseUrl: supabaseUrl ?? 'https://your-supabase-url',
        supabaseKey: supabaseKey ?? '',
      );

      logger.i(
        'Configuration loaded: Redis at ${_instance!.redisHost}:${_instance!.redisPort}, Supabase URL: ${_instance!.supabaseUrl}',
      );
    }

    return _instance!;
  }

  /// {@macro config}
  Config._({
    required this.redisHost,
    required this.redisPort,
    required this.supabaseUrl,
    required this.supabaseKey,
  });

  /// The host of the Redis server.
  final String redisHost;

  /// The port of the Redis server.
  final int redisPort;

  /// The URL of the Supabase project.
  final String supabaseUrl;

  /// The anonymous key of the Supabase project.
  final String supabaseKey;

  static Config? _instance;
}
