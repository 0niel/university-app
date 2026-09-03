import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/lesson_color_editor.dart';

void main() {
  Widget host(Widget child, {bool dark = false, double textScale = 1}) =>
      MaterialApp(
        theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  for (final dark in [false, true]) {
    testWidgets(
      'custom color supports exact HEX and renders no sliders '
      '${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        int? saved;
        await tester.pumpWidget(
          host(
            Padding(
              padding: const EdgeInsets.all(20),
              child: LessonColorEditor(
                color: const Color(0xFF2F7AFF),
                onSaved: (value) => saved = value,
              ),
            ),
            dark: dark,
            textScale: 2,
          ),
        );

        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('app-color-hex-field')),
            matching: find.byType(EditableText),
          ),
          'ABCDEF',
        );
        await tester.pump();

        expect(saved, 0xFFABCDEF);
        expect(tester.takeException(), isNull);
        expect(find.byType(Slider), findsNothing);
      },
    );
  }

  testWidgets('tapping a swatch saves immediately without a save button', (
    tester,
  ) async {
    int? saved;
    await tester.pumpWidget(
      host(
        LessonColorEditor(
          color: const Color(0xFF2F7AFF),
          onSaved: (value) => saved = value,
        ),
      ),
    );

    final target = kAppColorPaletteSwatches[4];
    await tester.tap(find.byKey(ValueKey('app-color-swatch-$target')));
    await tester.pump();

    expect(saved, target);
  });

  testWidgets('invalid hex shows an error and does not save', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      host(
        LessonColorEditor(
          color: const Color(0xFF2F7AFF),
          onSaved: (_) => calls++,
        ),
      ),
    );

    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('app-color-hex-field')),
        matching: find.byType(EditableText),
      ),
      'ZZZZZZ',
    );
    await tester.pump();

    expect(find.text('Неверный HEX-код'), findsOneWidget);
    expect(calls, 0);
  });

  testWidgets('reset row appears only when a default color is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        LessonColorEditor(
          color: const Color(0xFF2F7AFF),
          onSaved: (_) {},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('app-color-reset')), findsNothing);

    int? saved;
    await tester.pumpWidget(
      host(
        LessonColorEditor(
          color: const Color(0xFF2F7AFF),
          defaultColor: 0xFF0E8A63,
          onSaved: (value) => saved = value,
        ),
      ),
    );
    expect(find.byKey(const ValueKey('app-color-reset')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('app-color-reset')));
    await tester.pump();
    expect(saved, 0xFF0E8A63);
  });
}
