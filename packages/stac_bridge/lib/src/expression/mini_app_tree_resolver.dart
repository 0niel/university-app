import 'package:stac_bridge/src/expression/condition.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/template_resolver.dart';

Map<String, Object?> wrapScreenForLogic(Map<String, Object?> screen) {
  if (screen['type'] == 'appStateScope') return screen;
  return {
    'type': 'appStateScope',
    'initial': <String, Object?>{},
    'child': screen,
  };
}

class _Removed {
  const _Removed();
}

const kRemoved = _Removed();

class MiniAppTreeResolver {
  const MiniAppTreeResolver(
    this._engine, {
    this.itemVar = 'item',
    this.indexVar = 'index',
    this.deferActions = false,
    this.deferWidgets = false,
  });

  final MiniAppExpressionEngine _engine;
  final String itemVar;
  final String indexVar;
  final bool deferActions;
  final bool deferWidgets;

  static const _eagerWidgets = {
    'appBar',
    'alertDialog',
    'elevatedButton',
    'filledButton',
    'outlinedButton',
    'textButton',
    'iconButton',
    'floatingActionButton',
    'circleAvatar',
    'listTile',
  };

  static const _widgetSlots = {
    'child',
    'children',
    'body',
    'appBar',
    'bottomNavigationBar',
    'floatingActionButton',
    'drawer',
    'endDrawer',
    'leading',
    'trailing',
    'title',
    'subtitle',
    'content',
    'actions',
    'header',
    'footer',
    'separator',
    'background',
    'placeholder',
    'errorWidget',
    'icon',
    'prefix',
    'suffix',
  };

  static const Set<String> _forEachKeys = {
    'type',
    'items',
    'template',
    'as',
  };

  Map<String, Object?>? resolveTree(
    Map<String, Object?> node,
    Map<String, Object?> context,
  ) {
    final resolved = _resolve(node, context);
    return resolved is Map<String, Object?> ? resolved : null;
  }

  Object? resolveNode(Object? node, Map<String, Object?> context) =>
      _resolve(node, context);

  Map<String, Object?> resolveAction(
    Map<String, Object?> node,
    Map<String, Object?> context,
  ) => _resolveMap(node, context);

  Object? _resolve(Object? node, Map<String, Object?> context) {
    if (node is Map<Object?, Object?>) {
      if (deferActions && node['actionType'] is String) {
        if (node['actionType'] == 'appRunAction') return node;
        return <String, Object?>{
          'actionType': 'appRunAction',
          'action': node,
          'bindings': {
            for (final entry in context.entries)
              if (entry.key != 'state') entry.key: entry.value,
          },
        };
      }
      switch (node['type']) {
        case 'appIf':
          return _resolveIf(node, context);
        case 'appForEach':
          return _resolveForEach(node, context);
        case 'appSwitch':
          return _resolveSwitch(node, context);
        default:
          return _resolveMap(node, context);
      }
    }
    if (node is List<Object?>) return _resolveList(node, context);
    if (node is String) {
      return resolveTemplate(node, engine: _engine, context: context);
    }
    return node;
  }

  Map<String, Object?> _resolveMap(
    Map<Object?, Object?> node,
    Map<String, Object?> context,
  ) {
    if (deferWidgets && _eagerWidgets.contains(node['type'])) {
      return MiniAppTreeResolver(
        _engine,
        deferActions: deferActions,
      ).resolveAction(Map<String, Object?>.from(node), context);
    }
    final deferredKey = _deferredKey(node);
    final out = <String, Object?>{};
    node.forEach((key, value) {
      final normalizedKey = key?.toString() ?? 'null';
      if (key == deferredKey) {
        out[normalizedKey] = value;
        return;
      }
      if (deferWidgets &&
          normalizedKey != 'appBar' &&
          _widgetSlots.contains(normalizedKey)) {
        final child = _deferWidget(value, context);
        if (!identical(child, kRemoved)) out[normalizedKey] = child;
        return;
      }
      final resolved = _resolve(value, context);
      if (!identical(resolved, kRemoved)) out[normalizedKey] = resolved;
    });
    return out;
  }

