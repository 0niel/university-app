import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';
import 'package:nfc_pass_repository/nfc_pass_repository.dart';
import 'package:storage/storage.dart';

class MockStorage extends Mock implements Storage {}

class MockDigitalPassChannel extends Mock implements DigitalPassChannel {}

final _configuration = NfcPassConfiguration(
  oauthUrl: Uri(scheme: 'https', host: 'auth.university.example'),
  expectedRedirectUrls: [Uri(scheme: 'https', host: 'app.university.example')],
  endpoints: NfcPassEndpoints(
    accessTokenUrl: Uri(
      scheme: 'https',
      host: 'api.university.example',
      path: 'pass/token',
    ),
    sendVerificationCodeUrl: Uri(
      scheme: 'https',
      host: 'api.university.example',
      path: 'pass/send-code',
    ),
    getDigitalPassUrl: Uri(
      scheme: 'https',
      host: 'api.university.example',
      path: 'pass/get',
    ),
  ),
);

void main() {
  late Storage storage;
  late DigitalPassChannel digitalPassChannel;
  late NfcPassRepository repository;

  setUp(() {
    storage = MockStorage();
    digitalPassChannel = MockDigitalPassChannel();
    repository = NfcPassRepository(
      storage: storage,
      configuration: _configuration,
      digitalPassChannel: digitalPassChannel,
    );

    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
    when(() => digitalPassChannel.savePassId(any())).thenAnswer((_) async {});
    when(() => digitalPassChannel.clearPassId()).thenAnswer((_) async {});
    when(
      () => digitalPassChannel.isHceAvailable(),
    ).thenAnswer((_) async => true);
    when(() => digitalPassChannel.isHceEnabled()).thenAnswer((_) async => true);
    when(
      () => digitalPassChannel.setHceEnabled(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});
    when(
      () => digitalPassChannel.setForegroundPreference(
        enabled: any(named: 'enabled'),
      ),
    ).thenAnswer((_) async {});
  });

  group('isPassBound', () {
    test('is true when a passId is stored', () async {
      when(
        () => storage.read(key: 'nfc_pass_id'),
      ).thenAnswer((_) async => '12345');

      expect(await repository.isPassBound(), isTrue);
    });

    test('is false when no passId is stored', () async {
      when(
        () => storage.read(key: 'nfc_pass_id'),
      ).thenAnswer((_) async => null);

      expect(await repository.isPassBound(), isFalse);
    });
  });

  group('getPassId', () {
    test('returns the parsed id and mirrors it to the native store', () async {
      when(
        () => storage.read(key: 'nfc_pass_id'),
      ).thenAnswer((_) async => '12345');

      final passId = await repository.getPassId();

      expect(passId, 12345);
      verify(() => digitalPassChannel.savePassId(12345)).called(1);
    });

    test('returns null and does not mirror when nothing is stored', () async {
      when(
        () => storage.read(key: 'nfc_pass_id'),
      ).thenAnswer((_) async => null);

      expect(await repository.getPassId(), isNull);
      verifyNever(() => digitalPassChannel.savePassId(any()));
    });

    test('swallows native errors while mirroring', () async {
      when(
        () => storage.read(key: 'nfc_pass_id'),
      ).thenAnswer((_) async => '99');
      when(
        () => digitalPassChannel.savePassId(any()),
      ).thenThrow(Exception('native boom'));

      expect(await repository.getPassId(), 99);
    });
  });

  group('unbindPass', () {
    test('clears storage and the native store', () async {
      await repository.unbindPass();

      verify(() => storage.delete(key: 'nfc_cookie')).called(1);
      verify(() => storage.delete(key: 'nfc_jwt')).called(1);
      verify(() => storage.delete(key: 'nfc_pass_id')).called(1);
      verify(() => digitalPassChannel.clearPassId()).called(1);
    });
  });

  group('card emulation controls', () {
    test('isNfcAvailable delegates to the channel', () async {
      when(
        () => digitalPassChannel.isHceAvailable(),
      ).thenAnswer((_) async => false);

      expect(await repository.isNfcAvailable(), isFalse);
    });

    test('isNfcEnabled delegates to the channel', () async {
      when(
        () => digitalPassChannel.isHceEnabled(),
      ).thenAnswer((_) async => false);

      expect(await repository.isNfcEnabled(), isFalse);
    });

    test('setNfcEnabled forwards the flag', () async {
      await repository.setNfcEnabled(enabled: false);

      verify(() => digitalPassChannel.setHceEnabled(enabled: false)).called(1);
    });

    test('setForegroundPreference forwards the flag', () async {
      await repository.setForegroundPreference(enabled: true);

      verify(
        () => digitalPassChannel.setForegroundPreference(enabled: true),
      ).called(1);
    });
  });

  group('confirmBinding', () {
    test('throws NfcPassJwtFailure when no JWT is stored', () async {
      when(() => storage.read(key: 'nfc_jwt')).thenAnswer((_) async => null);

      expect(
        () => repository.confirmBinding(
          sixDigitCode: '123456',
          deviceName: 'Pixel',
        ),
        throwsA(isA<NfcPassJwtFailure>()),
      );
    });
  });
}
