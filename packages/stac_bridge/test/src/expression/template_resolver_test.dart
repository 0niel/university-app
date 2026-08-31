import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/template_resolver.dart';

void main() {
  group('resolveTemplate', () {
    final engine = ExpressionsEngine();

    Object? resolve(String input, [Map<String, dynamic>? state]) =>
        resolveTemplate(
          input,
          engine: engine,
          context: {'state': state ?? const {}},
        );

    test('a whole placeholder returns the typed value', () {
      expect(resolve('{{state.count}}', {'count': 5}), 5);
      expect(resolve('{{state.flag}}', {'flag': true}), true);
      expect(
        resolve('{{state.items}}', {
          'items': [1, 2],
        }),
        [1, 2],
      );
    });

    test('whitespace inside a whole placeholder is tolerated', () {
      expect(resolve('  {{ state.count }} ', {'count': 7}), 7);
    });

    test('interpolation stringifies and splices', () {
      expect(resolve('Счёт: {{state.count}}', {'count': 5}), 'Счёт: 5');
      expect(
        resolve('{{state.a}}-{{state.b}}', {'a': 1, 'b': 2}),
        '1-2',
      );
    });

    test('null interpolates to an empty string', () {
      expect(resolve('x{{state.missing}}y'), 'xy');
    });

    test('strings without placeholders pass through unchanged', () {
      expect(resolve('plain text'), 'plain text');
    });

    test('leaves placeholders over unknown namespaces for Stac', () {
      // `storage` is not in the expression context — must survive untouched so
      // Stac's registry substitution still resolves {{storage.*}}.
      expect(resolve('{{storage.streak}}'), '{{storage.streak}}');
      expect(
        resolve('Серия: {{storage.streak}} дней', {'count': 1}),
        'Серия: {{storage.streak}} дней',
      );
    });

    test('mixes evaluated state with preserved storage placeholders', () {
      expect(
        resolve('{{state.name}} · {{storage.streak}}', {'name': 'Аня'}),
        'Аня · {{storage.streak}}',
      );
    });
  });
}
