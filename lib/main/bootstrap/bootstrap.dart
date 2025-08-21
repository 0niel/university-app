import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/firebase_options.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder =
    Future<Widget> Function(SharedPreferences sharedPreferences);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      HydratedBloc.storage = CustomHydratedStorage(
        sharedPreferences: sharedPreferences,
      );

      Widget wrapWithSentry(Widget child) {
        return SentryScreenshotWidget(
          child: DefaultAssetBundle(bundle: SentryAssetBundle(), child: child),
        );
      }

      final app = await builder(sharedPreferences);

      runApp(wrapWithSentry(app));
    },
    (error, stackTrace) {
      Logger().e('Unhandled error', error: error, stackTrace: stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}
