import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/env/env.dart';
import 'package:rtu_mirea_app/firebase_options.dart';
import 'package:rtu_mirea_app/main/bootstrap/app_bloc_observer.dart';
import 'package:rtu_mirea_app/scopes/app_scope.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AppBuilder = Future<Widget> Function(AppScopeHolder appScopeHolder);

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize shared preferences
      final sharedPreferences = await SharedPreferences.getInstance();

      // Setup HydratedBloc storage
      HydratedBloc.storage = CustomHydratedStorage(
        sharedPreferences: sharedPreferences,
      );

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

      // Initialize PackageInfo
      final packageInfo = await PackageInfo.fromPlatform();
      final packageInfoClient = PackageInfoClient(
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        packageVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      );

      // Initialize Supabase
      final supabase = await Supabase.initialize(
        url: Env.supabaseUrl,
        anonKey: Env.supabaseAnonKey,
      );

      // Create the app scope holder
      final appScopeHolder = AppScopeHolder(
        sharedPreferences: sharedPreferences,
        analyticsRepository: analyticsRepository,
        packageInfoClient: packageInfoClient,
        supabaseClient: supabase.client,
      );

      // Initialize the app scope
      await appScopeHolder.create();

      // Define a wrapper for SentryScreenshotWidget
      Widget wrapWithSentry(Widget child) {
        return SentryScreenshotWidget(
          child: DefaultAssetBundle(bundle: SentryAssetBundle(), child: child),
        );
      }

      // Run the app inside the sentry wrapper
      final app = await builder(appScopeHolder);

      runApp(wrapWithSentry(app));
    },
    (error, stackTrace) {
      Logger().e('Unhandled error', error: error, stackTrace: stackTrace);
      Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}
