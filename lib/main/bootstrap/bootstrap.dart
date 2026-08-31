import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'startup_failure.dart';

typedef AppBuilder = Future<Widget> Function(void _);

bool _isRetryableNetworkNoise(Object error) {
  if (error is AuthRetryableFetchException) return true;
  final text = error.toString();
  return text.contains('SocketException') ||
      text.contains('Connection closed before full header was received') ||
      text.contains('Connection reset by peer');
}

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      Widget wrapWithSentry(Widget child) {
        return SentryScreenshotWidget(
          child: DefaultAssetBundle(bundle: SentryAssetBundle(), child: child),
        );
      }

      final Widget app;
      try {
        app = await builder(null);
      } on Object catch (error, stackTrace) {
        Logger().e('Startup failed', error: error, stackTrace: stackTrace);
        unawaited(Sentry.captureException(error, stackTrace: stackTrace));
        runApp(wrapWithSentry(_StartupFailure(error: error)));
        return;
      }

      runApp(wrapWithSentry(app));
    },
    (error, stackTrace) {
      if (_isRetryableNetworkNoise(error)) {
        Logger().w('Retryable network error', error: error);
        return;
      }
      Logger().e('Unhandled error', error: error, stackTrace: stackTrace);
      unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    },
  );
}
