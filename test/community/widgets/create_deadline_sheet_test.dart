import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/create_deadline_sheet.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  const config = UniversityConfig(
    organizationId: 'test-university',
    appName: 'Campus App',
    universityName: 'Test University',
    universityShortName: 'TU',
    websiteUrl: 'https://example.edu',
    supportEmail: 'support@example.edu',
    deepLinkScheme: 'campus',
    webAppHost: 'example.edu',
    webAppPathPrefix: '/app',
    winterSessionStartMonth: 2,
    winterSessionStartDay: 3,
    summerSessionStartMonth: 8,
    summerSessionStartDay: 4,
  );
  final now = DateTime(2026, 3, 1, 23, 59, 30);

  testWidgets('returns a white-label deadline draft at 200% text scale', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    DeadlineDraft? result;

    Future<void> openEditor(BuildContext context) async {
      result = await Navigator.of(context).push<DeadlineDraft>(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const .all(16),
                child: CreateDeadlineSheet(
                  universityConfig: config,
                  now: now,
                ),
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => unawaited(openEditor(context)),
                child: const Text('Открыть'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Экзамен');
    await tester.pump();
    await tester.tap(find.text('Сегодня'));
    await tester.pump();
    expect(find.text('Выбери дату и время в будущем'), findsOneWidget);
    expect(
      tester
          .widget<NinjaButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is NinjaButton && widget.label == 'Создать дедлайн',
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.testTextInput.receiveAction(.done);
    await tester.pump();
    expect(find.byType(CreateDeadlineSheet), findsOneWidget);
    await tester.tap(find.text('К сессии'));
    await tester.pump();
    final submit = find.byWidgetPredicate(
      (widget) => widget is NinjaButton && widget.label == 'Создать дедлайн',
    );
    expect(tester.widget<NinjaButton>(submit).onPressed, isNotNull);
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(result?.title, 'Экзамен');
    expect(result?.dueAt, DateTime(2026, 8, 4, 23, 59));
    expect(result?.source, DeadlineSource.me);
  });
}
