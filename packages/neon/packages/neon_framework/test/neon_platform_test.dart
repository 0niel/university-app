import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/src/platform/platform.dart';

void main() {
  test('NeonPlatform', () async {
    expect(() => NeonPlatform.instance, throwsA(isA<StateError>()));

    await NeonPlatform.setup();

    expect(NeonPlatform.instance, isA<NeonPlatform>());
  });
}
