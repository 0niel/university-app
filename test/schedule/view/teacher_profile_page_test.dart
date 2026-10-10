import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/teacher_profile_page.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart' show Teacher;

class MockCampusRepository extends Mock implements CampusRepository {}

class _Account extends MockCubit<AccountPersonaState>
    implements AccountPersonaCubit {}

void main() {
  for (final explicitReadOnly in [true, false]) {
    testWidgets(
      '${explicitReadOnly ? 'read-only' : 'own binding in student mode'} '
      'hides self-review and self-contact actions',
      (tester) async {
        final repository = MockCampusRepository();
        when(() => repository.getTeacherProfile(any())).thenAnswer(
          (_) async => TeacherProfile.empty,
        );
        final account = _Account();
        when(() => account.state).thenReturn(
          AccountPersonaState(
            persona: explicitReadOnly
                ? AccountPersona.empty
                : const AccountPersona(
                    teacherId: 'teacher-id',
                    teacherName: 'Иванов Иван Иванович',
                    teacherAvailable: true,
                  ),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RepositoryProvider<CampusRepository>.value(
              value: repository,
              child: BlocProvider<AccountPersonaCubit>.value(
                value: account,
                child: TeacherProfilePage(
                  teacherName: 'Иванов Иван Иванович',
                  teacher: const Teacher(
                    uid: 'teacher-id',
                    name: 'Иванов Иван Иванович',
                    email: 'teacher@example.com',
                  ),
                  readOnly: explicitReadOnly,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView), const Offset(0, -600));
        await tester.pumpAndSettle();
        expect(find.text('О вас ещё нет отзывов'), findsOneWidget);
        expect(find.text('Оставить отзыв'), findsNothing);
        expect(find.text('Написать'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('teacher photo opens the shared viewer', (tester) async {
    final repository = MockCampusRepository();
    when(
      () => repository.getTeacherProfile(any()),
    ).thenAnswer((_) async => TeacherProfile.empty);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<CampusRepository>.value(
          value: repository,
          child: const TeacherProfilePage(
            teacherName: 'Teacher',
            teacher: Teacher(
              name: 'Teacher',
              photoUrl: 'https://example.com/teacher.png',
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(AppAvatar).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items.single.url, 'https://example.com/teacher.png');
    expect(viewer.items.single.heroTag, isNotNull);
    expect(tester.takeException(), isNull);
  });

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
