import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class AccentTitle extends StatelessWidget {
  const AccentTitle(this.text, {super.key, this.accent, this.style});

  final String text;
  final String? accent;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = (style ?? AppText.displayHero).copyWith(color: colors.ink);
    final accent = this.accent ?? '';
    final index = accent.isEmpty ? -1 : text.lastIndexOf(accent);
    if (index < 0) return Text(text, style: base);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: accent,
            style: base.copyWith(
              color: colors.accent,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(text: text.substring(index + accent.length)),
        ],
      ),
    );
  }
}
