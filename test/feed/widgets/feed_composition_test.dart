import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/categories/widgets/category_tab_skeleton.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_hero_post.dart';
import 'package:rtu_mirea_app/feed/widgets/feed_post_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Widget _wrap(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
  return MaterialApp(
    theme: NinjaTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, appChild) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: appChild!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

class _CategoryTabsHost extends StatefulWidget {
  const _CategoryTabsHost();

  @override
  State<_CategoryTabsHost> createState() => _CategoryTabsHostState();
}

class _CategoryTabsHostState extends State<_CategoryTabsHost>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CategoriesTabBar(
      controller: _controller,
      tabs: const [
        CategoryTabData(categoryName: 'Главное'),
        CategoryTabData(categoryName: 'Университет'),
        CategoryTabData(categoryName: 'Наука'),
      ],
    );
  }
}

void main() {
  testWidgets('feed hero is the one pastel feature card of the tab', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        FeedHeroPost(
          title: 'Главная новость университета с длинным заголовком',
          meta: 'Сегодня · 12:30',
          badgeLabel: 'Главное',
          onTap: () {},
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final colors = NinjaColors.light();
    expect(tester.takeException(), isNull);
    expect(find.byType(Card), findsNothing);
    expect(find.byType(Divider), findsNothing);
    expect(
      find.bySemanticsLabel(
        'Главная новость университета с длинным заголовком',
      ),
      findsOneWidget,
    );
    final surfaces = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
    expect(surfaces.any((box) => box.color == colors.accentSoft), isTrue);
    expect(surfaces.any((box) => box.color == colors.surface), isFalse);
    expect(surfaces.any((box) => box.color == colors.ink), isFalse);
    expect(
      tester.widget<ClipRRect>(find.byType(ClipRRect).first).borderRadius,
      BorderRadius.circular(NinjaRadius.card),
    );
    final headline = tester.widget<Text>(
      find.text('Главная новость университета с длинным заголовком'),
    );
    expect(headline.style?.color, colors.onAccentSoft);
    expect(
      tester.widget<Text>(find.text('Сегодня · 12:30')).style?.color,
      colors.onAccentSoftMuted,
    );
  });

  testWidgets('feed hero actions are pills on the pastel card', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        FeedHeroPost(
          title: 'Хакатон',
          meta: 'Сегодня',
          actionLabel: 'Записаться',
          onAction: () => tapped = true,
          secondaryActionLabel: 'В команду',
          onSecondaryAction: () {},
        ),
      ),
    );

    final colors = NinjaColors.light();
    final pills = tester
        .widgetList<Container>(find.byType(Container))
        .where((container) => container.decoration is BoxDecoration)
        .map((container) => container.decoration! as BoxDecoration)
        .where((decoration) => decoration.color == colors.onAccentSoft)
        .toList();
    expect(pills, hasLength(1));
    expect(pills.single.borderRadius, BorderRadius.circular(NinjaRadius.pill));
    expect(
      tester.getSize(find.text('Записаться')).height,
      lessThan(48),
    );

    await tester.tap(find.text('Записаться'));
    expect(tapped, isTrue);
  });

  testWidgets('feed row is a borderless surface card with one action', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        FeedPostRow(
          title: 'Новая лаборатория открылась в кампусе',
          meta: 'Наука · 2 часа назад',
          onTap: () => tapped = true,
        ),
      ),
    );

    final row = find.bySemanticsLabel('Новая лаборатория открылась в кампусе');
    expect(row, findsOneWidget);
    expect(find.byType(Card), findsNothing);
    expect(find.byType(Divider), findsNothing);
    expect(tester.getSize(row).height, greaterThanOrEqualTo(78));

    final decoration =
        tester
                .widget<Container>(
                  find
                      .descendant(of: row, matching: find.byType(Container))
                      .first,
                )
                .decoration!
            as BoxDecoration;
    expect(decoration.color, NinjaColors.light().surface);
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNull);
    expect(decoration.gradient, isNull);

    await tester.tap(row);
    expect(tapped, isTrue);
  });

  testWidgets('feed categories are filled chips with a single accent', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _wrap(
        const _CategoryTabsHost(),
        textScaler: const TextScaler.linear(2),
      ),
    );

    final colors = NinjaColors.light();
    expect(tester.takeException(), isNull);
    expect(find.byType(Chip), findsNothing);
    expect(find.byType(ChoiceChip), findsNothing);

    final chips = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((chip) => chip.decoration! as BoxDecoration)
        .toList();
    expect(chips.where((chip) => chip.color == colors.brand), hasLength(1));
    expect(
      chips.where((chip) => chip.color == colors.surfaceAlt),
      hasLength(2),
    );
    expect(chips.every((chip) => chip.border == null), isTrue);
    expect(
      tester.getSize(find.text('Главное')).height,
      lessThanOrEqualTo(tester.getSize(find.byType(CategoriesTabBar)).height),
    );
  });

  testWidgets('loading categories share one spatial scene', (tester) async {
    await tester.pumpWidget(
      _wrap(const CategoriesTabBar(tabs: [], isLoading: true)),
    );

    expect(find.byType(CategoryTabSkeleton), findsNWidgets(5));
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 1);
  });
}
