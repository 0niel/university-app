import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

typedef AppBuilder = Future<Widget> Function(void _);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      Widget wrapWithSentry(Widget child) {
        return SentryScreenshotWidget(
          child: DefaultAssetBundle(bundle: SentryAssetBundle(), child: child),
        );
      }

      final app = await builder(null);

      runApp(wrapWithSentry(app));
    },
    (error, stackTrace) {
      Logger().e('Unhandled error', error: error, stackTrace: stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}
