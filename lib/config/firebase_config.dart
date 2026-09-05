import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

final class FirebaseConfig {
  const FirebaseConfig({
    required this.enabled,
    required this.apiKey,
    required this.projectId,
    required this.messagingSenderId,
    required this.webAppId,
    required this.androidAppId,
    required this.iosAppId,
    required this.macosAppId,
    required this.windowsAppId,
    required this.authDomain,
    required this.storageBucket,
    required this.measurementId,
    required this.iosClientId,
    required this.iosBundleId,
    required this.androidApiKey,
    required this.iosApiKey,
    required this.webApiKey,
    required this.macosApiKey,
    required this.webVapidKey,
  });

  factory FirebaseConfig.fromEnvironment() => const FirebaseConfig(
    enabled: bool.fromEnvironment('FIREBASE_ENABLED'),
    apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    webAppId: String.fromEnvironment('FIREBASE_WEB_APP_ID'),
    androidAppId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
    iosAppId: String.fromEnvironment('FIREBASE_IOS_APP_ID'),
    macosAppId: String.fromEnvironment('FIREBASE_MACOS_APP_ID'),
    windowsAppId: String.fromEnvironment('FIREBASE_WINDOWS_APP_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
    iosClientId: String.fromEnvironment('FIREBASE_IOS_CLIENT_ID'),
    iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
    androidApiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
    iosApiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY'),
    webApiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    macosApiKey: String.fromEnvironment('FIREBASE_MACOS_API_KEY'),
    webVapidKey: String.fromEnvironment('FIREBASE_WEB_VAPID_KEY'),
  );

  static final current = FirebaseConfig.fromEnvironment();

  final bool enabled;
  final String apiKey;
  final String projectId;
  final String messagingSenderId;
  final String webAppId;
  final String androidAppId;
  final String iosAppId;
  final String macosAppId;
  final String windowsAppId;
  final String authDomain;
  final String storageBucket;
  final String measurementId;
  final String iosClientId;
  final String iosBundleId;
  final String androidApiKey;
  final String iosApiKey;
  final String webApiKey;
  final String macosApiKey;
  final String webVapidKey;

  FirebaseOptions? get currentPlatformOptions {
    if (kIsWeb) return optionsFor(.web);
    return optionsFor(switch (defaultTargetPlatform) {
      .android => .android,
      .iOS => .ios,
      .macOS => .macos,
      .windows => .windows,
      .linux || .fuchsia => null,
    });
  }

  FirebaseOptions? optionsFor(FirebaseTarget? target) {
    if (target == null) return null;
    if (!enabled) return null;
    final appId = _appIdFor(target);
    final platformApiKey = switch (target) {
      .android => androidApiKey,
      .ios => iosApiKey,
      .web || .windows => webApiKey,
      .macos => macosApiKey,
    };
    final effectiveApiKey = platformApiKey.isEmpty ? apiKey : platformApiKey;
    _require(effectiveApiKey, 'FIREBASE_API_KEY');
    _require(projectId, 'FIREBASE_PROJECT_ID');
    _require(messagingSenderId, 'FIREBASE_MESSAGING_SENDER_ID');
    _require(appId, _appIdKey(target));
    return FirebaseOptions(
      apiKey: effectiveApiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: _optional(authDomain),
      storageBucket: _optional(storageBucket),
      measurementId: _optional(measurementId),
      iosClientId: _optional(iosClientId),
      iosBundleId: _optional(iosBundleId),
    );
  }

  String _appIdFor(FirebaseTarget target) => switch (target) {
    .web => webAppId,
    .android => androidAppId,
    .ios => iosAppId,
    .macos => macosAppId,
    .windows => windowsAppId,
  };

  static String _appIdKey(FirebaseTarget target) => switch (target) {
    .web => 'FIREBASE_WEB_APP_ID',
    .android => 'FIREBASE_ANDROID_APP_ID',
    .ios => 'FIREBASE_IOS_APP_ID',
    .macos => 'FIREBASE_MACOS_APP_ID',
    .windows => 'FIREBASE_WINDOWS_APP_ID',
  };

  static String? _optional(String value) => value.isEmpty ? null : value;

  static void _require(String value, String key) {
    if (value.isEmpty) {
      throw StateError('$key is required when Firebase is enabled');
    }
  }
}

enum FirebaseTarget { web, android, ios, macos, windows }

abstract final class FirebaseRuntime {
  static bool get isInitialized => Firebase.apps.isNotEmpty;

  static bool get messagingAvailable =>
      isInitialized &&
      (kIsWeb
          ? FirebaseConfig.current.webVapidKey.isNotEmpty
          : defaultTargetPlatform == .android || defaultTargetPlatform == .iOS);
}
