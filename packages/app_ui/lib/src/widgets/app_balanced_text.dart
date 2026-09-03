import 'package:flutter/widgets.dart';

class AppBalancedText extends StatelessWidget {
  const AppBalancedText(
    String this.data, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
  }) : textSpan = null;

  const AppBalancedText.rich(
    InlineSpan this.textSpan, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
  }) : data = null;

  final String? data;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final resolved = DefaultTextStyle.of(context).style.merge(style);
    final span = TextSpan(
      text: data,
      style: resolved,
      children: textSpan == null ? null : [textSpan!],
    );
    final text = Text.rich(span, textAlign: textAlign);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || constraints.maxWidth <= 0) {
          return text;
        }
        final painter = TextPainter(
          text: span,
          textAlign: textAlign,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
          locale: Localizations.maybeLocaleOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        try {
          final lines = painter.computeLineMetrics().length;
          if (lines < 2 || lines > 6) return text;
          var lower = painter.minIntrinsicWidth
              .clamp(constraints.maxWidth / lines, constraints.maxWidth);
          var upper = constraints.maxWidth;
          for (var i = 0; i < 12; i++) {
            final middle = (lower + upper) / 2;
            painter.layout(maxWidth: middle);
            if (painter.computeLineMetrics().length > lines) {
              lower = middle;
            } else {
              upper = middle;
            }
          }
          return Align(
            alignment: textAlign == TextAlign.center
                ? Alignment.topCenter
                : AlignmentDirectional.topStart,
            child: SizedBox(width: upper, child: text),
          );
        } finally {
          painter.dispose();
        }
      },
    );
  }
}
