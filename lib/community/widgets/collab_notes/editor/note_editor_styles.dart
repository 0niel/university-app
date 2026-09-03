import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

DefaultStyles noteEditorStyles(BuildContext context) {
  final colors = context.colors;
  const zeroH = HorizontalSpacing.zero;
  const zeroV = VerticalSpacing.zero;

  DefaultTextBlockStyle heading(TextStyle style) => DefaultTextBlockStyle(
    style.copyWith(color: colors.ink),
    zeroH,
    const VerticalSpacing(12, 6),
    zeroV,
    null,
  );

  return DefaultStyles(
    h1: heading(AppText.sectionLarge),
    h2: heading(AppText.section),
    h3: heading(AppText.sectionSmall),
    paragraph: DefaultTextBlockStyle(
      AppText.paragraph.copyWith(color: colors.ink),
      zeroH,
      const VerticalSpacing(4, 4),
      zeroV,
      null,
    ),
    bold: const TextStyle(fontWeight: FontWeight.w700),
    italic: const TextStyle(fontStyle: FontStyle.italic),
    underline: const TextStyle(decoration: TextDecoration.underline),
    strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
    link: TextStyle(
      color: colors.accent,
      decoration: TextDecoration.underline,
      decorationColor: colors.accent,
    ),
    inlineCode: InlineCodeStyle(
      style: AppText.sans(13.5, FontWeight.w600).copyWith(color: colors.ink),
      backgroundColor: colors.surface2,
      radius: const Radius.circular(AppRadius.xxs),
    ),
    quote: DefaultTextBlockStyle(
      AppText.body.copyWith(color: colors.muted, fontStyle: FontStyle.italic),
      const HorizontalSpacing(16, 0),
      const VerticalSpacing(8, 8),
      zeroV,
      BoxDecoration(
        border: Border(left: BorderSide(color: colors.line, width: 3)),
      ),
    ),
    code: DefaultTextBlockStyle(
      AppText.sans(13, FontWeight.w500, tabular: true).copyWith(
        color: colors.ink,
      ),
      const HorizontalSpacing(12, 12),
      const VerticalSpacing(8, 8),
      const VerticalSpacing(2, 2),
      BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    ),
    lists: DefaultListBlockStyle(
      AppText.body.copyWith(color: colors.ink),
      zeroH,
      const VerticalSpacing(3, 3),
      zeroV,
      null,
      null,
    ),
    placeHolder: DefaultTextBlockStyle(
      AppText.paragraph.copyWith(color: colors.muted),
      zeroH,
      zeroV,
      zeroV,
      null,
    ),
  );
}
