import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/tour/app_tour_anchors.dart';
import 'package:rtu_mirea_app/tour/model/app_tour_target.dart';

void main() {
  const realKey = Key('real-tour-anchor');
  const previewKey = Key('preview-tour-anchor');
  const target = AppTourTarget.scheduleWeek;

  Widget app({
    bool real = true,
    bool preview = true,
    AppTourTarget previewTarget = target,
  }) => MaterialApp(
    theme: AppTheme.lightTheme,
    home: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (real)
            const AppTourAnchor(
              key: realKey,
              target: target,
              child: SizedBox(width: 90, height: 44),
            ),
          if (preview)
            AppEntryPreview(
              child: AppTourAnchor(
                key: previewKey,
                target: previewTarget,
                child: const SizedBox(width: 240, height: 120),
              ),
            ),
        ],
      ),
    ),
  );

  testWidgets('an entry preview cannot become a tour target', (tester) async {
    await tester.pumpWidget(app(real: false));
    expect(find.byKey(previewKey), findsOneWidget);
    expect(AppTourAnchors.contextOf(target), isNull);
    expect(AppTourAnchors.rectOf(target), isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('preview anchors preserve the real target when updated', (
    tester,
  ) async {
    await tester.pumpWidget(app(preview: false));
    final realContext = tester.element(find.byKey(realKey));
    final realRect = tester.getRect(find.byKey(realKey));
    expect(AppTourAnchors.contextOf(target), same(realContext));

    await tester.pumpWidget(app());
    expect(find.byKey(previewKey), findsOneWidget);
    expect(AppTourAnchors.contextOf(target), same(realContext));
    expect(AppTourAnchors.rectOf(target), realRect);

    await tester.pumpWidget(app(previewTarget: AppTourTarget.homeDays));
    expect(AppTourAnchors.contextOf(AppTourTarget.homeDays), isNull);
    expect(AppTourAnchors.contextOf(target), same(realContext));
    expect(AppTourAnchors.rectOf(target), realRect);

    await tester.pumpWidget(app(preview: false));
    expect(AppTourAnchors.contextOf(target), same(realContext));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(AppTourAnchors.contextOf(target), isNull);
  });
}
