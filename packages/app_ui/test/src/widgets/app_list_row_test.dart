import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: child)),
      );

  group('AppListRow', () {
    testWidgets('renders title and fires onTap via AppPressable', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(AppListRow(title: 'Настройки', onTap: () => tapped = true)),
      );

      expect(find.text('Настройки'), findsOneWidget);
      expect(find.byType(AppPressable), findsOneWidget);

      await tester.tap(find.byType(AppListRow));
      expect(tapped, isTrue);
      expect(
        tester.getSize(find.byType(AppListRow)).height,
        greaterThanOrEqualTo(48),
      );
      expect(tester.getSemantics(find.byType(AppListRow)).label, 'Настройки');
    });

    testWidgets('shows a chevron only when tappable and without trailing', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          Column(
            children: [
              AppListRow(title: 'С шевроном', onTap: () {}),
              const AppListRow(title: 'Без шеврона'),
            ],
          ),
        ),
      );

      final chevrons = tester
          .widgetList<AppLineIconWidget>(find.byType(AppLineIconWidget))
          .where((icon) => icon.icon == AppLineIcon.chevronR);
      expect(chevrons.length, 1);
      expect(chevrons.first.size, 14);
      expect(chevrons.first.strokeWidth, 2.5);
    });

    testWidgets('subtitle and meta render with the row', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppListRow(
            title: 'Уведомления',
            subtitle: 'Пуши и напоминания',
            meta: '3',
          ),
        ),
      );

      expect(find.text('Пуши и напоминания'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(AppListRow)).label,
        allOf(contains('Уведомления'), contains('Пуши и напоминания'),
            contains('3'),),
      );
    });

    testWidgets('destructive paints the title in the danger colour', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppListRow(title: 'Удалить аккаунт', destructive: true)),
      );

      final text = tester.widget<Text>(find.text('Удалить аккаунт'));
      expect(text.style?.color, AppColors.light.danger);
      expect(find.byType(AppLineIconWidget), findsNothing);
    });

    testWidgets('strong switches the title to the 600 weight', (tester) async {
      await tester
          .pumpWidget(wrap(const AppListRow(title: 'Итог', strong: true)));

      final text = tester.widget<Text>(find.text('Итог'));
      expect(text.style?.fontWeight, FontWeight.w600);
      expect(text.style?.fontSize, 14);
    });

    testWidgets('a trailing button keeps handling its own tap', (tester) async {
      var rowTapped = false;
      var trailingTapped = false;
      await tester.pumpWidget(
        wrap(
          AppListRow(
            title: 'Уведомления',
            onTap: () => rowTapped = true,
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => trailingTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(trailingTapped, isTrue);
      expect(rowTapped, isFalse);
    });

    testWidgets('onDelete enables swipe-to-delete', (tester) async {
      var deleted = false;
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: AppListRow(
              title: 'Расписание',
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      expect(find.byType(Dismissible), findsOneWidget);

      await tester.drag(find.byType(AppListRow), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
    });
  });

  group('AppIconAvatar', () {
    testWidgets('renders an emoji on a tinted tile', (tester) async {
      await tester.pumpWidget(
        wrap(const AppIconAvatar(emoji: '📚', color: Color(0xFF2F7AFF))),
      );

      expect(find.text('📚'), findsOneWidget);
      expect(find.byType(AppIconTile), findsOneWidget);
      expect(tester.getSize(find.byType(AppIconAvatar)), const Size(40, 40));
    });

    testWidgets('falls back to the icon when there is no emoji', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppIconAvatar(icon: Icons.school, size: 36)),
      );

      expect(find.byIcon(Icons.school), findsOneWidget);
      expect(tester.getSize(find.byType(AppIconAvatar)), const Size(36, 36));
    });
  });

  group('AppSubjectCell', () {
    testWidgets('renders the colour bar, title, time and meta', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          SizedBox(
            width: 320,
            child: AppSubjectCell(
              title: 'Базы данных',
              time: '10:40',
              meta: 'ЛЕК · А-201',
              color: const Color(0xFF0E8A63),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Базы данных'), findsOneWidget);
      expect(find.text('10:40'), findsOneWidget);
      expect(find.text('ЛЕК · А-201'), findsOneWidget);

      final barFinder = find
          .descendant(
            of: find.byType(AppSubjectCell),
            matching: find.byType(Container),
          )
          .first;
      final decoration =
          tester.widget<Container>(barFinder).decoration! as BoxDecoration;
      expect(decoration.color, const Color(0xFF0E8A63));
      expect(
        decoration.borderRadius,
        const BorderRadius.horizontal(right: Radius.circular(3)),
      );
      expect(tester.getSize(barFinder), const Size(4, 36));

      await tester.tap(find.byType(AppSubjectCell));
      expect(tapped, isTrue);
    });
  });
}
