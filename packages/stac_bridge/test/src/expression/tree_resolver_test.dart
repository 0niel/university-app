import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';

void main() {
  final resolver = MiniAppTreeResolver(ExpressionsEngine());

  Map<String, Object?>? resolve(
    Map<String, Object?> node, [
    Map<String, Object?>? state,
  ]) => resolver.resolveTree(node, {'state': state ?? const {}});

  List<Object?> childrenOf(Map<String, Object?> node) {
    final children = node['children'];
    if (children is! List<Object?>) {
      throw StateError('Expected a children list');
    }
    return children;
  }

  Map<String, Object?> objectOf(Object? value) {
    if (value is! Map<Object?, Object?>) {
      throw StateError('Expected a JSON object');
    }
    return Map.from(value);
  }

  group('bindings', () {
    test('resolves {{ }} in nested values and lists', () {
      final result = resolve(
        {
          'type': 'column',
          'children': [
            {'type': 'text', 'data': 'Привет, {{state.name}}'},
            {'type': 'text', 'data': '{{state.count}}'},
          ],
        },
        {'name': 'Ann', 'count': 3},
      );

      final children = childrenOf(result!);
      expect(objectOf(children.elementAtOrNull(0))['data'], 'Привет, Ann');
      expect(objectOf(children.elementAtOrNull(1))['data'], 3);
    });
  });

  group('appIf', () {
    final node = {
      'type': 'column',
      'children': [
        {
          'type': 'appIf',
          'condition': 'state.count > 2',
          'child': {'type': 'text', 'data': 'big'},
          'else': {'type': 'text', 'data': 'small'},
        },
      ],
    };

    test('renders the child branch when the condition holds', () {
      final children = childrenOf(resolve(node, {'count': 5})!);
      expect(children, hasLength(1));
      expect(objectOf(children.singleOrNull)['data'], 'big');
    });

    test('renders the else branch when it does not', () {
      final children = childrenOf(resolve(node, {'count': 1})!);
      expect(objectOf(children.singleOrNull)['data'], 'small');
    });

    test('a false branch with no else is pruned from its parent list', () {
      final result = resolve(
        {
          'type': 'column',
          'children': [
            {
              'type': 'appIf',
              'condition': 'state.show',
              'child': {'type': 'text', 'data': 'hi'},
            },
            {'type': 'text', 'data': 'always'},
          ],
        },
        {'show': false},
      );
      final children = childrenOf(result!);
      expect(children, hasLength(1));
      expect(objectOf(children.singleOrNull)['data'], 'always');
    });

    test('resolveTree returns null when the whole root is pruned', () {
      final result = resolve(
        {
          'type': 'appIf',
          'condition': 'false',
          'child': {'type': 'text', 'data': 'never'},
        },
      );
      expect(result, isNull);
    });
  });

  group('appForEach', () {
    test('expands a list into children with item and index in scope', () {
      final result = resolve(
        {
          'type': 'appForEach',
          'items': 'state.lessons',
          'template': {
            'type': 'text',
            'data': '{{index}}: {{item.title}}',
          },
        },
        {
          'lessons': [
            {'title': 'Math'},
            {'title': 'Physics'},
          ],
        },
      );

      expect(result!['type'], 'column');
      final children = childrenOf(result);
      expect(children, hasLength(2));
      expect(objectOf(children.elementAtOrNull(0))['data'], '0: Math');
      expect(objectOf(children.elementAtOrNull(1))['data'], '1: Physics');
    });

    test('honours the as wrapper and passes extra props through', () {
      final result = resolve(
        {
          'type': 'appForEach',
          'as': 'row',
          'spacing': 8,
          'items': 'state.tags',
          'template': {'type': 'appTag', 'label': '{{item}}'},
        },
        {
          'tags': ['a', 'b'],
        },
      );
      expect(result!['type'], 'row');
      expect(result['spacing'], 8);
      expect(childrenOf(result), hasLength(2));
    });

    test('non-list items prune the node', () {
      final result = resolve(
        {
          'type': 'column',
          'children': [
            {
              'type': 'appForEach',
              'items': 'state.missing',
              'template': {'type': 'text', 'data': 'x'},
            },
          ],
        },
      );
      expect(result!['children'], isEmpty);
    });
  });

  group('wrapScreenForLogic', () {
    test('wraps a plain screen in an implicit appStateScope', () {
      final screen = {'type': 'column', 'children': <Object?>[]};
      final wrapped = wrapScreenForLogic(screen);
      expect(wrapped['type'], 'appStateScope');
      expect(wrapped['child'], same(screen));
      expect(wrapped['initial'], <String, Object?>{});
    });

    test('leaves an already-scoped screen unchanged', () {
      final screen = {
        'type': 'appStateScope',
        'initial': {'count': 0},
        'child': {'type': 'column'},
      };
      expect(wrapScreenForLogic(screen), same(screen));
    });
  });

  group('deferred subtrees', () {
    test('a nested appStateScope child is left for its own store', () {
      final result = resolve(
        {
          'type': 'column',
          'children': [
            {'type': 'text', 'data': '{{state.outer}}'},
            {
              'type': 'appStateScope',
              'initial': {'inner': 1},
              'child': {'type': 'text', 'data': '{{state.inner}}'},
            },
          ],
        },
        {'outer': 'OUT'},
      );

      final children = childrenOf(result!);
      expect(objectOf(children.elementAtOrNull(0))['data'], 'OUT');
      final innerChild = objectOf(
        objectOf(children.elementAtOrNull(1))['child'],
      );
      // Untouched — the inner scope resolves {{state.inner}} with its own store.
      expect(innerChild['data'], '{{state.inner}}');
    });

    test('forEachAction keeps its do template raw during the render pass', () {
      final result = resolve(
        {
          'type': 'appButton',
          'label': 'Go',
          'onPressed': {
            'actionType': 'forEachAction',
            'items': 'state.tags',
            'do': {
              'actionType': 'setState',
              'key': 'k',
              'value': '{{item}}',
            },
          },
        },
        {
          'tags': ['a'],
        },
      );

      final onPressed = objectOf(result!['onPressed']);
      final template = objectOf(onPressed['do']);
      // Left untouched so the loop can resolve {{item}} per iteration.
      expect(template['value'], '{{item}}');
    });
  });

  group('appSwitch', () {
    Map<String, dynamic> node() => {
      'type': 'appSwitch',
      'value': 'state.tab',
      'cases': [
        {
          'when': 'today',
          'child': {'type': 'text', 'data': 'Today'},
        },
        {
          'when': 'week',
          'child': {'type': 'text', 'data': 'Week'},
        },
      ],
      'default': {'type': 'text', 'data': 'None'},
    };

    test('matches a case by literal value', () {
      expect(resolve(node(), {'tab': 'week'})!['data'], 'Week');
    });

    test('falls back to default when nothing matches', () {
      expect(resolve(node(), {'tab': 'month'})!['data'], 'None');
    });

    test('no match and no default prunes the node', () {
      final result = resolve(
        {
          'type': 'column',
          'children': [
            {
              'type': 'appSwitch',
              'value': 'state.tab',
              'cases': [
                {
                  'when': 'today',
                  'child': {'type': 'text', 'data': 'Today'},
                },
              ],
            },
          ],
        },
        {'tab': 'never'},
      );
      expect(result!['children'], isEmpty);
    });
  });
}
