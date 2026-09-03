import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData(extensions: const [AppColors.light]),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('AppAvatar', () {
    testWidgets('renders up to two initials on a tinted circle', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AppAvatar(name: 'Иван Петров', size: 40)),
      );

      expect(find.text('ИП'), findsOneWidget);
      expect(tester.getSize(find.byType(AppAvatar)), const Size(40, 40));

      final style = tester.widget<Text>(find.text('ИП')).style;
      expect(style?.fontSize, 13);
      expect(style?.fontWeight, FontWeight.w700);
    });

    testWidgets('size drives the initials style', (tester) async {
      await tester.pumpWidget(_wrap(const AppAvatar(name: 'Олег', size: 24)));

      final style = tester.widget<Text>(find.text('О')).style;
      expect(style?.fontSize, 9);
      expect(style?.fontWeight, FontWeight.w800);
    });

    testWidgets('level badge renders in the accent circle', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppAvatar(name: 'Иван', size: 56, levelBadge: 12)),
      );

      expect(find.text('12'), findsOneWidget);
      final badge = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppAvatar),
              matching: find.byType(Container),
            )
            .last,
      );
      final decoration = badge.decoration! as BoxDecoration;
      expect(decoration.color, AppColors.light.accent);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('online dot uses the lecture tone', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppAvatar(name: 'Иван', online: true)),
      );

      final dot = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppAvatar),
              matching: find.byType(Container),
            )
            .last,
      );
      expect((dot.decoration! as BoxDecoration).color, AppColors.light.lecture);
    });

    testWidgets('an image url falls back to the stripe placeholder', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AppAvatar(name: 'Иван', imageUrl: 'https://example.com/a.png'),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('И'), findsNothing);
    });
  });

  group('AppAvatarStack', () {
    testWidgets('renders one avatar per name', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppAvatarStack(names: ['Иван', 'Мария', 'Олег'])),
      );

      expect(find.byType(AppAvatar), findsNWidgets(3));
    });

    testWidgets('box is tall enough for the ring (no clipping)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AppAvatarStack(names: ['Иван', 'Мария'])),
      );

      final box = tester.getSize(find.byType(AppAvatarStack));
      expect(box.height, 40);
      expect(box.width, 40 + 26);
    });

    testWidgets('maxVisible trims the stack and adds a +N tail', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AppAvatarStack(
            names: ['Иван', 'Мария', 'Олег', 'Пётр'],
            maxVisible: 2,
          ),
        ),
      );

      expect(find.byType(AppAvatar), findsNWidgets(2));
      expect(find.text('+2'), findsOneWidget);
    });

    testWidgets('renders nothing for empty names', (tester) async {
      await tester.pumpWidget(_wrap(const AppAvatarStack(names: [])));

      expect(find.byType(AppAvatar), findsNothing);
      expect(tester.getSize(find.byType(AppAvatarStack)), Size.zero);
    });
  });
}
