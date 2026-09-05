import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:yx_scope/yx_scope.dart';

class FirebaseInitializer implements AsyncLifecycle {
  FirebaseInitializer({FirebaseConfig? config}) : config = config ?? .current;

  final FirebaseConfig config;

  var _initialized = false;

  @override
  Future<void> init() async {
    final options = config.currentPlatformOptions;
    if (options == null) {
      log('Firebase is disabled for this deployment', name: 'Firebase');
      return;
    }
    await Firebase.initializeApp(options: options);
    _initialized = true;
    if (!kIsWeb && FirebaseRuntime.messagingAvailable) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions();
    }
  }

  @override
  Future<void> dispose() async {
    if (!_initialized || Firebase.apps.isEmpty) return;
    await Firebase.app().delete();
  }
}
