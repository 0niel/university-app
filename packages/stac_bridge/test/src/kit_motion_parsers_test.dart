import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stac_bridge/src/widgets/kit/kit_motion_parsers.dart';
import 'package:stac_bridge/stac_bridge.dart';

import 'kit_harness.dart';

void main() {
  setUpAll(
    () => StacBridge.ensureInitialized(
      StacBridgeConfig(
        proxyUrl: 'https://example.test/proxy',
        organizationId: 'mirea',
        onAccessTokenRequested: () async => null,
      ),
    ),
  );

  testWidgets('switcher isolates outgoing content during a transition', (
    tester,
  ) async {
    const parser = StacAppAnimatedSwitcherParser();
    await pumpKit(tester, parser, {
      'duration': 300,
      'transition': 'slideUp',
      'value': 1,
      'child': {'type': 'appText', 'data': 'First'},
    });
    await pumpKit(tester, parser, {
      'duration': 300,
      'transition': 'slideUp',
      'value': 2,
      'child': {'type': 'appText', 'data': 'Second'},
    });
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('First'),
        matching: find.byWidgetPredicate(
          (widget) => widget is IgnorePointer && widget.ignoring,
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text('First'),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
    await tester.pumpAndSettle();
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('container animates dimensions and respects safe bounds', (
    tester,
  ) async {
    const parser = StacAppAnimatedContainerParser();
    await pumpKit(tester, parser, {
      'height': 40,
      'duration': 300,
      'color': 'surface',
      'child': {'type': 'appText', 'data': 'Card'},
    });
    await pumpKit(tester, parser, {
      'height': 140,
      'duration': 300,
      'color': 'accent',
      'child': {'type': 'appText', 'data': 'Card'},
    });
    await tester.pump(const Duration(milliseconds: 100));
    final height = tester.getSize(find.byType(AnimatedContainer)).height;
    expect(height, greaterThan(40));
    expect(height, lessThan(140));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 140);

    await pumpKit(tester, parser, {
      'duration': double.infinity,
      'height': double.nan,
      'padding': -4,
      'radius': -30,
    });
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(container.duration, const Duration(milliseconds: 220));
    expect(container.padding, EdgeInsets.zero);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invisible content cannot receive pointer input or semantics', (
    tester,
  ) async {
    await pumpKit(tester, const StacAppAnimatedOpacityParser(), {
      'opacity': -1,
      'duration': 9000,
      'child': {'type': 'appText', 'data': 'Hidden'},
    });
    final opacity = tester.widget<AnimatedOpacity>(
      find.byType(AnimatedOpacity),
    );
    expect(opacity.opacity, 0);
    expect(opacity.duration, const Duration(milliseconds: 2000));
    final pointer = tester.widget<IgnorePointer>(
      find
          .ancestor(
            of: find.text('Hidden'),
            matching: find.byType(IgnorePointer),
          )
          .first,
    );
    expect(pointer.ignoring, isTrue);
    expect(
      tester
          .widget<ExcludeSemantics>(
            find.ancestor(
              of: find.text('Hidden'),
              matching: find.byType(ExcludeSemantics),
            ),
          )
          .excluding,
      isTrue,
    );
  });

  testWidgets('all motion wrappers obey system reduced motion', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) => Column(
              children: [
                const StacAppAnimatedSwitcherParser().parse(context, {
                  'duration': 300,
                  'child': {'type': 'appText', 'data': 'Switcher'},
                }),
                const StacAppAnimatedContainerParser().parse(context, {
                  'duration': 300,
                  'height': 40,
                }),
                const StacAppAnimatedOpacityParser().parse(context, {
                  'duration': 300,
                  'opacity': .4,
                }),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher)).duration,
      Duration.zero,
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).duration,
      Duration.zero,
    );
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).duration,
      Duration.zero,
    );
    expect(tester.takeException(), isNull);
  });
}
