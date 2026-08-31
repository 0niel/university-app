import 'package:stac_bridge/src/expression/expression_engine.dart';

// Matches a single `{{ ... }}` placeholder. Non-greedy and dot-all so it stops
// at the first `}}` and tolerates multi-line expressions. (Avoid a literal `}}`
// inside an expression — wrap such rare cases differently.)
final RegExp _placeholder = RegExp(r'\{\{(.+?)\}\}', dotAll: true);

/// Resolves `{{ expr }}` placeholders inside [input] against [context].
///
/// A placeholder is only evaluated when **every identifier it references is in
/// [context]** (e.g. `state`, `item`). Placeholders over other namespaces —
/// `{{storage.*}}` or bare registry keys — are left untouched so Stac's own
/// substitution still handles them. This keeps the expression engine and the
/// registry placeholders coexisting without stepping on each other.
///
/// When the whole trimmed string is a single evaluated placeholder, the typed
/// result is returned (number/bool/list/map/null preserved). Otherwise each
/// evaluated placeholder is stringified and spliced into the surrounding text.
Object? resolveTemplate(
  String input, {
  required MiniAppExpressionEngine engine,
  required Map<String, dynamic> context,
}) {
  if (!input.contains('{{')) return input;
  final whole = _wholePlaceholderBody(input);
  if (whole != null) {
    return _evaluable(engine, whole, context)
        ? engine.evaluate(whole, context)
        : input;
  }
  return input.replaceAllMapped(_placeholder, (m) {
    final expr = m.group(1) ?? '';
    if (!_evaluable(engine, expr, context)) return m.group(0) ?? '';
    return _stringify(engine.evaluate(expr, context));
  });
}

/// Whether [source] parses and references only identifiers present in
/// [context] (functions are always available, so they never block this).
bool _evaluable(
  MiniAppExpressionEngine engine,
  String source,
  Map<String, dynamic> context,
) {
  final analysis = engine.analyze(source);
  if (!analysis.parsed) return false;
  return analysis.identifiers.every(context.containsKey);
}

/// The inner expression when [input] (trimmed) is exactly one placeholder,
/// else null.
String? _wholePlaceholderBody(String input) {
  final trimmed = input.trim();
  final match = _placeholder.firstMatch(trimmed);
  if (match == null || match.start != 0 || match.end != trimmed.length) {
    return null;
  }
  return match.group(1);
}

String _stringify(Object? value) {
  if (value == null) return '';
  if (value is String) return value;
  return '$value';
}
