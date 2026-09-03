import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  group('NinjaAvatar', () {
    test('font size scales with diameter', () {
      expect(NinjaAvatar.fontSizeFor(24), 9);
      expect(NinjaAvatar.fontSizeFor(32), 11);
      expect(NinjaAvatar.fontSizeFor(40), 13);
      expect(NinjaAvatar.fontSizeFor(56), 18);
      expect(NinjaAvatar.fontSizeFor(72), 22);
      expect(NinjaAvatar.fontSizeFor(88), 28);
      expect(NinjaAvatar.weightFor(32), FontWeight.w800);
      expect(NinjaAvatar.weightFor(40), FontWeight.w700);
    });

    testWidgets('default tone is tint on accent', (tester) async {
      await tester.pumpWidget(
        wrapKit(const NinjaAvatar(initials: 'ОК', size: 40)),
      );

      final circle = kitDecorationOf(tester, NinjaAvatar);
      expect(circle.color, kitColors.tint);
      expect(circle.shape, BoxShape.circle);
      final style = kitStyleOf(tester, 'ОК');
      expect(style?.fontSize, 13);
      expect(style?.fontWeight, FontWeight.w700);
      expect(style?.color, kitColors.accent);
    });

    testWidgets('lesson tones map to their tints', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const NinjaAvatar(
            initials: 'АК',
            size: 32,
            tone: NinjaAvatarTone.lab,
          ),
        ),
      );

      expect(kitDecorationOf(tester, NinjaAvatar).color, kitColors.labTint);
      expect(kitStyleOf(tester, 'АК')?.color, kitColors.lab);
    });

    testWidgets('level badge is a 20px accent circle ringed by surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(const NinjaAvatar(initials: 'ОК', size: 56, level: '7')),
      );

      final badge = tester.widget<Container>(
        find.ancestor(of: find.text('7'), matching: find.byType(Container)),
      );
      expect(badge.constraints?.maxWidth, 20);
      final decoration = badge.decoration! as BoxDecoration;
      expect(decoration.color, kitColors.accent);
      expect(decoration.border, Border.all(color: kitColors.surface, width: 2));
      expect(kitStyleOf(tester, '7')?.fontSize, 10);
    });

    testWidgets('online dot is a 12px lecture circle', (tester) async {
      await tester.pumpWidget(
        wrapKit(const NinjaAvatar(initials: 'МР', online: true)),
      );

      final dot = tester.widget<Container>(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints?.maxWidth == 12,
        ),
      );
      expect((dot.decoration! as BoxDecoration).color, kitColors.lecture);
    });
  });

  group('NinjaAvatarGroup', () {
    testWidgets('overlaps 32px avatars by 10 and ends with +N', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          const NinjaAvatarGroup(
            overflowCount: 5,
            items: [
              NinjaAvatarGroupItem('АК', tone: NinjaAvatarTone.lab),
              NinjaAvatarGroupItem('МР', tone: NinjaAvatarTone.lecture),
              NinjaAvatarGroupItem('ДС', tone: NinjaAvatarTone.exam),
            ],
          ),
        ),
      );

      expect(find.text('+5'), findsOneWidget);
      expect(kitStyleOf(tester, '+5')?.color, kitColors.muted);
      expect(tester.getSize(find.byType(NinjaAvatarGroup)).width, 114);
      expect(tester.getSize(find.byType(NinjaAvatarGroup)).height, 36);
    });
  });

  group('AppAvatar', () {
    test('derives initials from the name', () {
      expect(AppAvatar.initialsOf('Олег Кузнецов'), 'ОК');
      expect(AppAvatar.initialsOf('  '), '?');
      expect(AppAvatar.initialsStyle(24).fontSize, 9);
      expect(AppAvatar.initialsStyle(88).fontSize, 28);
    });

    testWidgets('renders initials on a tinted circle with badges', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapKit(
          AppAvatar(
            name: 'Олег Кузнецов',
            size: 56,
            color: kitColors.accent,
            levelBadge: 7,
            online: true,
          ),
        ),
      );

      expect(find.text('ОК'), findsOneWidget);
      expect(kitDecorationOf(tester, AppAvatar).color, kitColors.tint);
      expect(find.text('7'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints?.maxWidth == 12,
        ),
        findsOneWidget,
      );
    });

    testWidgets('stack overlaps and appends the extra count', (tester) async {
      await tester.pumpWidget(
        wrapKit(
          const AppAvatarStack(
            names: ['Анна К', 'Мария Р', 'Денис С'],
            size: 32,
            extra: 5,
          ),
        ),
      );

      expect(find.text('+5'), findsOneWidget);
      expect(tester.getSize(find.byType(AppAvatarStack)).width, 102);
      expect(find.byType(AppAvatar), findsNWidgets(3));
    });
  });
}
