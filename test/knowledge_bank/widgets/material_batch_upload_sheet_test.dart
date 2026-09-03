import 'dart:async';
import 'dart:typed_data';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_batch_upload_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _MockCampusRepository extends Mock implements CampusRepository {}

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Future<void> _selectSubject(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Выбрать предметы'));
  await tester.tap(find.text('Выбрать предметы'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Математика'));
  await tester.tap(find.widgetWithText(AppButton, 'Готово'));
  await tester.pumpAndSettle();
}

void _stubUpload(
  _MockCampusRepository repository,
  Future<String> Function() upload,
) {
  when(
    () => repository.createPublicMaterial(
      title: any(named: 'title'),
      subjectName: any(named: 'subjectName'),
      subjectNames: any(named: 'subjectNames'),
      materialType: any(named: 'materialType'),
      isAnonymous: any(named: 'isAnonymous'),
      fileName: any(named: 'fileName'),
      fileBytes: any(named: 'fileBytes'),
      mimeType: any(named: 'mimeType'),
      previewBytes: any(named: 'previewBytes'),
      previewMimeType: any(named: 'previewMimeType'),
      width: any(named: 'width'),
      height: any(named: 'height'),
      batchId: any(named: 'batchId'),
    ),
  ).thenAnswer((_) => upload());
}

void main() {
  late _MockCampusRepository repository;

  setUp(() {
    repository = _MockCampusRepository();
    when(
      () => repository.searchMaterialSubjects(any()),
    ).thenAnswer((_) async => ['Математика']);
  });

  testWidgets('stops the batch after the sheet is disposed', (tester) async {
    final upload = Completer<String>();
    var calls = 0;
    _stubUpload(repository, () {
      calls++;
      return upload.future;
    });
    await tester.pumpWidget(
      _wrap(
        MaterialBatchUploadSheet(
          repository: repository,
          filesPickerBuilder: () async => FilePickerResult([
            for (final name in ['a.pdf', 'b.pdf'])
              PlatformFile(name: name, size: 1, bytes: Uint8List(1)),
          ]),
        ),
      ),
    );
    await tester.tap(find.text('Файлы'));
    await tester.pumpAndSettle();
    await _selectSubject(tester);
    await tester.ensureVisible(find.text('Опубликовать'));
    await tester.tap(find.text('Опубликовать'));
    await tester.pump();
    expect(calls, 1);
    await tester.pumpWidget(const SizedBox());
    upload.complete('material-id');
    await tester.pump();
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('retry locks the batch and prevents duplicate uploads', (
    tester,
  ) async {
    final upload = Completer<String>();
    var calls = 0;
    _stubUpload(repository, () {
      calls++;
      if (calls == 1) return Future.error(StateError('Unavailable'));
      return upload.future;
    });
    await tester.pumpWidget(
      _wrap(
        MaterialBatchUploadSheet(
          repository: repository,
          filesPickerBuilder: () async => FilePickerResult([
            PlatformFile(name: 'a.pdf', size: 1, bytes: Uint8List(1)),
          ]),
        ),
      ),
    );
    await tester.tap(find.text('Файлы'));
    await tester.pumpAndSettle();
    await _selectSubject(tester);
    await tester.ensureVisible(find.text('Опубликовать'));
    await tester.tap(find.text('Опубликовать'));
    await tester.pumpAndSettle();
    final retry = find.byWidgetPredicate(
      (widget) => widget is AppIconButton && widget.tooltip == 'Повторить',
    );
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.pump();
    expect(calls, 2);
    expect(
      tester.widget<AppInputField>(find.byType(AppInputField)).enabled,
      false,
    );
    final publish = tester.widget<AppButton>(
      find.widgetWithText(AppButton, 'Опубликовать'),
    );
    expect(publish.onPressed, isNull);
    await tester.pumpWidget(const SizedBox());
    upload.complete('material-id');
    await tester.pump();
    expect(calls, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('picked files become editable entries with a status line', (
    tester,
  ) async {
    final bytes = Uint8List.fromList([1, 2, 3]);
    await tester.pumpWidget(
      _wrap(
        MaterialBatchUploadSheet(
          repository: repository,
          filesPickerBuilder: () async => FilePickerResult([
            PlatformFile(name: 'a.pdf', size: bytes.length, bytes: bytes),
            PlatformFile(name: 'b.pdf', size: bytes.length, bytes: bytes),
          ]),
        ),
      ),
    );

    await tester.tap(find.text('Файлы'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(AppInputField), findsNWidgets(2));
    expect(find.text('Загружено 0 из 2'), findsOneWidget);
  });

  testWidgets('uploads every entry under the same batch id', (tester) async {
    final bytesA = Uint8List.fromList([1, 2, 3]);
    final bytesB = Uint8List.fromList([4, 5, 6]);
    final captured = <String?>[];
    when(
      () => repository.createPublicMaterial(
        title: any(named: 'title'),
        subjectName: any(named: 'subjectName'),
        subjectNames: any(named: 'subjectNames'),
        materialType: any(named: 'materialType'),
        isAnonymous: any(named: 'isAnonymous'),
        fileName: any(named: 'fileName'),
        fileBytes: any(named: 'fileBytes'),
        mimeType: any(named: 'mimeType'),
        previewBytes: any(named: 'previewBytes'),
        previewMimeType: any(named: 'previewMimeType'),
        width: any(named: 'width'),
        height: any(named: 'height'),
        batchId: any(named: 'batchId'),
      ),
    ).thenAnswer((invocation) async {
      captured.add(invocation.namedArguments[#batchId] as String?);
      return 'material-id';
    });

    await tester.pumpWidget(
      _wrap(
        MaterialBatchUploadSheet(
          repository: repository,
          filesPickerBuilder: () async => FilePickerResult([
            PlatformFile(name: 'a.pdf', size: bytesA.length, bytes: bytesA),
            PlatformFile(name: 'b.pdf', size: bytesB.length, bytes: bytesB),
          ]),
        ),
      ),
    );

    await tester.tap(find.text('Файлы'));
    await tester.pump();
    await tester.pump();
    await _selectSubject(tester);

    await tester.ensureVisible(find.text('Опубликовать'));
    await tester.tap(find.text('Опубликовать'));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(captured, hasLength(2));
    expect(captured[0], isNotNull);
    expect(captured[0], captured[1]);
  });
}
