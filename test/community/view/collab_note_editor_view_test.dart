import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  group('CollabNoteEditorView', () {
    late CampusRepository repository;
    late NoteEditorCubit cubit;

    setUp(() {
      repository = MockCampusRepository();
      cubit = NoteEditorCubit(
        repository: repository,
        note: const CollabNote(
          id: 'note-1',
          title: 'Алгоритмы',
          content: 'Исходный текст',
          isMine: true,
          isPersonal: true,
        ),
        editorName: 'Alex',
        saveDebounce: const Duration(days: 1),
      );
    });

    tearDown(() async => cubit.close());

    Widget buildSubject({double textScale = 1}) => MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: NinjaToastHost(
        child: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: SafeArea(child: CollabNoteEditorView())),
        ),
      ),
    );

    GroupNoteSaveResult saved() => GroupNoteSaveResult(
      revision: 1,
      updatedAt: DateTime(2026, 7, 11, 12),
    );

    testWidgets('updates the header immediately and saves on back', (
      tester,
    ) async {
      when(
        () => repository.saveGroupNote(
          id: 'note-1',
          title: 'Новый заголовок',
          content: 'Исходный текст',
          expectedRevision: 0,
        ),
      ).thenAnswer((_) async => saved());
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.byType(TextField).first,
        'Новый заголовок',
      );
      await tester.pump();
      expect(find.text('Конспект · Новый заголовок'), findsOneWidget);

      await tester.tap(find.byTooltip('Назад'));
      await tester.pump();
      verify(
        () => repository.saveGroupNote(
          id: 'note-1',
          title: 'Новый заголовок',
          content: 'Исходный текст',
          expectedRevision: 0,
        ),
      ).called(1);
    });

    testWidgets('keeps local text visible after a save conflict', (
      tester,
    ) async {
      when(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenThrow(const CollabNoteConflictException());
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.byType(TextField).last,
        'Важный локальный текст',
      );
      await tester.tap(find.byTooltip('Сохранить'));
      await tester.pump();

      expect(find.text('Важный локальный текст'), findsOneWidget);
      expect(
        find.text(
          'Конспект изменили в другом редакторе. Ваш текст остался здесь.',
        ),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 4));

      await tester.tap(find.byTooltip('Назад'));
      await tester.pump();
      expect(find.text('Выйти без сохранения?'), findsOneWidget);
      await tester.tap(find.text('Продолжить редактирование'));
      await tester.pump();
      expect(find.text('Важный локальный текст'), findsOneWidget);
    });

    testWidgets('fits 320 logical pixels at 200 percent text scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(640, 1400);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildSubject(textScale: 2));

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byTooltip('Сохранить')).height,
        NinjaMetrics.minTouchTarget,
      );
      expect(
        tester.getSize(find.byTooltip('Удалить')).height,
        NinjaMetrics.minTouchTarget,
      );
    });
  });
}
