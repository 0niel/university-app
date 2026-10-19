part of 'note_pdf_export.dart';

class _NotePdfInput {
  const _NotePdfInput(
    this.title,
    this.document,
    this.attachmentLabel,
    this.fonts,
  );

  final String title;
  final List<Object?> document;
  final String attachmentLabel;
  final List<ByteData> fonts;
}

class _NotePdfRun {
  const _NotePdfRun(this.text, this.attributes);

  final String text;
  final Map<Object?, Object?> attributes;
}

class _NotePdfBlock {
  const _NotePdfBlock(this.runs, this.attributes);

  final List<_NotePdfRun> runs;
  final Map<Object?, Object?> attributes;
}
