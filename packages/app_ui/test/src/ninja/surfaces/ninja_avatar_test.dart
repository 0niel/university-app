import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  group('NinjaAvatar', () {
    testWidgets('scales the initials with the three design sizes', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              NinjaAvatar(initials: 'АС', size: 64, tone: NinjaAvatarTone.ink),
              NinjaAvatar(initials: 'КП'),
              NinjaAvatar(
                initials: 'ЕС',
                size: 32,
                tone: NinjaAvatarTone.indigo,
              ),
            ],
          ),
        ),
      );

      expect(tester.widget<Text>(find.text('АС')).style?.fontSize, 20);
      expect(tester.widget<Text>(find.text('КП')).style?.fontSize, 14);
      expect(tester.widget<Text>(find.text('ЕС')).style?.fontSize, 11);
      expect(tester.widget<Text>(find.text('АС')).style?.color, colors.onInk);
      expect(
        tester.widget<Text>(find.text('КП')).style?.color,
        colors.ink,
      );
      expect(tester.widget<Text>(find.text('ЕС')).style?.color, colors.onBrand);
      expect(tester.getSize(find.text('АС').first).height, isNonZero);
    });

    testWidgets("6a's 48px header avatar prints 700 15 initials", (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const NinjaAvatar(
            initials: 'АС',
            size: 48,
            tone: NinjaAvatarTone.ink,
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('АС'));
      expect(text.style?.fontSize, 15);
      expect(text.style?.fontWeight, FontWeight.w700);
      expect(text.style?.color, colors.onInk);
    });

    testWidgets('fills follow the tone', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaAvatar(initials: 'ЕС', tone: NinjaAvatarTone.indigo)),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaAvatar),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, colors.brand);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('surface tone uses a deterministic soft accent', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaAvatar(initials: 'КП')));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(NinjaAvatar),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final accent = colors.subjectColor('КП');
      expect(decoration.color, accent.withValues(alpha: 0.14));
      expect(tester.widget<Text>(find.text('КП')).style?.color, colors.ink);
    });

    testWidgets('presence dot is 12px green inside a canvas ring', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const NinjaAvatar(initials: 'ТБ', online: true)),
      );

      final dots = tester.widgetList<Container>(find.byType(Container)).where(
            (container) =>
                (container.decoration as BoxDecoration?)?.color == colors.green,
          );
      expect(dots, hasLength(1));
      expect(dots.first.constraints?.maxWidth, 12);
    });
  });

  group('NinjaAvatarGroup', () {
    testWidgets('overlaps members and appends the +N chip', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaAvatarGroup(
            items: [
              NinjaAvatarGroupItem('АС'),
              NinjaAvatarGroupItem('КП', tone: NinjaAvatarTone.indigo),
            ],
            overflowCount: 3,
          ),
        ),
      );

      expect(find.text('АС'), findsOneWidget);
      expect(find.text('КП'), findsOneWidget);
      expect(find.text('+3'), findsOneWidget);

      expect(tester.getSize(find.byType(NinjaAvatarGroup)).width, 103);
    });

    testWidgets('renders nothing when empty', (tester) async {
      await tester.pumpWidget(wrap(const NinjaAvatarGroup(items: [])));
      expect(find.byType(NinjaAvatar), findsNothing);
    });
  });
}
