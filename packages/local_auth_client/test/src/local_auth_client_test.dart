import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  setUpAll(() {
    registerFallbackValue(const AuthenticationOptions());
  });

  group('LocalAuthClient', () {
    late LocalAuthentication auth;
    late LocalAuthClient client;

    setUp(() {
      auth = _MockLocalAuthentication();
      client = LocalAuthClient(localAuthentication: auth);
    });

    group('capability', () {
      test('reports unavailable when device is not supported', () async {
        when(auth.isDeviceSupported).thenAnswer((_) => Future.value(false));
        when(() => auth.canCheckBiometrics).thenAnswer(
          (_) => Future.value(false),
        );

        final capability = await client.capability();

        expect(capability.available, isFalse);
        expect(capability.kind, BiometricKind.none);
      });

      test('maps face to BiometricKind.face when available', () async {
        when(auth.isDeviceSupported).thenAnswer((_) => Future.value(true));
        when(() => auth.canCheckBiometrics).thenAnswer(
          (_) => Future.value(true),
        );
        when(auth.getAvailableBiometrics).thenAnswer(
          (_) => Future.value([BiometricType.face]),
        );

        final capability = await client.capability();

        expect(capability.available, isTrue);
        expect(capability.kind, BiometricKind.face);
      });

      test('throws CheckBiometricFailure on platform error', () async {
        when(auth.isDeviceSupported).thenThrow(PlatformException(code: 'boom'));

        await expectLater(
          client.capability(),
          throwsA(isA<CheckBiometricFailure>()),
        );
      });

      test('reports unavailable when no biometric type is returned', () async {
        when(auth.isDeviceSupported).thenAnswer((_) => Future.value(true));
        when(() => auth.canCheckBiometrics).thenAnswer(
          (_) => Future.value(true),
        );
        when(auth.getAvailableBiometrics).thenAnswer(
          (_) => Future.value(<BiometricType>[]),
        );

        expect(await client.capability(), BiometricCapability.unavailable);
      });
    });

    group('authenticate', () {
      test('returns true when the platform confirms', () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) => Future.value(true));

        expect(await client.authenticate(reason: 'unlock'), isTrue);
      });

      test('throws BiometricUnavailableFailure when not enrolled', () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          ),
        ).thenThrow(PlatformException(code: auth_error.notEnrolled));

        await expectLater(
          client.authenticate(reason: 'unlock'),
          throwsA(isA<BiometricUnavailableFailure>()),
        );
      });

      test('throws AuthenticateFailure on a generic platform error', () async {
        when(
          () => auth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            options: any(named: 'options'),
          ),
        ).thenThrow(PlatformException(code: 'other'));

        await expectLater(
          client.authenticate(reason: 'unlock'),
          throwsA(isA<AuthenticateFailure>()),
        );
      });
    });
  });
}
