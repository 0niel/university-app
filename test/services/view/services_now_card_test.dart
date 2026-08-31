import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/services/view/services_now_card.dart';

void main() {
  Widget subject({
    required double textScale,
    required double height,
    bool featured = false,
  }) {
    return MaterialApp(
      theme: NinjaTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 220,
              height: height,
              child: ServicesNowCard(
                icon: AppLineIcon.calendar,
                title: 'Сессия',
                subtitle: 'Через 12 дней',
                cta: 'Открыть',
                onTap: () {},
                width: 220,
                featured: featured,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('fits the compact rail at regular text scale', (tester) async {
    await tester.pumpWidget(subject(textScale: 1, height: 126));
    expect(tester.takeException(), isNull);
  });

  testWidgets('fits the expanded rail at 200 percent text', (tester) async {
    await tester.pumpWidget(subject(textScale: 2, height: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the featured card is the pastel accent surface', (tester) async {
    await tester.pumpWidget(
      subject(textScale: 1, height: 126, featured: true),
    );

    final colors = NinjaColors.light();
    final card = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(ServicesNowCard),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = card.decoration! as BoxDecoration;
    expect(decoration.color, colors.accentSoft);
    expect(
      decoration.borderRadius,
      BorderRadius.circular(NinjaRadius.card),
    );
  });

  testWidgets('a non-featured card stays on the plain surface', (tester) async {
    await tester.pumpWidget(subject(textScale: 1, height: 126));

    final card = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(ServicesNowCard),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(
      (card.decoration! as BoxDecoration).color,
      NinjaColors.light().surface,
    );
  });

  testWidgets('the call to action is a pill', (tester) async {
    await tester.pumpWidget(subject(textScale: 1, height: 126));

    final pill = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('Открыть'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect(
      (pill.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(NinjaRadius.pill),
    );
  });
}
