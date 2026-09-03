import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/models/subject_grades.dart';
import 'package:rtu_mirea_app/grades/widgets/add_mark_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _Grades extends MockCubit<GradesState> implements GradesCubit {}

void main() {
  testWidgets('a pending mark is single flight and failed save stays open', (
    tester,
  ) async {
    final cubit = _Grades();
    final pending = Completer<bool>();
    when(
      () => cubit.addMark(subject: 'Физика', value: 5),
    ).thenAnswer((_) => pending.future);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AddMarkSheet(
            cubit: cubit,
            subject: const SubjectGrades(subject: 'Физика'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.byType(NinjaSpinner), findsOneWidget);
    expect(
      tester
          .widgetList<AppPressable>(find.byType(AppPressable))
          .every((control) => control.onTap == null),
      isTrue,
    );
    pending.complete(false);
    await tester.pumpAndSettle();
    expect(find.byType(AddMarkSheet), findsOneWidget);
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.byType(NinjaSpinner), findsNothing);
    verify(
      () => cubit.addMark(subject: 'Физика', value: 5),
    ).called(1);
  });

  testWidgets('grade choices keep 56px geometry and equal widths', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: AddMarkSheet(
              cubit: _Grades(),
              subject: const SubjectGrades(subject: 'Физика'),
            ),
          ),
        ),
      ),
    );
    final buttons = find.byType(AppPressable);
    expect(buttons, findsNWidgets(4));
    for (var index = 0; index < 4; index++) {
      expect(tester.getSize(buttons.at(index)), const Size(64, 56));
    }
    expect(tester.takeException(), isNull);
  });
}
