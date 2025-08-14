import 'package:logger/logger.dart';

/// Shared logger instance for the application
Logger _logger = Logger(
  level: Level.info,
  printer: PrettyPrinter(
    methodCount: 0,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

/// Configures the logger with settings from the configuration
void configureLogger({
  required String logLevel,
  required bool enableDebugLogging,
}) {
  final level = _parseLogLevel(logLevel);

  _logger = Logger(
    level: enableDebugLogging ? Level.debug : level,
    printer: PrettyPrinter(
      methodCount: enableDebugLogging ? 2 : 0,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
}

/// Parses string log level to Logger Level
Level _parseLogLevel(String logLevel) {
  switch (logLevel.toLowerCase()) {
    case 'debug':
      return Level.debug;
    case 'info':
      return Level.info;
    case 'warning':
    case 'warn':
      return Level.warning;
    case 'error':
      return Level.error;
    case 'off':
      return Level.off;
    default:
      return Level.info;
  }
}

/// Gets a named logger for a specific component
///
/// Example:
/// ```dart
/// final appLogger = getLogger('AppComponent');
/// appLogger.d('Debug message');
/// appLogger.i('Info message');
/// appLogger.w('Warning message');
/// appLogger.e('Error message');
/// ```
Logger getLogger(String name) {
  return _logger;
}

/// Gets a logger with a specific context/name for better debugging
Logger getNamedLogger(String name) {
  return Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 0,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      debug: '🐛 [$name]',
      info: '💡 [$name]',
      warning: '⚠️ [$name]',
      error: '❌ [$name]',
    ),
  );
}
