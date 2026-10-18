import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

typedef RetryDelay = Future<void> Function(Duration duration);
typedef RetryLog = void Function(String message);
typedef UtcClock = DateTime Function();

final officialScheduleUri = Uri.https('schedule-of.mirea.ru');

bool isRetryableHttpError(Object error) {
  return error is http.ClientException ||
      error is SocketException ||
      error is TimeoutException;
}

bool isRetryableHttpStatus(int statusCode) {
  return statusCode == HttpStatus.tooManyRequests || statusCode >= 500;
}
