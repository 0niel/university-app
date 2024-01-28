import 'package:dynamite_end_to_end_test/interfaces.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('interfaces', () {
    expect(Base(), isA<$BaseInterface>());
    expect(BaseInterface(), isA<$BaseInterfaceInterface>());
  });
}
