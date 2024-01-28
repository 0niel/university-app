import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('Dart helpers', () {
    test('toDartName', () {
      const values = [
        ('test', 'test', 'Test'),
        ('void', r'$void', 'Void'),
        ('10', r'$10', r'$10'),
        ('trailingNumber10', 'trailingNumber10', 'TrailingNumber10'),
        (r'$leadingDollar', 'leadingDollar', 'LeadingDollar'),
        ('kebab-case', 'kebabCase', 'KebabCase'),
        ('Upper-Kebab-Case', 'upperKebabCase', 'UpperKebabCase'),
        ('UpperCamelCase', 'upperCamelCase', 'UpperCamelCase'),
        ('lowerCamelCase', 'lowerCamelCase', 'LowerCamelCase'),
        ('snake_case', 'snakeCase', 'SnakeCase'),
        ('Upper_Snake_Case', 'upperSnakeCase', 'UpperSnakeCase'),
      ];

      for (final value in values) {
        expect(toDartName(value.$1), value.$2);
        expect(toDartName(value.$1, uppercaseFirstCharacter: true), value.$3);
      }
    });

    test('capitalize', () {
      expect(''.capitalize(), '');
      expect('   '.capitalize(), '   ');
      expect('testValue'.capitalize(), 'TestValue');
      expect('TestValue'.capitalize(), 'TestValue');
    });
  });
}