  Object? _deferWidget(Object? value, Map<String, Object?> context) {
    if (value is Map<Object?, Object?> && value['type'] == 'appIf') {
      return _resolveIf(value, context);
    }
    if (value is Map<Object?, Object?> && value['type'] == 'appSwitch') {
      return _resolveSwitch(value, context);
    }
    if (value is Map<Object?, Object?> &&
        value['type'] is String &&
        value['actionType'] == null) {
      return <String, Object?>{
        'type': 'appReactiveNode',
        'node': {
          ...value,
          if (value.containsKey('key')) 'key': _resolve(value['key'], context),
        },
        'bindings': {
          for (final entry in context.entries)
            if (entry.key != 'state') entry.key: entry.value,
        },
      };
    }
    if (value is List<Object?>) {
      final children = <Object?>[];
      for (final item in value) {
        final child = _deferWidget(item, context);
        if (!identical(child, kRemoved)) children.add(child);
      }
      return children;
    }
    return _resolve(value, context);
  }

  String? _deferredKey(Map<Object?, Object?> node) {
    if (node['type'] == 'appStateScope') return 'child';
    if (node['actionType'] == 'forEachAction') return 'do';
    if (node['actionType'] == 'appRunAction') return 'action';
    return null;
  }

  List<Object?> _resolveList(
    List<Object?> node,
    Map<String, Object?> context,
  ) {
    final out = <Object?>[];
    for (final item in node) {
      final resolved = _resolve(item, context);
      if (!identical(resolved, kRemoved)) out.add(resolved);
    }
    return out;
  }

  Object? _resolveIf(
    Map<Object?, Object?> node,
    Map<String, Object?> context,
  ) {
    final pass = isTruthy(_evalLogic(node['condition'], context));
    final branch = pass ? node['child'] : node['else'];
    return branch == null
        ? kRemoved
        : deferWidgets
        ? _deferWidget(branch, context)
        : _resolve(branch, context);
  }

  Object _resolveForEach(
    Map<Object?, Object?> node,
    Map<String, Object?> context,
  ) {
    final items = _evalLogic(node['items'], context);
    final template = node['template'];
    if (items is! List<Object?> || template == null) return kRemoved;

    final children = <Object?>[];
    for (var i = 0; i < items.length; i++) {
      final scoped = {
        ...context,
        itemVar: items[i],
        indexVar: i,
      };
      final resolved = deferWidgets
          ? _deferWidget(template, scoped)
          : _resolve(template, scoped);
      if (!identical(resolved, kRemoved)) children.add(resolved);
    }

    final as = node['as'];
    final extras = <String, Object?>{};
    node.forEach((key, value) {
      if (!_forEachKeys.contains(key)) {
        final normalizedKey = key?.toString() ?? 'null';
        extras[normalizedKey] = _resolve(value, context);
      }
    });
    return <String, Object?>{
      ...extras,
      'type': as is String && as.isNotEmpty ? as : 'column',
      'children': children,
    };
  }

  Object? _resolveSwitch(
    Map<Object?, Object?> node,
    Map<String, Object?> context,
  ) {
    final cases = node['cases'];
    if (cases is List<Object?>) {
      final value = _evalLogic(node['value'], context);
      for (final entry in cases) {
        if (entry is Map<Object?, Object?> && entry.containsKey('when')) {
          if (_literalOrExpr(entry['when'], context) == value) {
            return deferWidgets
                ? _deferWidget(entry['child'], context)
                : _resolve(entry['child'], context);
          }
        }
      }
    }
    final fallback = node['default'];
    return fallback == null
        ? kRemoved
        : deferWidgets
        ? _deferWidget(fallback, context)
        : _resolve(fallback, context);
  }

  Object? _evalLogic(Object? source, Map<String, Object?> context) {
    if (source is! String) return source;
    return _engine.evaluate(stripExpressionBraces(source), context);
  }

  Object? _literalOrExpr(Object? raw, Map<String, Object?> context) {
    if (raw is String) {
      final trimmed = raw.trim();
      if (trimmed.startsWith('{{') && trimmed.endsWith('}}')) {
        return _engine.evaluate(stripExpressionBraces(trimmed), context);
      }
    }
    return raw;
  }
}
