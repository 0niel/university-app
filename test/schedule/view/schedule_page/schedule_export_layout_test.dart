import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import 'schedule_export_fixture.dart';

void main() {
  final l10n = AppLocalizationsRu();
  for (final dark in [false, true]) {
    for (final size in [const Size(320, 568), const Size(390, 844)]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('export footer stays visible at $size/$scale dark=$dark', (
          tester,
        ) async {
          await pumpExportFixture(
            tester,
            dark: dark,
            size: size,
            textScale: scale,
          );
          expect(tester.takeException(), isNull);
          final submit = find.byKey(const ValueKey('schedule-export-submit'));
          final viewport = find.byKey(const ValueKey('schedule-export-scroll'));
          final footer = find.byKey(const ValueKey('schedule-export-footer'));
          final buttonBounds = tester.getRect(submit);
          expect(buttonBounds.bottom, lessThanOrEqualTo(size.height - 34));
          expect(buttonBounds.top, greaterThan(tester.getRect(viewport).top));
          expect(submit.hitTestable(), findsOneWidget);
          expect(
            find.byKey(const ValueKey('schedule-export-reminders')),
            findsNothing,
          );
          final scroll = tester.widget<SingleChildScrollView>(viewport);
          expect(scroll.padding?.resolve(TextDirection.ltr).bottom, 16);
          expect(scroll.controller!.position.maxScrollExtent, greaterThan(0));
          expect(
            find.byKey(const ValueKey('schedule-export-top-fade')),
            findsNothing,
          );
          final fade = find.byKey(
            const ValueKey('schedule-export-bottom-fade'),
          );
          expect(fade, findsOneWidget);
          expect(tester.getSize(fade).height, AppSpacing.lg);
          expect(
            tester
                .widget<IgnorePointer>(
                  find.descendant(
                    of: fade,
                    matching: find.byType(IgnorePointer),
                  ),
                )
                .ignoring,
            isTrue,
          );
          expect(
            find.descendant(of: fade, matching: find.byType(ExcludeSemantics)),
            findsOneWidget,
          );
          for (final title in [
            l10n.exportPng,
            l10n.exportSystemCalendar,
            l10n.exportIcsFile,
            l10n.share,
          ]) {
            final text = find.text(title);
            await tester.ensureVisible(text);
            await tester.pumpAndSettle();
            expect(
              text.hitTestable(),
              findsOneWidget,
              reason:
                  'viewport=${tester.getRect(viewport)} '
                  'text=${tester.getRect(text)}',
            );
            await tester.tap(text);
            await tester.pumpAndSettle();
            expect(tester.getRect(submit), buttonBounds);
            expect(submit.hitTestable(), findsOneWidget);
            expect(
              tester
                  .widgetList<AppRadioRow>(find.byType(AppRadioRow))
                  .every(
                    (row) => row.borderRadius == BorderRadius.zero,
                  ),
              isTrue,
            );
          }
          await tester.ensureVisible(find.text(l10n.exportSystemCalendar));
          await tester.tap(find.text(l10n.exportSystemCalendar));
          await tester.pumpAndSettle();
          scroll.controller!.jumpTo(
            scroll.controller!.position.maxScrollExtent,
          );
          await tester.pumpAndSettle();
          final reminders = tester.getRect(
            find.byKey(const ValueKey('schedule-export-reminders')),
          );
          final visible = tester.getRect(viewport);
          expect(reminders.top, greaterThanOrEqualTo(visible.top));
          expect(reminders.bottom, lessThanOrEqualTo(visible.bottom - 16));
          expect(visible.bottom, lessThanOrEqualTo(tester.getRect(footer).top));
          expect(tester.getRect(submit), buttonBounds);
          expect(fade, findsNothing);
          expect(
            find.byKey(const ValueKey('schedule-export-top-fade')),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('export retains sheet scrolling and close', (tester) async {
    await pumpExportFixture(
      tester,
      dark: false,
      size: const Size(390, 844),
    );
    final viewport = find.byKey(const ValueKey('schedule-export-scroll'));
    final scroll = tester.widget<SingleChildScrollView>(viewport);
    expect(scroll.controller, isA<SheetScrollController>());
    await tester.drag(viewport, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(scroll.controller!.offset, greaterThan(0));
    scroll.controller!.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(AppSheetCloseButton));
    await tester.tap(find.byType(AppSheetCloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(AppSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
