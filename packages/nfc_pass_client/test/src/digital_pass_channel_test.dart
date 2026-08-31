import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('university_app/digital_pass');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const client = DigitalPassChannel();
  final calls = <MethodCall>[];

  setUp(calls.clear);
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  group('DigitalPassChannel', () {
    test('savePassId sends the id as a string', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return true;
      });

      await client.savePassId(123456);

      final [call] = calls;
      expect(call.method, 'savePassId');
      expect(call.arguments, {'passId': '123456'});
    });

    test('clearPassId sends a clearPassId call', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return true;
      });

      await client.clearPassId();

      final [call] = calls;
      expect(call.method, 'clearPassId');
    });

    test('savePassId swallows MissingPluginException', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw MissingPluginException('no impl');
      });

      await expectLater(client.savePassId(1), completes);
    });

    test('clearPassId swallows MissingPluginException', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw MissingPluginException('no impl');
      });

      await expectLater(client.clearPassId(), completes);
    });

    test('reports native capabilities as unavailable without a plugin',
        () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw MissingPluginException('no impl');
      });

      expect(await client.isHceAvailable(), isFalse);
      expect(await client.isHceEnabled(), isFalse);
    });

    test('native preference calls complete without a plugin', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw MissingPluginException('no impl');
      });

      await expectLater(client.setHceEnabled(enabled: true), completes);
      await expectLater(
        client.setForegroundPreference(enabled: true),
        completes,
      );
    });
  });
}
