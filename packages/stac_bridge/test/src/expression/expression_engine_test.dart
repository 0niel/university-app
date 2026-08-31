import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';

void main() {
  group('ExpressionsEngine.evaluate', () {
    final engine = ExpressionsEngine();

    Object? eval(String source, [Map<String, dynamic>? state]) =>
        engine.evaluate(source, <String, dynamic>{'state': state ?? const {}});

    test('arithmetic respects precedence', () {
      expect(eval('1 + 2 * 3'), 7);
      expect(eval('(1 + 2) * 3'), 9);
    });

    test('reads scalar and nested state members', () {
      expect(eval('state.count + 1', {'count': 4}), 5);
      expect(
        eval('state.user.name', {
          'user': {'name': 'Ann'},
        }),
        'Ann',
      );
    });

    test('comparison feeds a ternary', () {
      expect(eval('state.score >= 80 ? "A" : "B"', {'score': 91}), 'A');
      expect(eval('state.score >= 80 ? "A" : "B"', {'score': 40}), 'B');
    });

    test('null-coalescing falls back for missing data', () {
      expect(eval('state.nickname ?? "guest"'), 'guest');
      expect(eval('state.nickname ?? "guest"', {'nickname': 'neo'}), 'neo');
    });

    test('boolean logic combines flags', () {
      expect(eval('state.a && state.b', {'a': true, 'b': false}), false);
      expect(eval('state.a || state.b', {'a': true, 'b': false}), true);
    });

    test('member accessors expose length on lists and strings', () {
      expect(
        eval('state.items.length', {
          'items': [1, 2, 3],
        }),
        3,
      );
      expect(eval('state.name.length', {'name': 'mirea'}), 5);
    });

    test('index access into a list', () {
      expect(
        eval('state.items[0]', {
          'items': ['a', 'b'],
        }),
        'a',
      );
    });

    test('curated functions are callable', () {
      expect(
        eval('len(state.items)', {
          'items': [1, 2],
        }),
        2,
      );
      expect(eval('upper(state.name)', {'name': 'go'}), 'GO');
      expect(eval('min(3, 5)'), 3);
      expect(eval('max(3, 5)'), 5);
      expect(eval('round(3.6)'), 4);
      expect(
        eval('contains(state.items, 2)', {
          'items': [1, 2, 3],
        }),
        true,
      );
      expect(
        eval('join(state.items, "-")', {
          'items': ['a', 'b'],
        }),
        'a-b',
      );
    });

    test('list and map literals evaluate', () {
      expect(eval('[1, 2, 3]'), [1, 2, 3]);
      expect(eval("{'a': 1}"), {'a': 1});
    });

    test('unknown variable resolves to null', () {
      expect(eval('whatever'), isNull);
    });

    test('unknown function call collapses to null', () {
      expect(eval('mystery(1, 2)'), isNull);
    });

    test('type mismatch collapses to null instead of throwing', () {
      expect(eval('state.missing + 1'), isNull);
    });

    test('parse error and blank source return null', () {
      expect(eval('1 +'), isNull);
      expect(eval('   '), isNull);
    });
  });

  group('ExpressionsEngine.analyze', () {
    final engine = ExpressionsEngine();

    test('collects root identifiers and function names', () {
      final result = engine.analyze('len(state.items) + item.size');
      expect(result.parsed, isTrue);
      expect(result.identifiers, <String>{'state', 'item'});
      expect(result.functions, <String>{'len'});
    });

    test('member chains report only the root identifier', () {
      final result = engine.analyze('state.user.profile.name');
      expect(result.identifiers, <String>{'state'});
    });

    test('invalid source reports not parsed', () {
      final result = engine.analyze('1 +');
      expect(result.parsed, isFalse);
      expect(result.identifiers, isEmpty);
      expect(result.functions, isEmpty);
    });
  });
}
