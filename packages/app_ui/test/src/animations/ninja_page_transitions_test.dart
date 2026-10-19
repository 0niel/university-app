import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final platform in TargetPlatform.values) {
    for (final reduced in [false, true]) {
      testWidgets('$platform page keeps glass opaque, reduced=$reduced', (
        tester,
      ) async {
        final navigator = GlobalKey<NavigatorState>();
        Future<String?>? result;
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigator,
            theme: AppTheme.lightTheme.copyWith(platform: platform),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: child!,
            ),
            home: Scaffold(
              body: TextButton(
                onPressed: () {
                  result = navigator.currentState!.push<String>(
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(
                        key: Key('destination'),
                        body: Center(
                          child: AppGlassSurface(
                            key: Key('glass'),
                            child: Text('Destination'),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final glass = find.byKey(const Key('glass'));
        expect(glass, findsOneWidget);
        expect(
          find.ancestor(of: glass, matching: find.byType(FadeTransition)),
          findsNothing,
        );
        expect(
          find.ancestor(of: glass, matching: find.byType(Opacity)),
          findsNothing,
        );
        final position = tester.getTopLeft(
          find.byKey(const Key('destination')),
        );
        if (reduced) {
          expect(position, Offset.zero);
        } else {
          expect(position.dx, greaterThan(0));
          expect(position.dx, lessThan(tester.view.physicalSize.width));
        }
        await tester.pumpAndSettle();
        expect(
          tester.getTopLeft(find.byKey(const Key('destination'))),
          Offset.zero,
        );
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(await result, isNull);
        expect(find.text('Open'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
    'Android back respects PopScope and explicit pop retains result',
    (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          theme: AppTheme.lightTheme.copyWith(platform: TargetPlatform.android),
          home: const Scaffold(body: Text('Home')),
        ),
      );
      var attempts = 0;
      final result = navigator.currentState!.push<String>(
        MaterialPageRoute(
          builder: (_) => PopScope<String>(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) attempts++;
            },
            child: const Scaffold(body: Text('Guarded')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(attempts, 1);
      expect(find.text('Guarded'), findsOneWidget);
      navigator.currentState!.pop('Saved');
      await tester.pumpAndSettle();
      expect(await result, 'Saved');
      expect(find.text('Home'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('accessible navigation skips the page transform immediately', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        theme: AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(accessibleNavigation: true),
          child: child!,
        ),
        home: const Scaffold(),
      ),
    );
    final result = navigator.currentState!.push<void>(
      MaterialPageRoute(
        builder: (_) => const Scaffold(key: Key('accessible')),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(
      tester.getTopLeft(find.byKey(const Key('accessible'))),
      Offset.zero,
    );
    await tester.pumpAndSettle();
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await result;
    expect(tester.takeException(), isNull);
  });
}
