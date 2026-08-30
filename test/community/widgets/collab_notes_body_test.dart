import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_body.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/collab_notes_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  group('CollabNotesBody', () {
    late CampusRepository repository;

    setUp(() => repository = MockCampusRepository());

    Widget buildSubject(CollabNotesCubit cubit) => MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: Scaffold(
        body: BlocProvider.value(value: cubit, child: const CollabNotesBody()),
      ),
    );

    testWidgets('shows a skeleton without a spinner during cold load', (
      tester,
    ) async {
      final response = Completer<List<CollabNote>>();
      when(() => repository.getGroupNotes()).thenAnswer((_) => response.future);
      final cubit = CollabNotesCubit(repository: repository);
      unawaited(cubit.load());

      await tester.pumpWidget(buildSubject(cubit));

      expect(find.byType(CollabNotesSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      response.complete(const []);
      await tester.pumpAndSettle();
      await cubit.close();
    });

    testWidgets('shows a retryable failure instead of an empty state', (
      tester,
    ) async {
      when(() => repository.getGroupNotes()).thenThrow(Exception('offline'));
      final cubit = CollabNotesCubit(repository: repository);
      await cubit.load();
      when(() => repository.getGroupNotes()).thenAnswer((_) async => const []);

      await tester.pumpWidget(buildSubject(cubit));

      expect(find.text('Не удалось загрузить конспекты'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      await tester.pump();
      verify(() => repository.getGroupNotes()).called(2);
      await cubit.close();
    });

    testWidgets('exposes note cards as semantic buttons', (tester) async {
      const note = CollabNote(id: 'note-1', title: 'Теория графов');
      when(() => repository.getGroupNotes()).thenAnswer((_) async => [note]);
      final cubit = CollabNotesCubit(repository: repository);
      await cubit.load();

      await tester.pumpWidget(buildSubject(cubit));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.button == true &&
              widget.properties.label == 'Теория графов',
        ),
        findsOneWidget,
      );
      await cubit.close();
    });
  });
}
