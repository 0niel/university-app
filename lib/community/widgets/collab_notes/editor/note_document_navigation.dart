import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteHeading {
  const NoteHeading({
    required this.title,
    required this.offset,
    required this.level,
  });
  final String title;
  final int offset;
  final int level;
}

List<NoteHeading> noteHeadings(Document document) {
  final headings = <NoteHeading>[];
  var offset = 0;
  var lineStart = 0;
  var line = StringBuffer();
  for (final operation in document.toDelta().toList()) {
    final data = operation.data;
    if (data is! String) {
      offset++;
      continue;
    }
    final parts = data.split('\n');
    for (var index = 0; index < parts.length; index++) {
      line.write(parts[index]);
      offset += parts[index].length;
      if (index == parts.length - 1) continue;
      final level = operation.attributes?[Attribute.header.key];
      final title = line.toString().trim();
      if (level is int && title.isNotEmpty) {
        headings.add(
          NoteHeading(title: title, offset: lineStart, level: level),
        );
      }
      offset++;
      lineStart = offset;
      line = StringBuffer();
    }
  }
  return headings;
}

List<TextSelection> noteSearchMatches(Document document, String query) {
  if (query.trim().isEmpty) return const [];
  return RegExp(RegExp.escape(query), caseSensitive: false)
      .allMatches(document.toPlainText())
      .map(
        (match) =>
            TextSelection(baseOffset: match.start, extentOffset: match.end),
      )
      .toList(growable: false);
}
