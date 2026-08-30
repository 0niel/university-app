import 'package:collection/collection.dart';
import 'package:expressions/expressions.dart';

import 'package:stac_bridge/src/expression/expression_analysis.dart';
import 'package:stac_bridge/src/expression/mini_app_expression_engine.dart';

class ExpressionsEngine implements MiniAppExpressionEngine {
  ExpressionsEngine({Map<String, Object?>? functions})
    : _functions = functions ?? defaultFunctions;

  static final Map<String, Object?> defaultFunctions = {
    'len': (Object? x) => x is String
        ? x.length
        : x is Iterable
        ? x.length
        : x is Map<Object?, Object?>
        ? x.length
        : 0,
    'upper': (Object? s) => (s?.toString() ?? 'null').toUpperCase(),
    'lower': (Object? s) => (s?.toString() ?? 'null').toLowerCase(),
    'trim': (Object? s) => (s?.toString() ?? 'null').trim(),
    'abs': (num n) => n.abs(),
    'round': (num n) => n.round(),
    'floor': (num n) => n.floor(),
    'ceil': (num n) => n.ceil(),
    'min': (num a, num b) => a < b ? a : b,
    'max': (num a, num b) => a > b ? a : b,
    'clamp': (num n, num lo, num hi) => n.clamp(lo, hi),
    'int': (Object? x) =>
        x is num ? x.toInt() : int.tryParse(x?.toString() ?? 'null'),
    'num': (Object? x) => x is num ? x : num.tryParse(x?.toString() ?? 'null'),
    'str': (Object? x) => x?.toString() ?? '',
    'bool': (Object? x) => x == true || x == 'true',
    'contains': (Object? c, Object? x) => c is Iterable
        ? c.contains(x)
        : c is String
        ? c.contains(x?.toString() ?? 'null')
        : c is Map<Object?, Object?> && c.containsKey(x),
    'join': (Object? list, [Object? sep]) =>
        list is Iterable ? list.join(sep?.toString() ?? ', ') : '',
    'keys': (Object? m) =>
        m is Map<Object?, Object?> ? m.keys.toList() : const <Object?>[],
    'values': (Object? m) =>
        m is Map<Object?, Object?> ? m.values.toList() : const <Object?>[],
  };

  final Map<String, Object?> _functions;

  static final ExpressionEvaluator _evaluator = ExpressionEvaluator(
    memberAccessors: [
      MemberAccessor<List<Object?>>({
        'length': (l) => l.length,
        'first': (l) => l.firstOrNull,
        'last': (l) => l.lastOrNull,
        'isEmpty': (l) => l.isEmpty,
        'isNotEmpty': (l) => l.isNotEmpty,
      }),
      MemberAccessor<Iterable<Object?>>({
        'length': (l) => l.length,
        'first': (l) => l.firstOrNull,
        'last': (l) => l.lastOrNull,
        'isEmpty': (l) => l.isEmpty,
        'isNotEmpty': (l) => l.isNotEmpty,
      }),
      MemberAccessor<String>({
        'length': (s) => s.length,
        'isEmpty': (s) => s.isEmpty,
        'isNotEmpty': (s) => s.isNotEmpty,
      }),
      .mapAccessor,
    ],
  );

  final Map<String, Expression?> _cache = {};
  static const int _maxCacheEntries = 2048;

  Expression? _parse(String source) {
    final cached = _cache[source];
    if (cached != null || _cache.containsKey(source)) return cached;
    final parsed = Expression.tryParse(source);
    if (_cache.length >= _maxCacheEntries) _cache.clear();
    _cache[source] = parsed;
    return parsed;
  }

  @override
  Object? evaluate(String source, Map<String, Object?> context) {
    if (source.trim().isEmpty) return null;
    final ast = _parse(source);
    if (ast == null) return null;
    try {
      return _evaluator.eval(ast, {..._functions, ...context});
    } on Object {
      return null;
    }
  }

  @override
  ExpressionAnalysis analyze(String source) {
    final ast = _parse(source);
    if (ast == null) return .invalid;
    final identifiers = <String>{};
    final functions = <String>{};
    _walk(ast, identifiers, functions);
    return ExpressionAnalysis(
      parsed: true,
      identifiers: identifiers,
      functions: functions,
    );
  }

  void _walk(
    Expression expression,
    Set<String> identifiers,
    Set<String> functions,
  ) {
    switch (expression) {
      case final Variable variable:
        identifiers.add(variable.identifier.name);
      case final Literal literal:
        _walkLiteral(literal.value, identifiers, functions);
      case final MemberExpression member:
        _walk(member.object, identifiers, functions);
      case final IndexExpression index:
        _walk(index.object, identifiers, functions);
        _walk(index.index, identifiers, functions);
      case final CallExpression call:
        final callee = call.callee;
        if (callee is Variable) {
          functions.add(callee.identifier.name);
        } else {
          _walk(callee, identifiers, functions);
        }
        for (final argument in call.arguments) {
          _walk(argument, identifiers, functions);
        }
      case final UnaryExpression unary:
        _walk(unary.argument, identifiers, functions);
      case final BinaryExpression binary:
        _walk(binary.left, identifiers, functions);
        _walk(binary.right, identifiers, functions);
      case final ConditionalExpression conditional:
        _walk(conditional.test, identifiers, functions);
        _walk(conditional.consequent, identifiers, functions);
        _walk(conditional.alternate, identifiers, functions);
      default:
        break;
    }
  }

  void _walkLiteral(
    Object? value,
    Set<String> identifiers,
    Set<String> functions,
  ) {
    if (value is List) {
      for (final element in value) {
        if (element is Expression) _walk(element, identifiers, functions);
      }
    } else if (value is Map) {
      value.forEach((key, element) {
        if (key is Expression) _walk(key, identifiers, functions);
        if (element is Expression) _walk(element, identifiers, functions);
      });
    }
  }
}

final MiniAppExpressionEngine defaultMiniAppExpressionEngine =
    ExpressionsEngine();
