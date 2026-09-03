import 'dart:ui' show Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child, {bool reduceMotion = false}) => MaterialApp(
        theme: NinjaTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: const TextScaler.linear(2),
            accessibleNavigation: reduceMotion,
          ),
          child: Scaffold(body: SizedBox(width: 320, child: child)),
        ),
      );

  testWidgets('is a large-text safe selected choice', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppRadioRow(
          title: 'Голубой',
          subtitle: 'Акцент института',
          selected: true,
          leading: const AppLineIconWidget(AppLineIcon.palette),
          onTap: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(AppRadioRow)).height,
      greaterThanOrEqualTo(58),
    );
    final semantics = tester.getSemantics(find.byType(AppRadioRow));
    expect(semantics.flagsCollection.isButton, isTrue);
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
  });

  testWidgets('removes selection motion for accessible navigation', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AppRadioRow(title: 'Авто', selected: false),
        reduceMotion: true,
      ),
    );

    expect(
      tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .every((widget) => widget.duration == Duration.zero),
      isTrue,
    );
  });

  testWidgets('standalone rows retain their rounded selection', (tester) async {
    await tester.pumpWidget(
      wrap(const AppRadioRow(title: 'Standalone', selected: true)),
    );
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    expect(
      (container.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(AppRadius.card),
    );
  });

  for (final dark in [false, true]) {
    testWidgets('grouped middle selection is flat in dark=$dark',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const Scaffold(
            body: AppListGroup(
              children: [
                AppRadioRow(
                  title: 'First',
                  selected: false,
                  borderRadius: BorderRadius.zero,
                ),
                AppRadioRow(
                  title: 'Middle',
                  selected: true,
                  borderRadius: BorderRadius.zero,
                ),
                AppRadioRow(
                  title: 'Last',
                  selected: false,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
          ),
        ),
      );
      final middle = find
          .ancestor(
            of: find.text('Middle'),
            matching: find.byType(AnimatedContainer),
          )
          .first;
      final decoration =
          tester.widget<AnimatedContainer>(middle).decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.zero);
      expect(
        decoration.color,
        dark ? AppColors.dark.tint : AppColors.light.tint,
      );
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clip.borderRadius, BorderRadius.circular(AppRadius.card));
      expect(tester.takeException(), isNull);
    });
  }
}
