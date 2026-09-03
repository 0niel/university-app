import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/lesson_color_editor.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'custom color supports exact HEX and compact large text '
      '${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        int? saved;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: LessonColorEditor(
                    color: const Color(0xFF2F7AFF),
                    onSaved: (value) => saved = value,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('lesson-color-hex')),
            matching: find.byType(EditableText),
          ),
          'ABCDEF',
        );
        await tester.pump();
        final save = find.byKey(const ValueKey('lesson-color-save'));
        await tester.ensureVisible(save);
        await tester.tap(save);
        expect(saved, 0xFFABCDEF);
        expect(tester.takeException(), isNull);
        expect(find.byType(Slider), findsNWidgets(3));
      },
    );
  }
}
