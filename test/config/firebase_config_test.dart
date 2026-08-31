import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/main/bootstrap/firebase_initializer.dart';

void main() {
  const disabled = FirebaseConfig(
    enabled: false,
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
    expect(ios?.appId, 'ios-app');
    expect(ios?.iosBundleId, 'app.university');
  });

  test('rejects partial Firebase configuration', () {
    const partial = FirebaseConfig(
      enabled: true,
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
