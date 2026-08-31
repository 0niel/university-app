part of '../schedule_details_page.dart';

class _HashtagTextController extends TextEditingController {
  _HashtagTextController({required this.accent, super.text});
  final Color accent;
  static final _pattern = RegExp(r'#[\wА-Яа-яЁё]+');

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final base = style ?? const TextStyle();
    if (text.isEmpty) return TextSpan(text: text, style: base);
    final children = <InlineSpan>[];
    var index = 0;
    for (final match in _pattern.allMatches(text)) {
      if (match.start > index) {
        children.add(
          TextSpan(text: text.substring(index, match.start), style: base),
        );
      }
      children.add(
        TextSpan(
          text: match.group(0),
          style: base.copyWith(color: accent, fontWeight: .w600),
        ),
      );
      index = match.end;
    }
    if (index < text.length) {
      children.add(TextSpan(text: text.substring(index), style: base));
    }
    return TextSpan(style: base, children: children);
  }
}
