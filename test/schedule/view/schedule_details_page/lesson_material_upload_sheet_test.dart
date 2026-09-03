import 'dart:async';
import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../helpers/pump_app.dart';
import 'mock_schedule_repository.dart';

class _FakeMaterialRequest extends Fake
    implements CreateLessonMaterialRequest {}

class _StreamFile extends PlatformFile {
  _StreamFile({
    super.name = 'lecture.notes.pdf',
    super.size = 1,
    this.reader,
  });

  final Stream<Uint8List> Function()? reader;
  int reads = 0;

  @override
  Stream<Uint8List> readAsByteStream() {
    reads++;
    return reader?.call() ?? Stream.value(Uint8List.fromList([1]));
  }

  @override
  Future<Uint8List> readAsBytes() =>
      throw StateError('Native file bytes were not preloaded');
}

const _kTransparentPng =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY'
    '42YAAAAASUVORK5CYII=';

void main() {
  final day = DateTime(2026, 9, 2);
  final lesson = LessonSchedulePart(
    subject: 'Логика',
    lessonType: LessonType.lecture,
    teachers: const [],
    classrooms: const [],
    lessonBells: LessonBells(
      number: 1,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    dates: [day],
  );

  setUpAll(() => registerFallbackValue(_FakeMaterialRequest()));

  Future<void> pumpSheet(
    WidgetTester tester, {
    required Future<PlatformFile?> Function() pickFile,
    Future<XFile?> Function(ImageSource source)? pickImage,
    MockScheduleRepository? repository,
  }) async {
    final scheduleRepository = repository ?? MockScheduleRepository();
    when(() => scheduleRepository.hasAuthenticatedUser).thenReturn(true);
    await tester.pumpApp(
      RepositoryProvider<ScheduleRepository>.value(
        value: scheduleRepository,
        child: Scaffold(
          body: SingleChildScrollView(
            child: LessonMaterialUploadSheet(
              lesson: lesson,
              selectedDate: day,
              lessonNumber: 1,
              filePicker: pickFile,
              imagePicker: pickImage,
            ),
          ),
        ),
      ),
      size: const Size(390, 844),
    );
  }

  Future<void> pick(WidgetTester tester) async {
    await tester.tap(find.text('Выбрать файл или фото'));
    await tester.pump();
  }

  Future<void> upload(WidgetTester tester) async {
    final button = find.widgetWithText(AppButton, 'Загрузить материал');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  testWidgets('picker failure shows a kit error without escaping', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      pickFile: () async => throw PlatformException(code: 'permission_denied'),
    );
    await pick(tester);
    expect(find.byType(AppBanner), findsOneWidget);
    expect(
      find.text('Не удалось прочитать файл. Выберите файл размером до 50 МБ.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('camera permission failure shows a kit error', (tester) async {
    await pumpSheet(
      tester,
      pickFile: () async => null,
      pickImage: (_) async =>
          throw PlatformException(code: 'camera_access_denied'),
    );
    await tester.tap(find.text('Камера'));
    await tester.pump();
    expect(find.byType(AppBanner), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('streamed native file supplies the file and full title', (
    tester,
  ) async {
    final file = _StreamFile();
    await pumpSheet(tester, pickFile: () async => file);
    await pick(tester);
    expect(file.reads, 1);
    expect(find.text('lecture.notes.pdf'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'lecture.notes',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed replacement read preserves the selected file and title', (
    tester,
  ) async {
    var selection = 0;
    await pumpSheet(
      tester,
      pickFile: () async => selection++ == 0
          ? _StreamFile()
          : _StreamFile(
              name: 'unavailable.pdf',
              reader: () => Stream.error(Exception('file became unavailable')),
            ),
    );
    await pick(tester);
    await tester.enterText(find.byType(TextField), 'Мои заметки');
    await tester.tap(find.text('Файлы'));
    await tester.pump();
    expect(find.text('lecture.notes.pdf'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Мои заметки',
    );
    expect(find.byType(AppBanner), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('oversized file is rejected before streaming', (tester) async {
    final file = _StreamFile(size: 51 * 1024 * 1024);
    await pumpSheet(tester, pickFile: () async => file);
    await pick(tester);
    expect(file.reads, 0);
    expect(find.text('Файл больше 50 МБ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposed picker result is ignored before reading', (
    tester,
  ) async {
    final pending = Completer<PlatformFile?>();
    final file = _StreamFile();
    await pumpSheet(tester, pickFile: () => pending.future);
    await pick(tester);
    expect(find.byType(AppSkeletonMedia), findsOneWidget);
    expect(find.text('Выбрать файл или фото'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    pending.complete(file);
    await tester.pump();
    expect(file.reads, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'upload failure keeps input and reports upload rather than auth',
    (
      tester,
    ) async {
      final repository = MockScheduleRepository();
      final pending = Completer<LessonMaterial>();
      when(() => repository.uploadLessonMaterial(any())).thenAnswer(
        (_) => pending.future,
      );
      await pumpSheet(
        tester,
        repository: repository,
        pickFile: () async => _StreamFile(),
      );
      await pick(tester);
      await upload(tester);
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      pending.completeError(UploadLessonMaterialFailure(Exception('offline')));
      await tester.pump();
      expect(
        find.text('Не удалось загрузить материал. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      expect(find.text('Войдите и попробуйте загрузить ещё раз'), findsNothing);
      expect(find.text('lecture.notes.pdf'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'lecture.notes',
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
      verify(() => repository.uploadLessonMaterial(any())).called(1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('unauthenticated user receives the real sign-in precondition', (
    tester,
  ) async {
    final repository = MockScheduleRepository();
    await pumpSheet(
      tester,
      repository: repository,
      pickFile: () async => _StreamFile(),
    );
    when(() => repository.hasAuthenticatedUser).thenReturn(false);
    await pick(tester);
    await upload(tester);
    expect(find.text('Войдите и попробуйте загрузить ещё раз'), findsOneWidget);
    verifyNever(() => repository.uploadLessonMaterial(any()));
    expect(tester.takeException(), isNull);
  });

  testWidgets('picked image renders a thumbnail preview with a remove button', (
    tester,
  ) async {
    await pumpSheet(
      tester,
      pickFile: () async => null,
      pickImage: (_) async => XFile.fromData(
        base64Decode(_kTransparentPng),
        name: 'board.jpg',
        mimeType: 'image/jpeg',
      ),
    );
    await tester.tap(find.text('Камера'));
    await tester.pump();

    expect(find.text('Выбрать файл или фото'), findsNothing);
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(AppIconButton));
    await tester.pump();
    expect(find.text('Выбрать файл или фото'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('non-image picks show a file badge instead of a thumbnail', (
    tester,
  ) async {
    await pumpSheet(tester, pickFile: () async => _StreamFile());
    await pick(tester);

    expect(find.text('lecture.notes.pdf'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text('PDF'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('source row uses kit tonal buttons and the reward is a banner', (
    tester,
  ) async {
    await pumpSheet(tester, pickFile: () async => null);

    for (final label in ['Камера', 'Галерея', 'Файлы']) {
      expect(find.widgetWithText(AppButton, label), findsOneWidget);
    }
    expect(find.byType(AppContextBanner), findsOneWidget);
    expect(find.text('+30 сюрикенов'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
