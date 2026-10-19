import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';
import 'package:rtu_mirea_app/community/models/event_draft.dart';
import 'package:rtu_mirea_app/community/widgets/create_event_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

void main() {
  Widget buildSubject({
    required Future<bool> Function(EventDraft draft) onSubmit,
    CampusEvent? existing,
    double textScale = 1,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      home: Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            body: SingleChildScrollView(
              child: CreateEventSheet(onSubmit: onSubmit, existing: existing),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('fits a narrow screen at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ru'),
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CreateEventSheet(onSubmit: (_) async => true),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Создать событие'), findsOneWidget);
  });

  testWidgets('shows an inline error when the title is empty', (
    tester,
  ) async {
    var submitted = false;
    await tester.pumpWidget(
      buildSubject(
        onSubmit: (_) async {
          submitted = true;
          return true;
        },
      ),
    );

    await tester.ensureVisible(find.text('Создать событие'));
    await tester.tap(find.text('Создать событие'));
    await tester.pumpAndSettle();

    expect(find.text('Введите название'), findsOneWidget);
    expect(submitted, isFalse);
  });

  testWidgets(
    'category rail keeps page gutters inside edge swipes at 200% text',
    (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        buildSubject(onSubmit: (_) async => false, textScale: 2),
      );
      final chips = find.byType(AppChipRow<EventCategory>);
      await tester.ensureVisible(chips);
      await tester.pumpAndSettle();
      final scrollable = find.descendant(
        of: chips,
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scrollable).position
        ..jumpTo(0);
      await tester.pump();
      final bounds = tester.getRect(scrollable);
      final page = tester.getRect(find.byType(CreateEventSheet));
      expect(bounds.left, page.left);
      expect(bounds.right, page.right);
      final first = tester.widget<AppChipRow<EventCategory>>(chips).items.first;
      expect(
        tester
                .getTopLeft(
                  find
                      .descendant(of: chips, matching: find.byType(AppChip))
                      .first,
                )
                .dx -
            bounds.left,
        closeTo(20, .01),
      );
      expect(position.maxScrollExtent, greaterThan(0));
      await tester.dragFrom(
        Offset(bounds.left + 2, bounds.center.dy),
        const Offset(-160, 0),
      );
      await tester.pumpAndSettle();
      expect(position.pixels, greaterThan(0));
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();
      final beforeReturn = position.pixels;
      await tester.dragFrom(
        Offset(bounds.right - 2, bounds.center.dy),
        const Offset(160, 0),
      );
      await tester.pumpAndSettle();
      expect(position.pixels, lessThan(beforeReturn));
      position.jumpTo(0);
      await tester.pump();
      await tester.tap(find.text(first.label));
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppChipRow<EventCategory>>(chips).value,
        first.value,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('clears the inline error once a title is entered', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(onSubmit: (_) async => true));

    await tester.ensureVisible(find.text('Создать событие'));
    await tester.tap(find.text('Создать событие'));
    await tester.pumpAndSettle();
    expect(find.text('Введите название'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Открытая лекция');
    await tester.pumpAndSettle();

    expect(find.text('Введите название'), findsNothing);
  });

  testWidgets('submits a valid draft and closes the sheet', (tester) async {
    EventDraft? submittedDraft;
    await tester.pumpWidget(
      buildSubject(
        onSubmit: (draft) async {
          submittedDraft = draft;
          return true;
        },
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'Открытая лекция');
    await tester.ensureVisible(find.text('Создать событие'));
    await tester.tap(find.text('Создать событие'));
    await tester.pumpAndSettle();

    expect(submittedDraft?.title, 'Открытая лекция');
    expect(find.byType(CreateEventSheet), findsNothing);
  });

  testWidgets('keeps the sheet open and shows a banner on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(onSubmit: (_) async => false),
    );

    await tester.enterText(find.byType(TextField).first, 'Открытая лекция');
    await tester.ensureVisible(find.text('Создать событие'));
    await tester.tap(find.text('Создать событие'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateEventSheet), findsOneWidget);
    expect(
      find.text('Не удалось создать событие. Попробуй ещё раз'),
      findsOneWidget,
    );
  });

  testWidgets('prefills fields and switches to save mode when editing', (
    tester,
  ) async {
    final existing = CampusEvent(
      id: 'event-1',
      title: 'Существующее событие',
      startsAt: DateTime(2026, 9, 10, 18),
      place: 'И-301',
      category: 'sport',
    );
    await tester.pumpWidget(
      buildSubject(existing: existing, onSubmit: (_) async => true),
    );

    expect(find.text('Существующее событие'), findsWidgets);
    expect(find.text('Сохранить'), findsOneWidget);
    expect(find.text('Создать событие'), findsNothing);
  });
}
