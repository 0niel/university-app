String formatGrade(double value) =>
    value.toStringAsFixed(1).replaceAll('.', ',');

String formatGradeDelta(double value) {
  final text = value.abs().toStringAsFixed(2).replaceAll('.', ',');
  if (value > 0.005) return '+$text';
  if (value < -0.005) return '−$text';
  return text;
}

String formatGap(double value) => value.toStringAsFixed(2).replaceAll('.', ',');
