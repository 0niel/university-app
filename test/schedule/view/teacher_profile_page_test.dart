import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';

class MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  group('TeacherProfilePage reviews skeleton', () {
    late CampusRepository repository;

    setUp(() {
      repository = MockCampusRepository();
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<CampusRepository>.value(
          value: repository,
          child: const TeacherProfilePage(teacherName: 'Иванов И.И.'),
        ),
      );
    }

    testWidgets('shows a shimmering skeleton and no spinner on cold load', (
      tester,
    ) async {
      // Never completes: the profile load stays in flight so the page keeps
      // its cold-load `_loading == true` state and renders the skeleton.
      final completer = Completer<TeacherProfile>();
      when(
        () => repository.getTeacherProfile(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      // Run the post-frame callback that kicks off the load, without settling
      // (the future never resolves, so pumpAndSettle would hang).
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('TeacherProfilePage load failure', () {
    late CampusRepository repository;

    setUp(() {
      repository = MockCampusRepository();
    });

    Widget buildSubject() {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<CampusRepository>.value(
          value: repository,
          child: const TeacherProfilePage(teacherName: 'Иванов И.И.'),
        ),
      );
    }

    testWidgets(
      'shows an error state with retry instead of a blank "0 reviews" '
      'profile',
      (tester) async {
        when(
          () => repository.getTeacherProfile(any()),
        ).thenThrow(Exception('network'));

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.byType(NinjaErrorState), findsOneWidget);
        expect(find.byType(NinjaEmptyState), findsNothing);
      },
    );

    testWidgets('retry reloads the profile', (tester) async {
      when(
        () => repository.getTeacherProfile(any()),
      ).thenThrow(Exception('network'));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(NinjaErrorState), findsOneWidget);

      when(
        () => repository.getTeacherProfile(any()),
      ).thenAnswer((_) async => TeacherProfile.empty);

      await tester.tap(find.byType(NinjaActionButton).first);
      await tester.pumpAndSettle();

      verify(() => repository.getTeacherProfile(any())).called(greaterThan(1));
      expect(find.byType(NinjaErrorState), findsNothing);
      expect(find.byType(NinjaEmptyState), findsOneWidget);
    });
  });
}
