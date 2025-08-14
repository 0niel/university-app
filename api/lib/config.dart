import 'dart:io';
import 'package:dotenv/dotenv.dart';

class Config {
  factory Config.fromEnv() {
    final env = DotEnv();

    final envFiles = ['.env', '../.env'];

    for (final envFile in envFiles) {
      final file = File(envFile);
      if (file.existsSync()) {
        env.load([envFile]);
        break;
      }
    }

    String getEnvValue(String key, {String? defaultValue}) {
      return Platform.environment[key] ?? env[key] ?? defaultValue ?? '';
    }

    int getEnvInt(String key, {int? defaultValue}) {
      final value = getEnvValue(key);
      if (value.isEmpty && defaultValue != null) return defaultValue;
      return int.tryParse(value) ?? defaultValue ?? 0;
    }

    bool getEnvBool(String key) {
      final value = getEnvValue(key).toLowerCase();
      return value == 'true' || value == '1' || value == 'yes';
    }

    final config = Config._(
      redisHost: getEnvValue('REDIS_HOST', defaultValue: 'localhost'),
      redisPort: getEnvInt('REDIS_PORT', defaultValue: 6379),
      redisPassword: getEnvValue('REDIS_PASSWORD'),
      supabaseUrl: getEnvValue('SUPABASE_URL', defaultValue: 'https://your-supabase-url.supabase.co'),
      supabaseAnonKey: getEnvValue('SUPABASE_ANON_KEY'),
      supabaseServiceKey: getEnvValue('SUPABASE_SERVICE_KEY'),
      supabaseBucketImages: getEnvValue('SUPABASE_BUCKET_IMAGES', defaultValue: 'social-media-images'),
      supabaseBucketVideos: getEnvValue('SUPABASE_BUCKET_VIDEOS', defaultValue: 'social-media-videos'),
      logLevel: getEnvValue('LOG_LEVEL', defaultValue: 'info'),
      enableCors: getEnvBool('ENABLE_CORS'),
      enableDebugLogging: getEnvBool('ENABLE_DEBUG_LOGGING'),
      jwtSecret: getEnvValue('JWT_SECRET').isEmpty ? null : getEnvValue('JWT_SECRET'),
      jwtExpirationSeconds: getEnvInt('JWT_EXPIRATION_SECONDS', defaultValue: 3600),
      rateLimitPerMinute: getEnvInt('RATE_LIMIT_PER_MINUTE', defaultValue: 100),
      rateLimitWindowSeconds: getEnvInt('RATE_LIMIT_WINDOW_SECONDS', defaultValue: 900),
      databaseUrl: getEnvValue('DATABASE_URL').isEmpty ? null : getEnvValue('DATABASE_URL'),
      telegramApiId: getEnvValue('TELEGRAM_API_ID'),
      telegramApiHash: getEnvValue('TELEGRAM_API_HASH'),
      telegramBotToken: getEnvValue('TELEGRAM_BOT_TOKEN'),
      vkAccessToken: getEnvValue('VK_ACCESS_TOKEN'),
      host: getEnvValue('HOST', defaultValue: '0.0.0.0'),
      port: getEnvInt('PORT', defaultValue: 8000),
      debug: getEnvBool('DEBUG'),
      enableBackgroundSync: getEnvBool('ENABLE_BACKGROUND_SYNC'),
      syncIntervalMinutes: getEnvInt('SYNC_INTERVAL_MINUTES', defaultValue: 30),
      maxFileSize: getEnvInt('MAX_FILE_SIZE_MB', defaultValue: 50),
    );

    config.validate();

    return config;
  }

  const Config._({
    required this.redisHost,
    required this.redisPort,
    required this.redisPassword,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.supabaseServiceKey,
    required this.logLevel,
    required this.enableCors,
    required this.enableDebugLogging,
    required this.jwtExpirationSeconds,
    required this.rateLimitPerMinute,
    required this.rateLimitWindowSeconds,
    required this.telegramApiId,
    required this.telegramApiHash,
    required this.telegramBotToken,
    required this.vkAccessToken,
    required this.host,
    required this.port,
    required this.debug,
    required this.supabaseBucketImages,
    required this.supabaseBucketVideos,
    required this.enableBackgroundSync,
    required this.syncIntervalMinutes,
    required this.maxFileSize,
    this.jwtSecret,
    this.databaseUrl,
  });

  static Config? _instance;

  static Config get instance {
    _instance ??= Config.fromEnv();
    return _instance!;
  }

  final String redisHost;
  final int redisPort;
  final String redisPassword;

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String supabaseServiceKey;
  final String supabaseBucketImages;
  final String supabaseBucketVideos;

  final String logLevel;
  final bool enableCors;
  final bool enableDebugLogging;

  final String? jwtSecret;
  final int jwtExpirationSeconds;

  final int rateLimitPerMinute;
  final int rateLimitWindowSeconds;

  final String? databaseUrl;

  final String telegramApiId;
  final String telegramApiHash;
  final String telegramBotToken;
  final String vkAccessToken;

  final String host;
  final int port;
  final bool debug;

  final bool enableBackgroundSync;
  final int syncIntervalMinutes;

  final int maxFileSize;

  void validate() {
    final errors = <String>[];

    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY is required');
    }

    if (supabaseServiceKey.isEmpty) {
      errors.add('SUPABASE_SERVICE_KEY is required');
    }

    if (supabaseUrl == 'https://your-supabase-url.supabase.co' || supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL must be set to a valid Supabase URL');
    }

    if (supabaseUrl.isNotEmpty && supabaseUrl != 'https://your-supabase-url.supabase.co') {
      final uri = Uri.tryParse(supabaseUrl);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        errors.add('SUPABASE_URL must be a valid URL');
      }
    }

    if (redisPort <= 0 || redisPort > 65535) {
      errors.add('REDIS_PORT must be a valid port number (1-65535)');
    }

    if (port <= 0 || port > 65535) {
      errors.add('PORT must be a valid port number (1-65535)');
    }

    if (jwtExpirationSeconds <= 0) {
      errors.add('JWT_EXPIRATION_SECONDS must be greater than 0');
    }

    if (syncIntervalMinutes <= 0) {
      errors.add('SYNC_INTERVAL_MINUTES must be greater than 0');
    }

    if (rateLimitPerMinute <= 0) {
      errors.add('RATE_LIMIT_PER_MINUTE must be greater than 0');
    }

    if (rateLimitWindowSeconds <= 0) {
      errors.add('RATE_LIMIT_WINDOW_SECONDS must be greater than 0');
    }

    if (maxFileSize <= 0) {
      errors.add('MAX_FILE_SIZE_MB must be greater than 0');
    }

    final validLogLevels = ['debug', 'info', 'warning', 'error', 'critical'];
    if (!validLogLevels.contains(logLevel.toLowerCase())) {
      errors.add('LOG_LEVEL must be one of: ${validLogLevels.join(', ')}');
    }

    if (enableBackgroundSync) {
      if (telegramApiId.isEmpty) {
        errors.add('TELEGRAM_API_ID is required when background sync is enabled');
      }
      if (telegramApiHash.isEmpty) {
        errors.add('TELEGRAM_API_HASH is required when background sync is enabled');
      }
      if (telegramBotToken.isEmpty) {
        errors.add('TELEGRAM_BOT_TOKEN is required when background sync is enabled');
      }
    }

    if (errors.isNotEmpty) {
      throw ConfigurationException(errors);
    }
  }
}

class ConfigurationException implements Exception {
  const ConfigurationException(this.errors);

  final List<String> errors;

  @override
  String toString() {
    return 'ConfigurationException: ${errors.join(', ')}';
  }
}
