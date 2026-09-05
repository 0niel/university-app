import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/services/note_text_actions.dart';

void main() {
  QuillController controller() => QuillController(
    document: Document()..insert(0, 'Hello world'),
    selection: const TextSelection(baseOffset: 0, extentOffset: 5),
  );

  test(
    'replaces only the captured selection and preserves surrounding text',
    () {
      final editor = controller();
      addTearDown(editor.dispose);
      final snapshot = NoteTextSelectionSnapshot.capture(editor)!;
      expect(snapshot.text, 'Hello');
      expect(snapshot.apply(editor, 'Привет', readOnly: false), isTrue);
      expect(editor.document.toPlainText(), 'Привет world\n');
    },
  );

  test('refuses an empty selection, whitespace and embedded content', () {
    final editor = controller();
    addTearDown(editor.dispose);
    editor.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
    expect(NoteTextSelectionSnapshot.capture(editor), isNull);
    editor.updateSelection(
      const TextSelection(baseOffset: 5, extentOffset: 6),
      ChangeSource.local,
    );
    expect(NoteTextSelectionSnapshot.capture(editor), isNull);
    editor
      ..replaceText(
        0,
        5,
        BlockEmbed.image('https://example.com/photo.png'),
        null,
      )
      ..updateSelection(
        const TextSelection(baseOffset: 0, extentOffset: 1),
        ChangeSource.local,
      );
    expect(NoteTextSelectionSnapshot.capture(editor), isNull);
  });

  test('refuses local or remote changes outside the selected text', () {
    final editor = controller();
    addTearDown(editor.dispose);
    final snapshot = NoteTextSelectionSnapshot.capture(editor)!;
    editor.document.compose(
      Delta()
        ..retain(11)
        ..insert('!'),
      ChangeSource.remote,
    );
    expect(snapshot.apply(editor, 'Привет', readOnly: false), isFalse);
    expect(editor.document.toPlainText(), 'Hello world!\n');
  });

  test('refuses selection movement, read-only state and empty replacement', () {
    final editor = controller();
    addTearDown(editor.dispose);
    final snapshot = NoteTextSelectionSnapshot.capture(editor)!;
    expect(snapshot.apply(editor, 'Привет', readOnly: true), isFalse);
    editor.readOnly = true;
    expect(snapshot.apply(editor, 'Привет', readOnly: false), isFalse);
    editor.readOnly = false;
    expect(snapshot.apply(editor, ' ', readOnly: false), isFalse);
    editor.updateSelection(
      const TextSelection(baseOffset: 6, extentOffset: 11),
      ChangeSource.local,
    );
    expect(snapshot.apply(editor, 'Привет', readOnly: false), isFalse);
    expect(editor.document.toPlainText(), 'Hello world\n');
  });

  test(
    'queries real actions and forwards only requested text and readonly flag',
    () async {
      final platform = _ProcessText();
      final actions = NoteTextActions(processTextService: platform);
      expect(await actions.availableActions(), [
        const ProcessTextAction('translate', 'Translate'),
      ]);
      expect(
        await actions.process(
          const ProcessTextAction('translate', 'Translate'),
          'Hello',
          readOnly: true,
        ),
        'Привет',
      );
      expect(platform.lastCall, ('translate', 'Hello', true));
    },
  );
}

class _ProcessText implements ProcessTextService {
  (String, String, bool)? lastCall;

  @override
  Future<List<ProcessTextAction>> queryTextActions() async => const [
    ProcessTextAction('translate', 'Translate'),
    ProcessTextAction('translate', 'Translate again'),
    ProcessTextAction('', 'Invalid'),
    ProcessTextAction('blank', ' '),
  ];

  @override
  Future<String?> processTextAction(
    String id,
    String text,
    bool readOnly,
  ) async {
    lastCall = (id, text, readOnly);
    return 'Привет';
  }
}
