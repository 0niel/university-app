import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_document_navigation.dart';

void main() {
  test(
    'outline offsets preserve emoji, embeds and separately styled headings',
    () {
      final document = Document.fromJson([
        {'insert': '😀 Введение'},
        {
          'insert': '\n',
          'attributes': {'header': 1},
        },
        {
          'insert': {'image': 'https://example.test/image.png'},
        },
        {
          'insert': '\nТеорема',
          'attributes': {'bold': true},
        },
        {
          'insert': '\n',
          'attributes': {'header': 2},
        },
        {'insert': 'Обычный текст\n'},
      ]);
      addTearDown(document.close);
      final headings = noteHeadings(document);
      expect(headings.map((heading) => heading.title), [
        '😀 Введение',
        'Теорема',
      ]);
      expect(headings.map((heading) => heading.level), [1, 2]);
      expect(headings.last.offset, document.toPlainText().indexOf('Теорема'));
    },
  );

  test(
    'search uses literal case insensitive matches with document offsets',
    () {
      final document = Document.fromJson([
        {'insert': '😀 A+B а+б A+b\n'},
      ]);
      addTearDown(document.close);
      final matches = noteSearchMatches(document, 'a+b');
      expect(matches.length, 2);
      expect(matches.first.start, 3);
      expect(matches.last.end, document.toPlainText().length - 1);
      expect(noteSearchMatches(document, '  '), isEmpty);
      expect(noteSearchMatches(document, '['), isEmpty);
    },
  );
}
