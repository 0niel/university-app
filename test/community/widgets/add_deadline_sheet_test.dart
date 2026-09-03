import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/models/deadline_draft.dart';
import 'package:rtu_mirea_app/community/view/deadlines/add_deadline_sheet.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_options.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_deadlines_cubit.dart';
import '../../helpers/pump_app.dart';

void main() {
  late MockDeadlinesCubit cubit;
  final today = DateTime(2026, 9, 2, 10);

  setUpAll(
    () => registerFallbackValue(
      DeadlineDraft(title: '', dueAt: today, source: .me),
    ),
  );
  setUp(() {
    ToastManager.debugReset();
    cubit = MockDeadlinesCubit();
    when(() => cubit.createDeadline(any())).thenAnswer((_) async => true);
  });
  tearDown(ToastManager.debugReset);

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      Builder(
        builder: (context) => AppButton.primary(
          label: 'Open',
          onPressed: () => unawaited(
            showAppSheet<void>(
              context,
              child: AddDeadlineSheet(
                cubit: cubit,
                subjects: const ['Math', 'Physics'],
                now: today,
              ),
            ),
          ),
        ),
      ),
      size: const Size(400, 900),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets('requires a title and saves selected real subject and due date', (
    tester,
  ) async {
    await open(tester);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('add-deadline-submit')))
          .onPressed,
      isNull,
    );
    await tester.enterText(find.byType(EditableText).first, '  Homework  ');
    await tester.pump();
    await tester.tap(
      find.byKey(const ValueKey('add-deadline-subject-Physics')),
    );
    await tester.tap(find.byKey(const ValueKey('add-deadline-due-today')));
    await tester.tap(find.byKey(const ValueKey('add-deadline-submit')));
    await tester.pumpAndSettle();
    final draft =
        verify(() => cubit.createDeadline(captureAny())).captured.single
            as DeadlineDraft;
    expect(draft.title, 'Homework');
    expect(draft.subjectName, 'Physics');
    expect(draft.dueAt, DateTime(2026, 9, 2, 23, 59));
    expect(draft.source, DeadlineSource.me);
    expect(draft.remind, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('failed submission keeps draft and restores submit control', (
    tester,
  ) async {
    when(() => cubit.createDeadline(any())).thenAnswer((_) async => false);
    await open(tester);
    await tester.enterText(find.byType(EditableText).first, 'Homework');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('add-deadline-shared')));
    await tester.tap(find.byKey(const ValueKey('add-deadline-submit')));
    await tester.pumpAndSettle();
    expect(find.byType(AddDeadlineSheet), findsOneWidget);
    expect(
      tester
          .widget<AppButton>(find.byKey(const ValueKey('add-deadline-submit')))
          .onPressed,
      isNotNull,
    );
    final draft =
        verify(() => cubit.createDeadline(captureAny())).captured.single
            as DeadlineDraft;
    expect(draft.source, DeadlineSource.group);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('preserves custom subject priority and reminder options', (
    tester,
  ) async {
    await open(tester);
    await tester.enterText(find.byType(EditableText).first, 'Project');
    await tester.pump();
    await tester.tap(find.text('Настройки'));
    await tester.pumpAndSettle();
    final subject = find.byType(EditableText).last;
    await tester.ensureVisible(subject);
    await tester.enterText(subject, 'Independent ');
    await tester.pump();
    expect(
      tester.widget<EditableText>(subject).controller.text,
      'Independent ',
    );
    await tester.enterText(subject, 'Independent study');
    final priority = tester.widget<AppSegmentedControl<DeadlinePriority>>(
      find.byType(AppSegmentedControl<DeadlinePriority>),
    );
    priority.onChanged!(DeadlinePriority.urgent);
    tester.widget<AppSwitch>(find.byType(AppSwitch).last).onChanged!(false);
    await tester.pump();
    final submit = find.byKey(const ValueKey('add-deadline-submit'));
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    final draft =
        verify(() => cubit.createDeadline(captureAny())).captured.single
            as DeadlineDraft;
    expect(draft.subjectName, 'Independent study');
    expect(draft.priority, DeadlinePriority.urgent);
    expect(draft.remind, isFalse);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('primary sheet matches source order before advanced options', (
    tester,
  ) async {
    await open(tester);
    final shared = tester.getRect(
      find.byKey(const ValueKey('add-deadline-shared')),
    );
    final submit = tester.getRect(
      find.byKey(const ValueKey('add-deadline-submit')),
    );
    final options = tester.getRect(find.byType(DeadlineOptions));
    expect(submit.top, greaterThan(shared.bottom));
    expect(submit.height, 52);
    expect(options.top - submit.bottom, 14);
    expect(tester.takeException(), isNull);
  });
}
