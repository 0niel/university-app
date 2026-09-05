import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> exportNotePdf({
  required String title,
  required List<Object?> document,
  String attachmentLabel = 'Attachment',
}) async {
  final fonts = await Future.wait([
    for (final path in [
      'packages/app_ui/assets/fonts/Onest/Onest-Regular.ttf',
      'packages/app_ui/assets/fonts/Onest/Onest-Bold.ttf',
      'packages/app_ui/assets/fonts/Literata/Literata-Italic-Variable.ttf',
    ])
      Future(() => rootBundle.load(path)),
  ]);
  return compute(
    _buildNotePdf,
    _NotePdfInput(title, document, attachmentLabel, fonts),
  );
}

Future<Uint8List> _buildNotePdf(_NotePdfInput input) async {
  final title = input.title;
  final document = input.document;
  final attachmentLabel = input.attachmentLabel;
  final fonts = input.fonts;
  final regular = pw.Font.ttf(fonts[0]);
  final bold = pw.Font.ttf(fonts[1]);
  final italic = pw.Font.ttf(fonts[2]);
  final pdf = pw.Document(
    title: title,
    theme: pw.ThemeData.withFont(
      base: regular,
      bold: bold,
      italic: italic,
      boldItalic: italic,
    ),
  );
  final blocks = _readNoteBlocks(document, attachmentLabel);
  final content = <pw.Widget>[
    if (title.trim().isNotEmpty) ...[
      pw.RichText(
        overflow: pw.TextOverflow.span,
        text: pw.TextSpan(
          text: title.trim(),
          style: pw.TextStyle(fontSize: 23, fontWeight: pw.FontWeight.bold),
        ),
      ),
      pw.SizedBox(height: 12),
      pw.Divider(color: PdfColors.grey300),
      pw.SizedBox(height: 12),
    ],
  ];
  final counters = <int, int>{};
  for (final block in blocks) {
    final attributes = block.attributes;
    final header = attributes['header'];
    final indent = attributes['indent'];
    final depth = indent is num ? indent.toInt().clamp(0, 8) : 0;
    final list = attributes['list'];
    var prefix = '';
    if (list == 'ordered') {
      counters.removeWhere((level, _) => level > depth);
      final count = counters.update(
        depth,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      prefix = '$count. ';
    } else {
      counters.clear();
      prefix = switch (list) {
        'bullet' => '- ',
        'checked' => '[x] ',
        'unchecked' => '[ ] ',
        _ => attributes['blockquote'] == true ? '> ' : '',
      };
    }
    final code = attributes['code-block'] == true;
    final fontSize = switch (header) {
      1 => 18.0,
      2 => 15.0,
      3 => 13.0,
      _ => code ? 10.0 : 11.0,
    };
    content
      ..add(
        pw.RichText(
          overflow: pw.TextOverflow.span,
          textAlign: switch (attributes['align']) {
            'center' => pw.TextAlign.center,
            'right' => pw.TextAlign.right,
            'justify' => pw.TextAlign.justify,
            _ => pw.TextAlign.left,
          },
          text: pw.TextSpan(
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: header is num
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              lineSpacing: code ? 2 : 3,
              color: PdfColors.grey900,
              background: code
                  ? const pw.BoxDecoration(color: PdfColors.grey100)
                  : null,
            ),
            children: [
              if (prefix.isNotEmpty || depth > 0)
                pw.TextSpan(text: '${'  ' * depth}$prefix'),
              for (final run in block.runs) _pdfSpan(run),
              if (block.runs.isEmpty) const pw.TextSpan(text: ' '),
            ],
          ),
        ),
      )
      ..add(pw.SizedBox(height: code || list != null ? 4 : 8));
  }
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(42, 42, 42, 38),
      maxPages: 1000,
      build: (_) => content,
      footer: (context) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 12),
        child: pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ),
      ),
    ),
  );
  return pdf.save();
}

pw.TextSpan _pdfSpan(_NotePdfRun run) {
  final attributes = run.attributes;
  final link = _safeNotePdfLink(attributes['link']);
  final background = _pdfColor(attributes['background']);
  final decorations = <pw.TextDecoration>[
    if (attributes['underline'] == true || link != null)
      pw.TextDecoration.underline,
    if (attributes['strike'] == true) pw.TextDecoration.lineThrough,
  ];
  return pw.TextSpan(
    text: run.text,
    annotation: link == null ? null : pw.AnnotationUrl(link),
    style: pw.TextStyle(
      fontWeight: attributes['bold'] == true ? pw.FontWeight.bold : null,
      fontStyle: attributes['italic'] == true ? pw.FontStyle.italic : null,
      color: link == null ? _pdfColor(attributes['color']) : PdfColors.blue700,
      decoration: decorations.isEmpty
          ? null
          : pw.TextDecoration.combine(decorations),
      background: background == null
          ? null
          : pw.BoxDecoration(color: background),
    ),
  );
}

PdfColor? _pdfColor(Object? value) {
  if (value is! String || !RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(value)) {
    return null;
  }
  return PdfColor.fromInt(
    0xFF000000 | int.parse(value.substring(1), radix: 16),
  );
}

String? _safeNotePdfLink(Object? value) {
  if (value is! String) return null;
  final uri = Uri.tryParse(value.trim());
  if (uri == null) return null;
  if ((uri.scheme == 'https' || uri.scheme == 'http') && uri.host.isNotEmpty) {
    return uri.toString();
  }
  if ((uri.scheme == 'mailto' || uri.scheme == 'tel') && uri.path.isNotEmpty) {
    return uri.toString();
  }
  return null;
}

List<_NotePdfBlock> _readNoteBlocks(
  List<Object?> operations,
  String attachmentLabel,
) {
  final blocks = <_NotePdfBlock>[];
  var runs = <_NotePdfRun>[];
  for (final operation in operations) {
    if (operation is! Map) {
      throw const FormatException('Invalid note operation');
    }
    final attributes = operation['attributes'];
    final style = attributes is Map ? attributes : const <String, Object?>{};
    final insert = operation['insert'];
    if (insert is String) {
      final lines = insert.split('\n');
      for (final (index, line) in lines.indexed) {
        if (line.isNotEmpty) runs.add(_NotePdfRun(line, style));
        if (index < lines.length - 1) {
          blocks.add(_NotePdfBlock(runs, style));
          runs = [];
        }
      }
    } else if (insert is Map) {
      for (final entry in insert.entries) {
        final value = entry.value;
        final target = value is Map ? value['url'] : value;
        final url = _safeNotePdfLink(target);
        runs.add(
          _NotePdfRun(
            url == null ? '[$attachmentLabel]' : '[$attachmentLabel] $url',
            {'link': ?url},
          ),
        );
      }
    } else {
      throw const FormatException('Invalid note insert');
    }
  }
  if (runs.isNotEmpty) blocks.add(_NotePdfBlock(runs, const {}));
  return blocks;
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
