import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_request_logger/dart_frog_request_logger.dart';
import 'package:dart_frog_request_logger/log_formatters.dart';

Middleware loggerProvider() {
  return (handler) {
    return handler.use(
      provider<RequestLogger>(
        (context) => RequestLogger(
          headers: context.request.headers,
          logFormatter: formatSimpleLog(),
        ),
      ),
    );
  };
}
