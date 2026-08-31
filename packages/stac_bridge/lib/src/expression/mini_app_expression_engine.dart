import 'package:stac_bridge/src/expression/expression_analysis.dart';

abstract interface class MiniAppExpressionEngine {
  Object? evaluate(String source, Map<String, Object?> context);

  ExpressionAnalysis analyze(String source);
}
