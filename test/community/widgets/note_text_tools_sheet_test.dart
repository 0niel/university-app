import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/services/note_text_actions.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/note_text_tools_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  late QuillController controller;
  late _ProcessText platform;
  late NoteTextActions actions;
  String? copied;
  String? shared;

  setUp(() {
    controller = QuillController(
      document: Document()..insert(0, 'Hello world'),
      selection: const TextSelection(baseOffset: 0, extentOffset: 5),
    );
    platform = _ProcessText();
    copied = null;
    shared = null;
    actions = NoteTextActions(
      processTextService: platform,
      copyText: (text) async => copied = text,
      shareText: (text, origin) async => shared = text,
    );
  });

  tearDown(() => controller.dispose());

  Future<void> open(WidgetTester tester, {bool readOnly = false}) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => unawaited(
              showNoteTextToolsSheet(
                context,
                controller: controller,
                readOnly: readOnly,
                actions: actions,
              ),
            ),
            child: const Text('Open tools'),
          ),
        ),
      ),
      size: const Size(430, 1000),
    );
    await tester.tap(find.text('Open tools'));
    await tester.pumpAndSettle();
  }

  Future<void> process(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('note-text-action-translate')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(platform.lastText, 'Hello');
  }

  testWidgets('requires preview and explicit apply before changing the note', (
    tester,
  ) async {
    await open(tester);
    await process(tester);
    platform.result.complete('Привет');
    await tester.pumpAndSettle();
    expect(controller.document.toPlainText(), 'Hello world\n');
    expect(find.byKey(const ValueKey('note-text-result')), findsOneWidget);
    expect(platform.lastText, 'Hello');
    await tester.tap(find.byKey(const ValueKey('note-text-apply')));
    await tester.pumpAndSettle();
    expect(controller.document.toPlainText(), 'Привет world\n');
  });

  testWidgets('remote edits invalidate apply but result remains copyable', (
    tester,
  ) async {
    await open(tester);
    await process(tester);
    controller.document.compose(
      Delta()
        ..retain(11)
        ..insert('!'),
      ChangeSource.remote,
    );
    platform.result.complete('Привет');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('note-text-apply')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('note-text-copy')));
    await tester.pump();
    expect(copied, 'Привет');
    expect(controller.document.toPlainText(), 'Hello world!\n');
  });

  testWidgets('changing and restoring source never silently revives apply', (
    tester,
  ) async {
    await open(tester);
    await process(tester);
    controller.document.compose(
      Delta()
        ..retain(11)
        ..insert('!'),
      ChangeSource.remote,
    );
    controller.document.compose(
      Delta()
        ..retain(11)
        ..delete(1),
      ChangeSource.remote,
    );
    platform.result.complete('Привет');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('note-text-apply')), findsNothing);
    expect(controller.document.toPlainText(), 'Hello world\n');
  });

  testWidgets('readonly can process and share a preview but cannot apply', (
    tester,
  ) async {
    await open(tester, readOnly: true);
    await process(tester);
    platform.result.complete('Привет');
    await tester.pumpAndSettle();
    expect(platform.lastReadOnly, isTrue);
    expect(find.byKey(const ValueKey('note-text-apply')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('note-text-share')));
    await tester.pump();
    expect(shared, 'Привет');
    expect(controller.document.toPlainText(), 'Hello world\n');
  });

  testWidgets(
    'no installed actions still offers selected text copy and share',
    (tester) async {
      platform.actions = [];
      await open(tester);
      expect(find.textContaining('Подходящих приложений'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('note-text-copy')));
      await tester.pump();
      expect(copied, 'Hello');
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('note-text-share')));
      await tester.pump();
      expect(shared, 'Hello');
    },
  );

  testWidgets('cancellation does not replace or erase selected text', (
    tester,
  ) async {
    await open(tester);
    await process(tester);
    platform.result.complete(null);
    await tester.pumpAndSettle();
    expect(find.text('Приложение не вернуло изменённый текст'), findsOneWidget);
    expect(find.byKey(const ValueKey('note-text-apply')), findsNothing);
    expect(controller.document.toPlainText(), 'Hello world\n');
  });

  testWidgets(
    'platform failure leaves the note intact and fallback available',
    (tester) async {
      await open(tester);
      await process(tester);
      platform.result.completeError(PlatformException(code: 'unavailable'));
      await tester.pumpAndSettle();
      expect(find.text('Не удалось обработать текст'), findsOneWidget);
      expect(find.byKey(const ValueKey('note-text-copy')), findsOneWidget);
      expect(controller.document.toPlainText(), 'Hello world\n');
    },
  );

  testWidgets('late platform response after dismiss does not modify the note', (
    tester,
  ) async {
    await open(tester);
    await process(tester);
    final context = tester.element(find.byType(NoteTextToolsSheet));
    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    platform.result.complete('Привет');
    await tester.pump();
    expect(controller.document.toPlainText(), 'Hello world\n');
    expect(tester.takeException(), isNull);
  });
}

class _ProcessText implements ProcessTextService {
  List<ProcessTextAction> actions = const [
    ProcessTextAction('translate', 'Перевести'),
  ];
  Completer<String?>? _result;
  Completer<String?> get result => _result ??= Completer<String?>();
  String? lastText;
  bool? lastReadOnly;

  @override
  Future<List<ProcessTextAction>> queryTextActions() async => actions;

  @override
  Future<String?> processTextAction(String id, String text, bool readOnly) {
    lastText = text;
    lastReadOnly = readOnly;
    return result.future;
  }
}
