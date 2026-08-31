import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ToastManager's queues are static. flutter_test asserts no Timer is left
  // pending *before* `tearDown` runs, so every test must drain (or reset)
  // its own toasts as its last step rather than relying on tearDown alone.
  tearDown(ToastManager.debugReset);

  Widget host(
    void Function(BuildContext) capture, {
    bool disableAnimations = false,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: disableAnimations),
        child: child!,
      ),
      home: Builder(
        builder: (context) {
          capture(context);
          return const Scaffold(body: SizedBox());
        },
      ),
    );
  }

  group('ToastManager queue', () {
    testWidgets('second toast waits for the first to finish (FIFO)', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c));

      ToastManager.showSuccess(
        ctx,
        message: 'First',
        duration: const Duration(milliseconds: 500),
      );
      await tester.pump();
      expect(find.text('First'), findsOneWidget);

      ToastManager.showSuccess(
        ctx,
        message: 'Second',
        duration: const Duration(milliseconds: 500),
      );
      await tester.pump();
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsNothing);

      // First toast's timer fires, then its slide-out animation plays.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);

      ToastManager.debugReset();
    });

    testWidgets(
      'duplicate type+message while visible coalesces instead of stacking',
      (tester) async {
        late BuildContext ctx;
        await tester.pumpWidget(host((c) => ctx = c));

        ToastManager.showSuccess(
          ctx,
          message: 'Same',
          duration: const Duration(milliseconds: 300),
        );
        await tester.pump();
        expect(find.text('Same'), findsOneWidget);
        expect(find.byType(Dismissible), findsOneWidget);

        // Re-show the identical toast partway through — should extend the
        // existing one, not stack a second Dismissible.
        await tester.pump(const Duration(milliseconds: 200));
        ToastManager.showSuccess(
          ctx,
          message: 'Same',
          duration: const Duration(milliseconds: 300),
        );
        await tester.pump();
        expect(find.text('Same'), findsOneWidget);
        expect(find.byType(Dismissible), findsOneWidget);

        // Original timer would have fired ~100ms from now; duration was
        // restarted, so the toast must still be visible.
        await tester.pump(const Duration(milliseconds: 150));
        expect(find.text('Same'), findsOneWidget);

        // Now past the restarted duration: it should auto-dismiss.
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();
        expect(find.text('Same'), findsNothing);

        ToastManager.debugReset();
      },
    );

    testWidgets('ToastController.dismiss removes the toast', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c));

      final controller = ToastManager.showLoading(ctx, message: 'Loading…');
      await tester.pump();
      expect(find.text('Loading…'), findsOneWidget);

      controller.dismiss();
      await tester.pumpAndSettle();

      expect(find.text('Loading…'), findsNothing);

      ToastManager.debugReset();
    });

    testWidgets('banner (top) and toast (bottom) can be visible together', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c));

      ToastManager.showBanner(
        ctx,
        title: 'Push',
        message: 'You have a message',
        duration: const Duration(seconds: 5),
      );
      ToastManager.showSuccess(
        ctx,
        message: 'Saved',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();

      expect(find.text('Push'), findsOneWidget);
      expect(find.text('You have a message'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);

      ToastManager.debugReset();
    });

    testWidgets('showCelebration renders emoji, title and subtitle', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c));

      ToastManager.showCelebration(
        ctx,
        emoji: '🏆',
        title: 'Level up',
        subtitle: 'You reached level 5',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();

      expect(find.text('🏆'), findsOneWidget);
      expect(find.text('Level up'), findsOneWidget);
      expect(find.text('You reached level 5'), findsOneWidget);

      ToastManager.debugReset();
    });

    testWidgets('visible toast exposes a live region for accessibility', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c));

      ToastManager.showSuccess(
        ctx,
        message: 'Announce me',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.liveRegion ?? false),
        ),
        findsWidgets,
      );

      ToastManager.debugReset();
    });

    testWidgets('reduce motion skips the slide and fades instead', (
      tester,
    ) async {
      late BuildContext ctx;
      await tester.pumpWidget(host((c) => ctx = c, disableAnimations: true));

      ToastManager.showSuccess(
        ctx,
        message: 'Reduced motion',
        duration: const Duration(seconds: 5),
      );
      await tester.pump();

      expect(find.text('Reduced motion'), findsOneWidget);
      // Dismissible always contributes its own SlideTransition for the drag
      // gesture; what we assert here is that *our* entrance transition is a
      // fade (not a slide) when the platform requests reduced motion.
      expect(
        find.ancestor(
          of: find.text('Reduced motion'),
          matching: find.byType(FadeTransition),
        ),
        findsWidgets,
      );

      ToastManager.debugReset();
    });
  });
}
