import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/main/bootstrap/firebase_initializer.dart';

void main() {
  const disabled = FirebaseConfig(
    enabled: false,
    androidApiKey: '',
    iosApiKey: '',
    webApiKey: '',
    macosApiKey: '',
    webVapidKey: '',
    apiKey: '',
    projectId: '',
    messagingSenderId: '',
    webAppId: '',
    androidAppId: '',
    iosAppId: '',
    macosAppId: '',
    windowsAppId: '',
    authDomain: '',
    storageBucket: '',
    measurementId: '',
    iosClientId: '',
    iosBundleId: '',
  );

  const configured = FirebaseConfig(
    enabled: true,
    apiKey: 'api-key',
    androidApiKey: 'android-key',
    iosApiKey: 'ios-key',
    webApiKey: '',
    macosApiKey: '',
    webVapidKey: '',
    projectId: 'university-project',
    messagingSenderId: '123',
    webAppId: 'web-app',
    androidAppId: 'android-app',
    iosAppId: 'ios-app',
    macosAppId: 'macos-app',
    windowsAppId: 'windows-app',
    authDomain: 'university.firebaseapp.com',
    storageBucket: 'university.firebasestorage.app',
    measurementId: 'measurement',
    iosClientId: 'ios-client',
    iosBundleId: 'app.university',
  );

  test('returns null when Firebase is disabled', () {
    expect(disabled.optionsFor(.android), isNull);
    expect(disabled.optionsFor(null), isNull);
  });

  test('initializer is a no-op when Firebase is disabled', () async {
    final initializer = FirebaseInitializer(config: disabled);

    await initializer.init();
    await initializer.dispose();
  });

  test('builds platform-specific options', () {
    final android = configured.optionsFor(.android);
    final ios = configured.optionsFor(.ios);

    expect(android?.appId, 'android-app');
    expect(android?.apiKey, 'android-key');
    expect(ios?.appId, 'ios-app');
    expect(ios?.apiKey, 'ios-key');
    expect(ios?.iosBundleId, 'app.university');
    expect(configured.optionsFor(.web)?.apiKey, 'api-key');
  });

  test('rejects partial Firebase configuration', () {
    const partial = FirebaseConfig(
      enabled: true,
      androidApiKey: '',
      iosApiKey: '',
      webApiKey: '',
      macosApiKey: '',
      webVapidKey: '',
      apiKey: 'api-key',
      projectId: '',
      messagingSenderId: '',
      webAppId: '',
      androidAppId: 'android-app',
      iosAppId: '',
      macosAppId: '',
      windowsAppId: '',
      authDomain: '',
      storageBucket: '',
      measurementId: '',
      iosClientId: '',
      iosBundleId: '',
    );

    expect(
      () => partial.optionsFor(.android),
      throwsStateError,
    );
  });
}
