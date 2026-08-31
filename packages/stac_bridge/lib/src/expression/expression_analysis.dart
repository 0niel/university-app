class ExpressionAnalysis {
  const ExpressionAnalysis({
    required this.parsed,
    required this.identifiers,
    required this.functions,
  });

  static const ExpressionAnalysis invalid = .new(
    parsed: false,
    identifiers: {},
    functions: {},
  );

  final bool parsed;
  final Set<String> identifiers;
  final Set<String> functions;
}
