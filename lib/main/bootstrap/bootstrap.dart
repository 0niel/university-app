import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/firebase_options.dart';
import 'package:rtu_mirea_app/main/bootstrap/app_bloc_observer.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder =
    Future<Widget> Function(SharedPreferences sharedPreferences, AnalyticsRepository analyticsRepository);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Initialize analytics repository
      late final AnalyticsRepository analyticsRepository;
      try {
        analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
      } catch (e, stackTrace) {
        Logger().e('AnalyticsRepository initialization failed: $e');
        Logger().e(stackTrace);
        Sentry.captureException(e, stackTrace: stackTrace);
        // Fallback to a no-op analytics repository
        analyticsRepository = const AnalyticsRepository();
      }

      // Setup Bloc observer
      Bloc.observer = AppBlocObserver(analyticsRepository: analyticsRepository);

      // Setup HydratedBloc storage
      final sharedPreferences = await SharedPreferences.getInstance();
      HydratedBloc.storage = CustomHydratedStorage(sharedPreferences: sharedPreferences);

      // Define a wrapper for SentryScreenshotWidget
      Widget wrapWithSentry(Widget child) {
        return SentryScreenshotWidget(child: DefaultAssetBundle(bundle: SentryAssetBundle(), child: child));
      }

      // Run the app inside the sentry wrapper
      final app = await builder(sharedPreferences, analyticsRepository);

      runApp(wrapWithSentry(app));
    },
    (error, stackTrace) {
      Logger().e('Unhandled error', error: error, stackTrace: stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}
