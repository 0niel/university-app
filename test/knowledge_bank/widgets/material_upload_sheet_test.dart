import 'dart:async';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_upload_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _MockCampusRepository extends Mock implements CampusRepository {}

class _NativeMaterialFile extends PlatformFile {
  _NativeMaterialFile() : super(name: 'native.pdf', size: 1);

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(Uint8List.fromList([1]));

  @override
  Future<Uint8List> readAsBytes() =>
      throw StateError('Native file bytes were not preloaded');
}

void main() {
  testWidgets('default reader streams native files without preloaded bytes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MaterialUploadSheet(
              repository: _MockCampusRepository(),
              filePickerBuilder: () async => _NativeMaterialFile(),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Перетащи файл или выбери'));
    await tester.pump();
    expect(find.text('native.pdf'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'native',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('price step buttons expose localized button semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MaterialUploadSheet(repository: _MockCampusRepository()),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Уменьшить цену'), findsOneWidget);
    expect(find.bySemanticsLabel('Увеличить цену'), findsOneWidget);
  });

  testWidgets('does not update state after disposal during file picking', (
    tester,
  ) async {
    final picker = Completer<PlatformFile?>();
    var readerCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MaterialUploadSheet(
              repository: _MockCampusRepository(),
              filePickerBuilder: () => picker.future,
              fileReaderBuilder: (file) async {
                readerCalled = true;
                return Uint8List.fromList(const [1]);
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Перетащи файл или выбери'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());

    picker.complete(PlatformFile(name: 'note.pdf', size: 1));
    await tester.pump();

    expect(readerCalled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects oversized files before reading them', (tester) async {
    var readerCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MaterialUploadSheet(
              repository: _MockCampusRepository(),
              filePickerBuilder: () async => PlatformFile(
                name: 'huge.pdf',
                size: 51 * 1024 * 1024,
              ),
              fileReaderBuilder: (file) async {
                readerCalled = true;
                return Uint8List(0);
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Перетащи файл или выбери'));
    await tester.pump();

    expect(readerCalled, isFalse);
    expect(
      find.text('Не удалось прочитать файл. Выберите файл размером до 50 МБ.'),
      findsOneWidget,
    );
  });

  testWidgets('requires a subject after a file supplies the title', (
    tester,
  ) async {
    final repository = _MockCampusRepository();
    when(
      () => repository.searchMaterialSubjects(any()),
    ).thenAnswer((_) async => ['Математика']);
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MaterialUploadSheet(
              repository: repository,
              filePickerBuilder: () async => PlatformFile(
                name: 'lecture.pdf',
                size: 1,
              ),
              fileReaderBuilder: (file) async => Uint8List.fromList(const [1]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Перетащи файл или выбери'));
    await tester.pump();

    final publishButton = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Опубликовать'),
    );
    expect(publishButton.onPressed, isNull);
    await _selectSubject(tester);
    expect(
      tester
          .widget<AppButton>(find.widgetWithText(AppButton, 'Опубликовать'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets(
    'upload failure keeps the file and title and restores publishing',
    (tester) async {
      final repository = _MockCampusRepository();
      final bytes = Uint8List.fromList([1]);
      final result = Completer<void>();
      when(
        () => repository.searchMaterialSubjects(any()),
      ).thenAnswer((_) async => ['Математика']);
      when(
        () => repository.createPublicMaterial(
          title: 'lecture',
          subjectName: 'Математика',
          subjectNames: ['Математика'],
          fileName: 'lecture.pdf',
          fileBytes: bytes,
          mimeType: 'application/pdf',
        ),
      ).thenAnswer((_) => result.future);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: MaterialUploadSheet(
                repository: repository,
                filePickerBuilder: () async =>
                    PlatformFile(name: 'lecture.pdf', size: 1),
                fileReaderBuilder: (_) async => bytes,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Перетащи файл или выбери'));
      await tester.pump();
      await _selectSubject(tester);
      await tester.ensureVisible(find.text('Опубликовать'));
      await tester.tap(find.text('Опубликовать'));
      await tester.pump();
      expect(
        tester
            .widget<AppButton>(find.widgetWithText(AppButton, 'Заливаем…'))
            .loading,
        isTrue,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField).first).enabled,
        isFalse,
      );
      result.completeError(Exception('offline'));
      await tester.pump();
      expect(
        find.text('Не удалось загрузить материал. Попробуйте ещё раз.'),
        findsOneWidget,
      );
      expect(find.text('lecture.pdf'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        'lecture',
      );
      expect(
        tester
            .widget<AppButton>(find.widgetWithText(AppButton, 'Опубликовать'))
            .onPressed,
        isNotNull,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _selectSubject(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Выбрать предметы'));
  await tester.tap(find.text('Выбрать предметы'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Математика'));
  await tester.tap(find.widgetWithText(AppButton, 'Готово'));
  await tester.pumpAndSettle();
}
