import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets/lesson_note_sheet.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'schedule_test_data.dart';

class _Comments extends MockCubit<LessonCommentsState>
    implements LessonCommentsCubit {}

class _Campus extends Mock implements CampusRepository {}

class _Schedule extends Mock implements ScheduleRepository {}

void main() {
  final day = DateTime(2026, 9, 2);
  final lesson = scheduleTestLesson();
  late _Comments comments;
  late _Campus campus;

  setUpAll(() {
    registerFallbackValue(
      LessonComment(
        subjectName: lesson.subject,
        lessonDate: day,
        lessonBells: lesson.lessonBells,
        text: '',
      ),
    );
  });

  setUp(() {
    comments = _Comments();
    campus = _Campus();
    when(() => comments.isClosed).thenReturn(false);
    when(() => comments.state).thenReturn(
      LessonCommentsState(
        comments: [
          LessonComment(
            subjectName: lesson.subject,
            lessonDate: day.subtract(const Duration(days: 7)),
            lessonBells: lesson.lessonBells,
            text: 'Previous week',
          ),
          LessonComment(
            subjectName: lesson.subject,
            lessonDate: day.add(const Duration(hours: 10)),
            lessonBells: lesson.lessonBells,
            text: 'Current draft',
          ),
        ],
      ),
    );
  });

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CampusRepository>.value(value: campus),
          RepositoryProvider<ScheduleRepository>.value(value: _Schedule()),
        ],
        child: BlocProvider<LessonCommentsCubit>.value(
          value: comments,
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    showLessonNoteSheet(context, lesson: lesson, day: day),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  void setExistingText(String text) {
    when(() => comments.state).thenReturn(
      LessonCommentsState(
        comments: [
          LessonComment(
            subjectName: lesson.subject,
            lessonDate: day,
            lessonBells: lesson.lessonBells,
            text: text,
          ),
        ],
      ),
    );
  }

  testWidgets('preserves notes above 500 characters and the 1000 limit', (
    tester,
  ) async {
    final existing = ''.padRight(800, 'x');
    setExistingText(existing);
    await open(tester);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.maxLength, 1000);
    expect(field.controller!.text, existing);
    final updated = '${''.padRight(999, 'x')}👩‍🎓';
    await tester.enterText(find.byType(TextField), updated);
    expect(field.controller!.text, updated);
    expect(field.controller!.text.characters.length, 1000);
    final saved = verify(
      () => comments.setLessonComment(captureAny()),
    ).captured.cast<LessonComment>().last;
    expect(saved.text, updated);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editing a legacy oversized note never truncates its content', (
    tester,
  ) async {
    final existing = ''.padRight(1025, 'x');
    setExistingText(existing);
    await open(tester);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.maxLength, existing.length);
    final updated = 'y${existing.substring(1)}';
    await tester.enterText(find.byType(TextField), updated);
    expect(field.controller!.text, updated);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checklist replaces the selection and autosaves its content', (
    tester,
  ) async {
    await open(tester);
    final controller =
        tester.widget<TextField>(find.byType(TextField)).controller!
          ..value = const TextEditingValue(
            text: 'Before After',
            selection: TextSelection(baseOffset: 12, extentOffset: 7),
          );
    await tester.pump();
    final checklist = find.byKey(const ValueKey('lesson-note-checklist'));
    await tester.ensureVisible(checklist);
    await tester.tap(checklist);
    await tester.pump();
    expect(controller.text, 'Before \n☐ ');
    expect(controller.selection, const TextSelection.collapsed(offset: 10));
    final saved = verify(
      () => comments.setLessonComment(captureAny()),
    ).captured.cast<LessonComment>().last;
    expect(saved.text, 'Before \n☐');
    expect(tester.takeException(), isNull);
  });

  testWidgets('note tools enforce the same grapheme limit as text input', (
    tester,
  ) async {
    await open(tester);
    final controller = tester
        .widget<TextField>(find.byType(TextField))
        .controller!;
    final text = '${''.padRight(996, 'x')}👩‍🎓';
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    await tester.pump();
    final checklist = find.byKey(const ValueKey('lesson-note-checklist'));
    await tester.ensureVisible(checklist);
    await tester.tap(checklist);
    await tester.pump();
    expect(controller.text, '$text\n☐ ');
    expect(controller.text.characters.length, 1000);
    final tag = find.byKey(const ValueKey('lesson-note-tag'));
    await tester.ensureVisible(tag);
    await tester.tap(tag);
    await tester.pump();
    expect(controller.text, '$text\n☐ ');
    expect(tester.takeException(), isNull);
  });

  testWidgets('hashtags keep Kit accent without losing IME composing text', (
    tester,
  ) async {
    await open(tester);
    final field = find.byType(TextField);
    final controller = tester.widget<TextField>(field).controller!;
    final context = tester.element(field);
    controller.text = 'Тема #матан';
    final span = controller.buildTextSpan(
      context: context,
      withComposing: true,
      style: AppText.body,
    );
    expect(span.toPlainText(), controller.text);
    final tag = span.children!.whereType<TextSpan>().singleWhere(
      (span) => span.text == '#матан',
    );
    expect(tag.style!.color, context.colors.accent);
    controller.value = const TextEditingValue(
      text: '#topic',
      selection: TextSelection.collapsed(offset: 6),
      composing: TextRange(start: 0, end: 6),
    );
    final composing = controller.buildTextSpan(
      context: context,
      withComposing: true,
      style: AppText.body,
    );
    expect(composing.toPlainText(), '#topic');
    expect(
      composing.children!.whereType<TextSpan>().any(
        (span) => span.style?.decoration == TextDecoration.underline,
      ),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens only the selected occurrence and autosaves local edits', (
    tester,
  ) async {
    await open(tester);
    expect(find.text('Current draft'), findsOneWidget);
    expect(find.text('Previous week'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Edited draft');
    final saved = verify(
      () => comments.setLessonComment(captureAny()),
    ).captured.cast<LessonComment>().last;
    expect(saved.lessonDate, day.add(const Duration(hours: 10)));
    expect(saved.text, 'Edited draft');
    expect(saved.isSharedWithGroup, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed publishing keeps a local draft without a shared badge', (
    tester,
  ) async {
    when(() => campus.createGroupNote(any())).thenThrow(Exception('offline'));
    await open(tester);
    await tester.enterText(find.byType(TextField), 'Keep this note');
    await tester.tap(find.byType(AppSwitch));
    await tester.pump();
    final context = tester.element(find.byType(TextField));
    final save = find.text(context.l10n.save);
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    final saved = verify(
      () => comments.setLessonComment(captureAny()),
    ).captured.cast<LessonComment>().last;
    expect(saved.text, 'Keep this note');
    expect(saved.isSharedWithGroup, isFalse);
    expect(find.text(context.l10n.scheduleActionFailed), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failed save retries the same created group note', (
    tester,
  ) async {
    var saves = 0;
    when(
      () => campus.createGroupNote(any()),
    ).thenAnswer((_) async => 'created');
    when(
      () => campus.saveGroupNote(
        id: 'created',
        title: lesson.subject,
        content: 'Current draft',
        expectedRevision: 0,
      ),
    ).thenAnswer((_) async {
      if (++saves == 1) throw Exception('offline');
      return GroupNoteSaveResult(revision: 1, updatedAt: day);
    });
    await open(tester);
    await tester.tap(find.byType(AppSwitch));
    await tester.pump();
    final save = find.text(tester.element(find.byType(TextField)).l10n.save);
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    await tester.ensureVisible(save);
    await tester.tap(save);
    await tester.pumpAndSettle();
    verify(() => campus.createGroupNote(lesson.subject)).called(1);
    expect(saves, 2);
    final saved = verify(
      () => comments.setLessonComment(captureAny()),
    ).captured.cast<LessonComment>().last;
    expect(saved.isSharedWithGroup, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
