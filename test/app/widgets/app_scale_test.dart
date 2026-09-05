import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScale(
    WidgetTester tester, {
    required Size size,
    required Widget child,
    MediaQueryData? media,
  }) async {
    tester.view
      ..physicalSize = size * 3
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: media ?? MediaQuery.of(context),
          child: AppScale(child: child!),
        ),
        home: child,
      ),
    );
  }

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    for (final width in [320.0, 360.0, 390.0, 412.0, 430.0]) {
      testWidgets(
        'proportional canvas on $platform at $width',
        (tester) async {
          late MediaQueryData actual;
          late BoxConstraints constraints;
          await pumpScale(
            tester,
            size: Size(width, 900),
            child: LayoutBuilder(
              builder: (context, value) {
                actual = MediaQuery.of(context);
                constraints = value;
                return Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    key: const ValueKey('control'),
                    width: 100,
                    height: 44,
                    child: Text('Example', style: context.text.body),
                  ),
                );
              },
            ),
          );
          final scale = width / 390;
          expect(actual.size.width, closeTo(390, .001));
          expect(constraints.maxWidth, closeTo(390, .001));
          expect(actual.size.height, closeTo(900 / scale, .001));
          expect(actual.devicePixelRatio, closeTo(3 * scale, .001));
          final box = find.byKey(const ValueKey('control'));
          final painted = tester.getBottomRight(box) - tester.getTopLeft(box);
          expect(painted.dx, closeTo(100 * scale, .001));
          expect(painted.dy, closeTo(44 * scale, .001));
          expect(AppScale.of(tester.element(box)).size(100), 100);
          expect(tester.takeException(), isNull);
        },
        variant: TargetPlatformVariant({platform}),
      );
    }
  }

  testWidgets('safe areas keyboard and accessibility retain physical bounds', (
    tester,
  ) async {
    late MediaQueryData actual;
    const fieldKey = ValueKey('field');
    const media = MediaQueryData(
      size: Size(360, 800),
      devicePixelRatio: 3,
      padding: EdgeInsets.only(top: 24),
      viewPadding: EdgeInsets.only(top: 24, bottom: 16),
      viewInsets: EdgeInsets.only(bottom: 280),
      systemGestureInsets: EdgeInsets.only(left: 12, right: 12, bottom: 16),
      textScaler: TextScaler.linear(2),
      disableAnimations: true,
      accessibleNavigation: true,
      gestureSettings: DeviceGestureSettings(touchSlop: 23),
      displayFeatures: [
        ui.DisplayFeature(
          bounds: Rect.fromLTWH(150, 0, 60, 24),
          type: ui.DisplayFeatureType.cutout,
          state: ui.DisplayFeatureState.unknown,
        ),
      ],
    );
    await pumpScale(
      tester,
      size: media.size,
      media: media,
      child: Builder(
        builder: (context) {
          actual = MediaQuery.of(context);
          return const Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Spacer(),
                  TextField(key: fieldKey),
                ],
              ),
            ),
          );
        },
      ),
    );
    const scale = 360 / 390;
    expect(actual.viewPadding.bottom * scale, closeTo(16, .001));
    expect(actual.systemGestureInsets.left * scale, closeTo(12, .001));
    expect(actual.displayFeatures.single.bounds.bottom * scale, 24);
    expect(actual.textScaler.scale(16), 32);
    expect(actual.disableAnimations, isTrue);
    expect(actual.accessibleNavigation, isTrue);
    expect(actual.gestureSettings.touchSlop, 23);
    final field = find.byKey(fieldKey);
    expect(tester.getBottomRight(field).dy, closeTo(520, .001));
    await tester.tap(field);
    await tester.enterText(field, 'БСБО-43-24');
    expect(find.text('БСБО-43-24'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation overlays and hit testing survive rotation', (
    tester,
  ) async {
    await pumpScale(
      tester,
      size: const Size(360, 800),
      child: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dialog'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog'), findsOneWidget);
    tester.view.physicalSize = const Size(800, 360) * 3;
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(AlertDialog));
    expect(MediaQuery.sizeOf(context).height, closeTo(390, .001));
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Dialog'), findsNothing);
    expect(find.text('Open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final (platform, size) in [
    (TargetPlatform.windows, const Size(360, 800)),
    (TargetPlatform.android, const Size(800, 1200)),
  ]) {
    testWidgets(
      'native canvas for $platform $size',
      (tester) async {
        late Size actual;
        await pumpScale(
          tester,
          size: size,
          child: Builder(
            builder: (context) {
              actual = MediaQuery.sizeOf(context);
              return const SizedBox.expand();
            },
          ),
        );
        expect(actual, size);
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant({platform}),
    );
  }
}
