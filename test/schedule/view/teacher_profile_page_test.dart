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

        expect(find.byType(AppErrorState), findsOneWidget);
        expect(find.byType(AppEmptyState), findsNothing);
      },
    );

    testWidgets('retry reloads the profile', (tester) async {
      when(
        () => repository.getTeacherProfile(any()),
      ).thenThrow(Exception('network'));

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorState), findsOneWidget);

      when(
        () => repository.getTeacherProfile(any()),
      ).thenAnswer((_) async => TeacherProfile.empty);

      final error = tester.widget<AppErrorState>(
        find.byType(AppErrorState),
      );
      await tester.ensureVisible(find.text(error.primaryLabel).first);
      await tester.tap(find.text(error.primaryLabel).first);
      await tester.pumpAndSettle();

      verify(() => repository.getTeacherProfile(any())).called(greaterThan(1));
      expect(find.byType(AppErrorState), findsNothing);
      expect(find.byType(AppEmptyState), findsOneWidget);
    });
  });

  testWidgets('long subject names use the available width without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = MockCampusRepository();
    const subject =
        'Проектирование распределённых информационных систем и сервисов';
    when(
      () => repository.getTeacherProfile(any()),
    ).thenAnswer(
      (_) async => const TeacherProfile(
        teacherName: 'Иванов И.И.',
        subjects: [subject],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(2),
          ),
          child: RepositoryProvider<CampusRepository>.value(
            value: repository,
            child: const TeacherProfilePage(teacherName: 'Иванов И.И.'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(ListView),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    final tile = find.byKey(const ValueKey('teacher-subject-0'));
    expect(tile, findsOneWidget);
    expect(tester.getSize(tile).width, lessThanOrEqualTo(288));
    final label = tester.widget<Text>(find.text(subject));
    expect(label.maxLines, isNull);
    expect(label.overflow, isNull);
    expect(tester.takeException(), isNull);
  });
}
