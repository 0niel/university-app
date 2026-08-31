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

void main() {
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
  });

  testWidgets('enables publishing after a file supplies the title', (
    tester,
  ) async {
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

    final publishButton = tester.widget<NinjaButton>(
      find.widgetWithText(NinjaButton, 'Опубликовать'),
    );
    expect(publishButton.onPressed, isNotNull);
  });
}
