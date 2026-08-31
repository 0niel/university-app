import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations.dart';
import 'package:rtu_mirea_app/schedule_diff/view/view.dart';
import 'package:schedule/schedule.dart';

void main() {
  group('ScheduleDiffView', () {
    Widget buildSubject(Locale locale) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const ScheduleDiffView(
          diff: ScheduleUpdateDiff(added: [], removed: [], modified: []),
          title: 'Diff',
        ),
      );
    }

    testWidgets('renders localized header in Russian', (tester) async {
      await tester.pumpWidget(buildSubject(const Locale('ru')));
      expect(find.text('Обновления расписания'), findsOneWidget);
      expect(
        find.text('Найдено 0 изменений в вашем расписании'),
        findsOneWidget,
      );
    });

    testWidgets('renders localized header in English', (tester) async {
      await tester.pumpWidget(buildSubject(const Locale('en')));
      expect(find.text('Schedule updates'), findsOneWidget);
      expect(find.text('Found 0 changes in your schedule'), findsOneWidget);
    });
  });
}
