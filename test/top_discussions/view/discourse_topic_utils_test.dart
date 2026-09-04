import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/top_discussions/view/discourse_topic_utils.dart';

void main() {
  const channel = MethodChannel('plugins.flutter.io/url_launcher');
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  test('opens a topic URL in an external application', () async {
    MethodCall? launchCall;
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      launchCall = call;
      return true;
    });
    addTearDown(
      () => binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );

    await openDiscourseTopic('https://mirea.ninja', 42);

    expect(launchCall?.method, 'launch');
    expect(
      launchCall?.arguments,
      containsPair('url', 'https://mirea.ninja/t/42'),
    );
    expect(launchCall?.arguments, containsPair('useWebView', false));
  });
}
