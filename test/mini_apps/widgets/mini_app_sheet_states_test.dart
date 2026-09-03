import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';

class _Repository extends Mock implements MiniAppsRepository {}

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view
    ..physicalSize = const Size(320, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(2),
          disableAnimations: true,
          accessibleNavigation: true,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  const app = MiniApp(id: 'app', slug: 'app', name: 'Учебные материалы');

  testWidgets('revision failure is distinct from empty and can be retried', (
    tester,
  ) async {
    final repository = _Repository();
    var attempts = 0;
    when(() => repository.getRevisions(app.id)).thenAnswer((_) async {
      if (++attempts == 1) throw Exception('offline');
      return [];
    });
    await _pump(
      tester,
      MiniAppRevisionsSheet(app: app, repository: repository),
    );
    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byType(NinjaEmptyState), findsNothing);
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();
    expect(attempts, 2);
    expect(find.byType(NinjaErrorState), findsNothing);
    expect(find.byType(NinjaEmptyState), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('restore failure keeps revisions and shows a recoverable error', (
    tester,
  ) async {
    final repository = _Repository();
    when(() => repository.getRevisions(app.id)).thenAnswer(
      (_) async => [
        const MiniAppRevision(version: 2),
        const MiniAppRevision(version: 1),
      ],
    );
    when(
      () => repository.restoreRevision(appId: app.id, version: 1),
    ).thenThrow(Exception('offline'));
    await _pump(
      tester,
      MiniAppRevisionsSheet(
        app: app,
        repository: repository,
        canRestore: true,
      ),
    );
    final restore = find.text('Вернуть');
    await tester.ensureVisible(restore);
    await tester.tap(restore);
    await tester.pump();
    expect(find.text('v1'), findsOneWidget);
    expect(find.byType(NinjaBanner), findsOneWidget);
    final button = tester.widget<NinjaButton>(
      find.ancestor(of: restore, matching: find.byType(NinjaButton)),
    );
    expect(button.onPressed, isNotNull);
    await tester.ensureVisible(restore);
    await tester.tap(restore);
    await tester.pump();
    verify(
      () => repository.restoreRevision(appId: app.id, version: 1),
    ).called(2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('token load failure cannot be confused with an empty list', (
    tester,
  ) async {
    final repository = _Repository();
    final recovered = Completer<List<MiniAppDeployToken>>();
    var attempts = 0;
    when(repository.listDeployTokens).thenAnswer((_) async {
      if (++attempts == 1) throw Exception('offline');
      return recovered.future;
    });
    await _pump(tester, MiniAppTokensSheet(repository: repository));
    expect(find.byType(NinjaErrorState), findsOneWidget);
    NinjaButton createButton() => tester
        .widgetList<NinjaButton>(
          find.byType(NinjaButton),
        )
        .last;
    expect(createButton().onPressed, isNull);
    await tester.ensureVisible(find.text('Повторить'));
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    expect(createButton().onPressed, isNull);
    recovered.complete([]);
    await tester.pump();
    await tester.pump();
    expect(find.byType(NinjaErrorState), findsNothing);
    expect(createButton().onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('signing-info failure does not claim the secret is absent', (
    tester,
  ) async {
    final repository = _Repository();
    var attempts = 0;
    when(() => repository.getSigningSecretInfo(app.id)).thenAnswer((_) async {
      if (++attempts == 1) throw Exception('offline');
      return const MiniAppSigningSecretInfo(hasSecret: true);
    });
    await _pump(
      tester,
      MiniAppSecretSheet(repository: repository, appId: app.id),
    );
    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byType(NinjaListCell), findsNothing);
    await tester.ensureVisible(find.text('Повторить'));
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();
    expect(attempts, 2);
    expect(find.byType(NinjaErrorState), findsNothing);
    expect(find.byType(NinjaListCell), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final throws in [false, true]) {
    testWidgets(
      'report failure preserves input and permits retry throws=$throws',
      (
        tester,
      ) async {
        var attempts = 0;
        String? sentDetails;
        await _pump(
          tester,
          MiniAppReportSheet(
            onSubmit: (reason, details) async {
              attempts += 1;
              sentDetails = details;
              if (throws) throw Exception('offline');
              return false;
            },
          ),
        );
        await tester.enterText(find.byType(EditableText), '  Не открывается  ');
        final send = find.byType(NinjaButton);
        await tester.ensureVisible(send);
        await tester.tap(send);
        await tester.pump();
        expect(attempts, 1);
        expect(sentDetails, 'Не открывается');
        expect(find.byType(NinjaBanner), findsOneWidget);
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .controller
              .text,
          '  Не открывается  ',
        );
        expect(tester.widget<NinjaButton>(send).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
