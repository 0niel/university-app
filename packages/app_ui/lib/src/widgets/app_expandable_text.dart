import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppExpandableText extends StatefulWidget {
  const AppExpandableText({
    required this.text,
    required this.expandLabel,
    required this.collapseLabel,
    super.key,
    this.style,
    this.linkColor,
    this.collapsedMaxLines = 4,
  });

  final String text;
  final String expandLabel;
  final String collapseLabel;
  final TextStyle? style;
  final Color? linkColor;
  final int collapsedMaxLines;

  @override
  State<AppExpandableText> createState() => _AppExpandableTextState();
}

class _AppExpandableTextState extends State<AppExpandableText> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = widget.style ?? AppText.subtext.copyWith(color: colors.ink);
    final linkColor = widget.linkColor ?? colors.accent;
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.collapsedMaxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        if (!overflows) {
          return Text(widget.text, style: style);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : widget.collapsedMaxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            AppPressable(
              onTap: () => setState(() => _expanded = !_expanded),
              semanticsButton: true,
              semanticsLabel:
                  _expanded ? widget.collapseLabel : widget.expandLabel,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _expanded ? widget.collapseLabel : widget.expandLabel,
                  style: AppText.captionSmall.copyWith(
                    color: linkColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
