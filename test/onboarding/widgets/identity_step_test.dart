import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/onboarding/widgets/identity_step.dart';

import '../../helpers/pump_app.dart';

class _Repository extends Mock implements GamificationRepository {}

const _config = UniversityConfig(
  organizationId: 'test',
  appName: 'Test',
  universityName: 'Test University',
  universityShortName: 'TU',
  websiteUrl: 'https://example.com',
  supportEmail: 'support@example.com',
  deepLinkScheme: 'test',
  webAppHost: 'example.com',
  webAppPathPrefix: '/',
);

void main() {
  late _Repository repository;
  setUp(() => repository = _Repository());

  Future<void> pump(
    WidgetTester tester, {
    String? initialName,
    String? initialHandle,
    void Function(String, String)? onNext,
    double scale = 1,
  }) async {
    await tester.pumpApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GamificationRepository>.value(value: repository),
          RepositoryProvider<UniversityConfig>.value(value: _config),
        ],
        child: Scaffold(
          body: OnboardingIdentityStep(
            step: 3,
            totalSteps: 4,
            initialName: initialName,
            initialHandle: initialHandle,
            onBack: () {},
            onNext: onNext ?? (_, _) {},
          ),
        ),
      ),
      size: const Size(390, 844),
      textScaler: TextScaler.linear(scale),
    );
    await tester.pump();
  }

  Finder input(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(EditableText),
  );

  testWidgets('failed handle check is visible and can be retried', (
    tester,
  ) async {
    var requests = 0;
    when(() => repository.isHandleAvailable('student_1')).thenAnswer((_) async {
      requests++;
      if (requests == 1) throw Exception('unavailable');
      return true;
    });
    await pump(tester, initialName: 'Иван');
    await tester.enterText(input('onboarding_identityHandle'), 'student_1');
    await tester.pump(const Duration(milliseconds: 401));
    await tester.pump();
    expect(
      find.text('Не удалось проверить никнейм. Попробуйте ещё раз'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<AppButton>(
            find.byKey(const Key('onboarding_identityContinue')),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Повторить'));
    await tester.pump(const Duration(milliseconds: 401));
    await tester.pump();
    expect(find.text('Ник свободен'), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(
            find.byKey(const Key('onboarding_identityContinue')),
          )
          .onPressed,
      isNotNull,
    );
    expect(requests, 2);
  });

  testWidgets(
    'pending save locks inputs and completes with the saved identity snapshot',
    (tester) async {
      final pending = Completer<ProfileOverview>();
      addTearDown(() {
        if (!pending.isCompleted) pending.complete(ProfileOverview.empty);
      });
      when(
        () => repository.setUserIdentity(
          organizationId: any(named: 'organizationId'),
          fullName: any(named: 'fullName'),
          handle: any(named: 'handle'),
        ),
      ).thenAnswer((_) => pending.future);
      (String, String)? result;
      await pump(
        tester,
        initialName: 'Иван',
        initialHandle: 'student_1',
        onNext: (name, handle) => result = (name, handle),
      );
      await tester.tap(find.byKey(const Key('onboarding_identityContinue')));
      await tester.pump();
      for (final field in tester.widgetList<AppInputField>(
        find.byType(AppInputField),
      )) {
        expect(field.enabled, isFalse);
        field.controller!.text = 'changed';
      }
      pending.complete(ProfileOverview.empty);
      await tester.pump();
      expect(result, ('Иван', 'student_1'));
      verify(
        () => repository.setUserIdentity(
          organizationId: 'test',
          fullName: 'Иван',
          handle: 'student_1',
        ),
      ).called(1);
    },
  );

  testWidgets('a stale availability result cannot enable a changed handle', (
    tester,
  ) async {
    final pending = Completer<bool>();
    when(
      () => repository.isHandleAvailable('student_1'),
    ).thenAnswer((_) => pending.future);
    await pump(tester, initialName: 'Иван');
    await tester.enterText(input('onboarding_identityHandle'), 'student_1');
    await tester.pump(const Duration(milliseconds: 401));
    expect(find.byType(AppSpinner), findsOneWidget);
    await tester.enterText(input('onboarding_identityHandle'), 'ab');
    pending.complete(true);
    await tester.pump();
    expect(find.text('Ник свободен'), findsNothing);
    expect(
      tester
          .widget<AppButton>(
            find.byKey(const Key('onboarding_identityContinue')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('identity remains scrollable at 200 percent text', (
    tester,
  ) async {
    await pump(tester, scale: 2);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_identityContinue')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
