import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/services/note_pdf_export.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  int pages(String pdf) => RegExp(r'/Type\s*/Page\b').allMatches(pdf).length;

  test(
    'exports real Cyrillic PDF with styles and clickable attachments',
    () async {
      final bytes = await exportNotePdf(
        title: 'Алгоритмы и структуры данных',
        attachmentLabel: 'Вложение',
        document: [
          {'insert': 'Поиск и сортировка'},
          {
            'insert': '\n',
            'attributes': {'header': 1},
          },
          {
            'insert': 'Жирное выделение. ',
            'attributes': {'bold': true},
          },
          {
            'insert': 'Курсивная мысль. ',
            'attributes': {'italic': true},
          },
          {
            'insert': 'Подчёркнутый текст.\n',
            'attributes': {'underline': true},
          },
          {'insert': 'Первый шаг'},
          {
            'insert': '\n',
            'attributes': {'list': 'ordered'},
          },
          {'insert': 'Второй шаг'},
          {
            'insert': '\n',
            'attributes': {'list': 'ordered'},
          },
          {'insert': 'Изучить бинарный поиск'},
          {
            'insert': '\n',
            'attributes': {'list': 'unchecked'},
          },
          {'insert': 'Прочитать введение'},
          {
            'insert': '\n',
            'attributes': {'list': 'checked'},
          },
          {
            'insert': 'while (left < right) {\n',
            'attributes': {'code-block': true},
          },
          {
            'insert': '  middle = (left + right) / 2;\n',
            'attributes': {'code-block': true},
          },
          {
            'insert': '}\n',
            'attributes': {'code-block': true},
          },
          {
            'insert': 'Документация',
            'attributes': {'link': 'https://docs.mirea.ninja'},
          },
          {'insert': '\n'},
          {
            'insert': {'image': 'https://example.com/image.png'},
          },
          {'insert': '\n'},
          {
            'insert': {
              'note-drawing': {
                'url': 'https://example.com/drawing.png',
                'strokes': '[]',
              },
            },
          },
          {'insert': '\n'},
          {
            'insert': {'image': 'data:image/png;base64,aGVsbG8='},
          },
          {'insert': '\n'},
        ],
      );
      final pdf = latin1.decode(bytes);
      expect(pdf, startsWith('%PDF-'));
      expect(pdf, contains('%%EOF'));
      expect(pages(pdf), 1);
      expect(pdf, contains('/FontFile2'));
      expect(pdf, contains('https://docs.mirea.ninja'));
      expect(pdf, contains('https://example.com/image.png'));
      expect(pdf, contains('https://example.com/drawing.png'));
      await File('.dart_tool/note-export-sample.pdf').writeAsBytes(bytes);
    },
  );

  test(
    'a single 20k-character paragraph spans several pages without overflow',
    () async {
      final text = List.filled(
        700,
        'Сложность алгоритма зависит от размера входных данных. ',
      ).join();
      expect(text.length, greaterThan(20000));
      final bytes = await exportNotePdf(
        title: 'Большой конспект',
        document: [
          {'insert': '$text\n'},
        ],
      );
      final count = pages(latin1.decode(bytes));
      expect(count, greaterThan(4));
      expect(count, lessThan(40));
    },
  );

  test('long unbroken text wraps instead of overflowing the page', () async {
    final bytes = await exportNotePdf(
      title: 'Длинная строка',
      document: [
        {'insert': '${'А' * 22000}\n'},
      ],
    );
    expect(pages(latin1.decode(bytes)), greaterThan(3));
  });

  test(
    'unsafe link schemes never produce actionable PDF annotations',
    () async {
      final bytes = await exportNotePdf(
        title: 'Ссылки',
        document: [
          {
            'insert': 'Text\n',
            'attributes': {'link': 'javascript:alert(1)'},
          },
          {
            'insert': {'image': 'file:///etc/passwd'},
          },
          {'insert': '\n'},
        ],
      );
      final pdf = latin1.decode(bytes);
      expect(pdf, isNot(contains('/URI')));
      expect(pdf, isNot(contains('/JavaScript')));
    },
  );

  test(
    'malformed operations fail rather than silently losing content',
    () async {
      await expectLater(
        exportNotePdf(
          title: 'Invalid',
          document: [
            {'retain': 12},
          ],
        ),
        throwsFormatException,
      );
    },
  );
}
