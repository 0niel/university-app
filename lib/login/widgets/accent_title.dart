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
    final accentText = accent ?? '';
    final index = accentText.isEmpty ? -1 : text.lastIndexOf(accentText);
    if (index < 0) return Text(text, style: base);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: accentText,
            style: base.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: text.substring(index + accentText.length)),
        ],
      ),
    );
  }
}
