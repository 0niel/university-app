import 'dart:ui' show SemanticsAction, Tristate;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_card.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('hidden app dims foreground without isolating its glass', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: MiniAppCard(
          app: const MiniApp(
            id: 'hidden',
            slug: 'hidden',
            name: 'Скрытый сервис',
            isHidden: true,
          ),
          onTap: () {},
        ),
      ),
      size: const Size(320, 900),
    );
    await tester.pumpAndSettle();
    final surface = find.byType(AppGlassSurface);
    expect(surface, findsOneWidget);
    var isolated = false;
    tester.element(surface).visitAncestorElements((ancestor) {
      if (ancestor.widget is MiniAppCard) return false;
      if (ancestor.widget is Opacity || ancestor.widget is FadeTransition) {
        isolated = true;
      }
      return true;
    });
    expect(isolated, isFalse);
    expect(
      find.descendant(of: surface, matching: find.byType(Opacity)),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Opacity>(
            find.descendant(of: surface, matching: find.byType(Opacity)),
          )
          .opacity,
      .55,
    );
    expect(find.bySemanticsLabel(RegExp('Скрытый сервис')), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  for (final featured in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'mini app keeps one glass surface and actions, '
        'featured $featured scale $scale',
        (tester) async {
          var taps = 0;
          var longPresses = 0;
          await tester.pumpApp(
            Scaffold(
              body: SingleChildScrollView(
                child: MiniAppCard(
                  app: MiniApp(
                    id: 'app',
                    slug: 'app',
                    name: 'Сервис университета',
                    description: 'Описание сервиса',
                    isFeatured: featured,
                    status: MiniAppStatus.published,
                  ),
                  onTap: () => taps++,
                  onLongPress: () => longPresses++,
                ),
              ),
            ),
            size: const Size(320, 900),
            textScaler: TextScaler.linear(scale),
          );
          await tester.pumpAndSettle();
          final card = find.byType(MiniAppCard);
          expect(
            find.descendant(of: card, matching: find.byType(AppGlassSurface)),
            findsOneWidget,
          );
          expect(
            find.bySemanticsLabel(RegExp('Сервис университета')),
            findsWidgets,
          );
          await tester.tap(find.text('Сервис университета'));
          await tester.pumpAndSettle();
          expect(taps, 1);
          await tester.longPress(find.text('Сервис университета'));
          await tester.pumpAndSettle();
          expect(longPresses, 1);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final hidden in [false, true]) {
    testWidgets(
      'card exposes one complete actionable button, hidden $hidden',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          var taps = 0;
          var longPresses = 0;
          const name = 'Полное длинное название университетского сервиса';
          const description = 'Подробное описание возможностей мини-приложения';
          await tester.pumpApp(
            Scaffold(
              body: SingleChildScrollView(
                child: MiniAppCard(
                  app: MiniApp(
                    id: 'accessible',
                    slug: 'accessible',
                    name: name,
                    description: description,
                    isHidden: hidden,
                    status: MiniAppStatus.pendingReview,
                    ratingAvg: 4.9,
                    ratingCount: 20,
                  ),
                  showStatus: true,
                  onTap: () => taps++,
                  onLongPress: () => longPresses++,
                ),
              ),
            ),
            size: const Size(320, 900),
            textScaler: const TextScaler.linear(2),
          );
          await tester.pumpAndSettle();

          final buttons = find.semantics.byPredicate(
            (node) => node.flagsCollection.isButton,
          );
          expect(buttons, findsOneWidget);
          final button = buttons.evaluate().single;
          expect(button.label, contains(name));
          expect(button.label, contains(description));
          expect(button.label, contains('4.9'));
          expect(button.flagsCollection.isEnabled, Tristate.isTrue);
          expect(
            button.getSemanticsData().hasAction(SemanticsAction.tap),
            isTrue,
          );
          expect(
            button.getSemanticsData().hasAction(SemanticsAction.longPress),
            isTrue,
          );
          tester.semantics.tap(buttons);
          await tester.pump();
          tester.semantics.longPress(buttons);
          await tester.pump();
          expect(taps, 1);
          expect(longPresses, 1);
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets('featured and regular cards share a compact phone layout', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: Column(
          children: [
            for (final featured in [false, true])
              MiniAppCard(
                app: MiniApp(
                  id: '$featured',
                  slug: '$featured',
                  name: 'Искра',
                  description: 'Знакомства в университете',
                  isFeatured: featured,
                  ratingAvg: 4.8,
                  ratingCount: 120,
                  launchCount: 1234,
                ),
                onTap: () {},
              ),
          ],
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pumpAndSettle();
    final regular = tester.getSize(find.byType(MiniAppCard).first);
    final featured = tester.getSize(find.byType(MiniAppCard).last);
    expect(regular.height, inInclusiveRange(80, 112));
    expect(featured.height, regular.height);
    expect(find.text('4.8'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('metadata and moderation status fit narrow enlarged text', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: MiniAppCard(
            app: const MiniApp(
              id: 'accessible',
              slug: 'accessible',
              name: 'Длинное название университетского сервиса',
              description: 'Подробное описание возможностей приложения',
              isFeatured: true,
              ratingAvg: 4.9,
              ratingCount: 200,
              launchCount: 1234567,
              status: MiniAppStatus.pendingReview,
            ),
            showStatus: true,
            onTap: () {},
          ),
        ),
      ),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pumpAndSettle();
    expect(find.text('4.9'), findsOneWidget);
    expect(find.byType(MiniAppStatusPill), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('skeleton matches the compact card footprint', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SingleChildScrollView(
          child: MiniAppCardSkeleton(featured: true),
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.pump(const Duration(milliseconds: 16));
    expect(
      tester.getSize(find.byType(MiniAppCardSkeleton)).height,
      inInclusiveRange(80, 112),
    );
    expect(tester.takeException(), isNull);
  });

  test('mini app accent parsing falls back for invalid values', () {
    const fallback = Color(0xff123456);
    expect(
      MiniAppIconTile.resolveAccent('#f04b8a', fallback: fallback),
      const Color(0xfff04b8a),
    );
    expect(
      MiniAppIconTile.resolveAccent('unknown', fallback: fallback),
      fallback,
    );
    expect(
      MiniAppIconTile.resolveAccent('#zzzzzz', fallback: fallback),
      fallback,
    );
  });
}
