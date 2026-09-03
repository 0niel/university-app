import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/pump_app.dart';

void main() {
  final first = DateTime(2026);
  final last = DateTime(2026, 12, 31);
  final initial = DateTime(2026, 3, 15);
  final selected = DateTime(2026, 3, 31);
  final quickChips = [
    (label: 'Начало месяца', date: DateTime(2026, 3)),
    (label: 'Конец месяца', date: selected),
  ];

  Future<void> openPicker(
    WidgetTester tester,
    Future<void> Function(BuildContext) open, {
    Size size = const Size(320, 600),
    double keyboard = 0,
    double textScale = 1,
  }) async {
    tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: AppButton.primary(
              label: 'Открыть календарь',
              onPressed: () => open(context),
            ),
          ),
        ),
      ),
      size: size,
      textScaler: TextScaler.linear(textScale),
    );
    expect(tester.view.physicalSize, size);
    await tester.tap(find.text('Открыть календарь'));
    await tester.pumpAndSettle();
  }

  Finder day(DateTime date) => find.byWidgetPredicate(
    (widget) =>
        widget is AppDatePickerDayCell &&
        widget.day.year == date.year &&
        widget.day.month == date.month &&
        widget.day.day == date.day,
  );

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    expect(finder.hitTestable(), findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  const viewports = [
    (name: '320x600', size: Size(320, 600), keyboard: 0.0, scale: 1.0),
    (name: 'landscape', size: Size(600, 320), keyboard: 0.0, scale: 1.0),
    (name: 'keyboard', size: Size(320, 600), keyboard: 260.0, scale: 1.0),
    (name: 'large text', size: Size(320, 600), keyboard: 0.0, scale: 2.0),
  ];

  for (final viewport in viewports) {
    testWidgets('single date remains selectable in ${viewport.name}', (
      tester,
    ) async {
      DateTime? result;
      await openPicker(
        tester,
        (context) async {
          result = await showAppDatePicker(
            context,
            initial: initial,
            firstDate: first,
            lastDate: last,
            quickChips: quickChips,
          );
        },
        size: viewport.size,
        keyboard: viewport.keyboard,
        textScale: viewport.scale,
      );
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(AppDatePickerSheet));
      expect(MediaQuery.viewInsetsOf(context).bottom, viewport.keyboard);
      final done = context.l10n.done;
      expect(find.text('Начало месяца'), findsOneWidget);
      expect(day(DateTime(2026, 3)), findsOneWidget);
      expect(day(selected), findsOneWidget);
      await tapVisible(tester, day(selected));
      expect(
        tester.widget<AppDatePickerDayCell>(day(selected)).state,
        AppDatePickerDayState.selected,
      );
      await tapVisible(tester, find.text(done));
      expect(result, selected);
      expect(find.byType(AppDatePickerSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple dates remain selectable in ${viewport.name}', (
      tester,
    ) async {
      List<DateTime>? result;
      await openPicker(
        tester,
        (context) async {
          result = await showAppMultiDatePicker(
            context,
            selected: [initial],
            firstDate: first,
            lastDate: last,
          );
        },
        size: viewport.size,
        keyboard: viewport.keyboard,
        textScale: viewport.scale,
      );
      expect(tester.takeException(), isNull);
      final context = tester.element(find.byType(AppMultiDatePickerSheet));
      expect(MediaQuery.viewInsetsOf(context).bottom, viewport.keyboard);
      final done = context.l10n.done;
      expect(day(DateTime(2026, 3)), findsOneWidget);
      expect(day(selected), findsOneWidget);
      await tapVisible(tester, day(selected));
      await tapVisible(tester, find.text(done));
      expect(result, [initial, selected]);
      expect(find.byType(AppMultiDatePickerSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('quick date chip returns its date on a short screen', (
    tester,
  ) async {
    DateTime? result;
    await openPicker(tester, (context) async {
      result = await showAppDatePicker(
        context,
        initial: initial,
        firstDate: first,
        lastDate: last,
        quickChips: quickChips,
      );
    });
    await tapVisible(tester, find.text('Конец месяца'));
    expect(result, selected);
    expect(find.byType(AppDatePickerSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('date confirmation can immediately open the time sheet', (
    tester,
  ) async {
    DateTime? date;
    PickedTime? time;
    await openPicker(tester, (context) async {
      date = await showAppDatePicker(
        context,
        initial: initial,
        firstDate: first,
        lastDate: last,
        quickChips: quickChips,
      );
      if (date == null || !context.mounted) return;
      time = await showAppTimePicker(
        context,
        initial: (hour: 23, minute: 59),
      );
    });
    final done = tester.element(find.byType(AppDatePickerSheet)).l10n.done;
    await tapVisible(tester, day(selected));
    await tapVisible(tester, find.text(done));
    expect(find.byType(AppDatePickerSheet), findsNothing);
    expect(find.byType(AppTimePickerSheet), findsOneWidget);
    expect(find.text('23:59'), findsOneWidget);
    await tapVisible(tester, find.text(done));
    expect(date, selected);
    expect(time, (hour: 23, minute: 59));
    expect(find.byType(AppTimePickerSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clear remains reachable with large text on a short screen', (
    tester,
  ) async {
    List<DateTime>? result;
    await openPicker(
      tester,
      (context) async {
        result = await showAppMultiDatePicker(
          context,
          selected: [initial, selected],
          firstDate: first,
          lastDate: last,
        );
      },
      textScale: 2,
    );
    final l10n = tester.element(find.byType(AppMultiDatePickerSheet)).l10n;
    await tapVisible(tester, find.text(l10n.pickerClear));
    expect(find.text(l10n.pickerSelectedCount(0)), findsOneWidget);
    expect(find.text(l10n.pickerClear), findsNothing);
    await tapVisible(tester, find.text(l10n.done));
    expect(result, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
