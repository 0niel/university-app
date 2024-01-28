import 'package:dynamite_end_to_end_test/tags.openapi.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('Nested clients', () {
    final client = $Client(Uri());

    expect(client.first, isA<$FirstClient>());
    expect(identical(client.first, client.first), isTrue);

    expect(client.second, isA<$SecondClient>());
    expect(identical(client.second, client.second), isTrue);
  });
}
