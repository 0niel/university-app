import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/utils.dart';

@immutable
class FindableTest implements Findable {
  const FindableTest(this.id);

  @override
  final String id;
}

void main() {
  const findable1 = FindableTest('1');
  const findable2 = FindableTest('2');
  final elements = [findable1, findable2];

  test('tryFind', () {
    expect(elements.tryFind(null), isNull);
    expect(elements.tryFind('3'), isNull);
    expect(elements.tryFind(findable1.id), equals(findable1));
    expect(elements.tryFind(findable2.id), equals(findable2));
  });

  test('find', () {
    expect(() => elements.find('3'), throwsA(isA<StateError>()));
    expect(elements.find(findable1.id), equals(findable1));
    expect(elements.find(findable2.id), equals(findable2));
  });
}
