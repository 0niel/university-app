import 'package:flutter_quill/quill_delta.dart';

Delta deltaFromPlainText(String text) {
  final delta = Delta();
  final trimmed = text.trimRight();
  if (trimmed.isNotEmpty) delta.insert(trimmed);
  delta.insert('\n');
  return delta;
}

String plainTextFromDelta(List<Object?> ops) {
  final buffer = StringBuffer();
  for (final op in ops) {
    if (op is Map) {
      final insert = op['insert'];
      if (insert is String) buffer.write(insert);
    }
  }
  return buffer.toString();
}
