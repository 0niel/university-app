import 'package:mini_apps_repository/src/models/mini_app.dart';

abstract final class MiniAppDecoder {
  static MiniApp decode(Map<Object?, Object?> json) {
    try {
      return MiniApp.fromJson(json.cast<String, Object?>());
      // Invalid response fields fail the generated JSON casts.
      // ignore: avoid_catching_errors
    } on TypeError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const FormatException('Invalid mini app metadata'),
        stackTrace,
      );
    }
  }
}
