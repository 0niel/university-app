import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/config.dart';
import 'package:university_app_server_api/src/logger.dart';

/// Middleware that logs application configuration on startup
Middleware configLoggerProvider() {
  return (handler) {
    return (context) async {
      // Log configuration once on first request
      try {
        final config = Config.instance;

        // Configure logger with settings from config
        configureLogger(
          logLevel: config.logLevel,
          enableDebugLogging: config.enableDebugLogging,
        );
      } catch (e) {
        final logger = getLogger('ConfigLogger');
        logger.e('Failed to log configuration', error: e);
      }

      return handler(context);
    };
  };
}
