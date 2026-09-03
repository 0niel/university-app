import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/models/absence.dart';
import 'package:rtu_mirea_app/attendance/widgets/add_absence_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _Attendance extends MockCubit<AttendanceState>
    implements AttendanceCubit {}

void main() {
  testWidgets('absence form freezes input while saving and retains failure', (
    tester,
  ) async {
    final cubit = _Attendance();
    final today = DateTime(2026, 9, 2);
    when(() => cubit.state).thenReturn(AttendanceState(now: today));
    final pending = Completer<bool>();
    when(
      () => cubit.addAbsence(
        subject: 'Физика',
        date: today,
        reason: AbsenceReason.noReason,
      ),
    ).thenAnswer((_) => pending.future);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AddAbsenceSheet(cubit: cubit),
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Физика');
    await tester.pump();
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    expect(
      tester.widget<AppInputField>(find.byType(AppInputField)).enabled,
      isFalse,
    );
    expect(
      tester.widget<AppSelectField>(find.byType(AppSelectField)).onTap,
      isNull,
    );
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
    pending.complete(false);
    await tester.pumpAndSettle();
    expect(find.byType(AddAbsenceSheet), findsOneWidget);
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(
      tester.widget<AppInputField>(find.byType(AppInputField)).controller?.text,
      'Физика',
    );
    expect(
      tester.widget<AppButton>(find.byType(AppButton)).onPressed,
      isNotNull,
    );
  });
}
