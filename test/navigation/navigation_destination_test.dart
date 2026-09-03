import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/navigation/tab_reselect_notifier.dart';
import 'package:rtu_mirea_app/navigation/view/navigation_branch_container.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';

void main() {
  test('visual destinations map map and services independently', () {
    expect(navigationVisualIndex('/feed'), 0);
    expect(navigationVisualIndex('/schedule/details'), 1);
    expect(navigationVisualIndex('/services/map'), 2);
    expect(navigationVisualIndex('/services/wallet'), 3);
    expect(navigationVisualIndex('/profile/settings'), 4);
  });

  test('router keeps map as a dedicated shell branch', () {
    final shell = Routes.all.whereType<StatefulShellRoute>().single;
    expect(shell.branches, hasLength(5));
    final mapRoute = shell.branches[2].routes.single as GoRoute;
    expect(mapRoute.path, '/services/map');
  });

  testWidgets('renders five equal destinations with Map selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: NinjaTheme.light(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 2,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    for (final label in const [
      'Главная',
      'Пары',
      'Карта',
      'Сервисы',
      'Профиль',
    ]) {
      expect(find.text(label), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == label &&
              widget.properties.button == true,
        ),
        findsOneWidget,
      );
    }
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.map,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Карта' &&
            widget.properties.selected == true,
      ),
      findsOneWidget,
    );

    final glyphs = tester
        .widgetList<AppLineIconWidget>(find.byType(AppLineIconWidget))
        .toList();
    expect(glyphs, hasLength(5));
    expect(glyphs[2].icon, AppLineIcon.map);
    expect(glyphs[2].strokeWidth, 2.2);
    expect(glyphs.every((glyph) => glyph.strokeWidth == 2.2), isTrue);

    final fills = tester
        .widgetList<AnimatedContainer>(
          find.descendant(
            of: find.byType(AppBottomNavigationBar),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .map((container) => container.decoration)
        .whereType<BoxDecoration>()
        .toList();
    expect(fills, hasLength(5));
    expect(fills.every((fill) => fill.shape == BoxShape.circle), isTrue);
    expect(fills[2].color, AppColors.light.accent);
    expect(
      fills.where((fill) => fill.color == AppColors.light.accent),
      hasLength(1),
    );
  });

  testWidgets('haptics run only when the selected branch changes', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        calls.add(call);
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    final selections = <int>[];
    final revision = TabReselectNotifier.instance.revision;
    handleNavigationSelection(
      currentIndex: 1,
      destinationIndex: 1,
      onSelected: selections.add,
    );
    await tester.pump();

    expect(selections, [1]);
    expect(TabReselectNotifier.instance.revision, revision + 1);
    expect(
      calls.where((call) => call.method == 'HapticFeedback.vibrate'),
      isEmpty,
    );

    handleNavigationSelection(
      currentIndex: 1,
      destinationIndex: 2,
      onSelected: selections.add,
    );
    await tester.pump();

    expect(selections, [1, 2]);
    expect(TabReselectNotifier.instance.revision, revision + 1);
    expect(
      calls.where((call) => call.method == 'HapticFeedback.vibrate'),
      hasLength(1),
    );
  });

  testWidgets('branch container preserves branches and reduces motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            disableAnimations: true,
            accessibleNavigation: true,
          ),
          child: NavigationBranchContainer(
            currentIndex: 1,
            children: const [
              Text('Feed'),
              Text('Schedule'),
              Text('Map'),
              Text('Services'),
              Text('Profile'),
            ],
          ),
        ),
      ),
    );

    final opacity = tester.widgetList<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.map((widget) => widget.opacity), [0, 0, 0, 0, 1]);
    expect(opacity.every((widget) => widget.duration == Duration.zero), isTrue);
    expect(
      tester
          .widgetList<AnimatedSlide>(find.byType(AnimatedSlide))
          .every((widget) => widget.duration == Duration.zero),
      isTrue,
    );
    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('outgoing branch completes its transition', (tester) async {
    var feedTaps = 0;

    Widget build(int currentIndex) {
      return MaterialApp(
        home: NavigationBranchContainer(
          currentIndex: currentIndex,
          children: [
            ColoredBox(
              color: Colors.red,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => feedTaps++,
                child: const Text('Feed'),
              ),
            ),
            const ColoredBox(color: Colors.blue, child: Text('Profile')),
          ],
        ),
      );
    }

    await tester.pumpWidget(build(1));
    await tester.pumpAndSettle();
    await tester.pumpWidget(build(0));
    await tester.pump(const Duration(milliseconds: 110));

    final opacity = tester.widgetList<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.map((widget) => widget.opacity), [0, 1]);

    await tester.tapAt(tester.getCenter(find.text('Feed')));
    expect(feedTaps, 1);

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('inactive branch releases and excludes keyboard focus', (
    tester,
  ) async {
    final feedFocus = FocusNode();
    final profileFocus = FocusNode();
    addTearDown(feedFocus.dispose);
    addTearDown(profileFocus.dispose);

    Widget build(int currentIndex) {
      return MaterialApp(
        home: NavigationBranchContainer(
          currentIndex: currentIndex,
          children: [
            Material(child: TextField(focusNode: feedFocus)),
            Material(child: TextField(focusNode: profileFocus)),
          ],
        ),
      );
    }

    await tester.pumpWidget(build(1));
    profileFocus.requestFocus();
    await tester.pump();
    expect(profileFocus.hasFocus, isTrue);

    await tester.pumpWidget(build(0));
    await tester.pump();
    expect(profileFocus.hasFocus, isFalse);
    expect(profileFocus.canRequestFocus, isFalse);
    expect(feedFocus.canRequestFocus, isTrue);
  });
}
