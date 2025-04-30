import 'package:logger/logger.dart';

/// Shared logger instance for the application
final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

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
