import 'package:dynamite_end_to_end_test/pattern_check.openapi.dart';
import 'package:test/test.dart';

void main() {
  const validString = '01234';
  final object = TestObject(
    (b) => b
      ..onlyNumbers = validString
      ..minLength = validString
      ..maxLength = validString
      ..multipleChecks = validString,
  );

  group('Pattern check', () {
    test('onlyNumbers', () {
      object.rebuild((b) => b..onlyNumbers = null);
      expect(() => object.rebuild((b) => b..onlyNumbers = 'Text'), throwsA(isA<FormatException>()));
    });

    test('minLength', () {
      object.rebuild((b) => b..minLength = null);
      expect(() => object.rebuild((b) => b..minLength = ''), throwsA(isA<FormatException>()));
      expect(() => object.rebuild((b) => b..minLength = 'Te'), throwsA(isA<FormatException>()));
      expect(() => object.rebuild((b) => b..minLength = '12'), throwsA(isA<FormatException>()));
    });

    test('maxLength', () {
      object.rebuild((b) => b..maxLength = null);
      expect(
        () => object.rebuild((b) => b..maxLength = 'Super long text should throw'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => object.rebuild((b) => b..maxLength = '419712642879393808962'),
        throwsA(isA<FormatException>()),
      );
    });

    test('multipleChecks', () {
      object.rebuild((b) => b..multipleChecks = null);
      expect(() => object.rebuild((b) => b..multipleChecks = 'Text'), throwsA(isA<FormatException>()));
      expect(() => object.rebuild((b) => b..minLength = ''), throwsA(isA<FormatException>()));
      expect(() => object.rebuild((b) => b..minLength = '12'), throwsA(isA<FormatException>()));
      expect(
        () => object.rebuild((b) => b..maxLength = '419712642879393808962'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
