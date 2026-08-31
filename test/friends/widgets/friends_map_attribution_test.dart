import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_map_attribution.dart';

void main() {
  testWidgets('keeps attribution visible above the draggable panel', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 400);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final extent = ValueNotifier(0.28);
    addTearDown(extent.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Stack(
            children: [FriendsMapAttribution(panelExtent: extent)],
          ),
        ),
      ),
    );

    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    final attribution = find.descendant(
      of: find.byType(FriendsMapAttribution),
      matching: find.byType(Positioned),
    );
    final initialBottom = tester.widget<Positioned>(attribution).bottom!;

    extent.value = 0.5;
    await tester.pump();

    expect(
      tester.widget<Positioned>(attribution).bottom,
      greaterThan(initialBottom),
    );

    extent.value = 0.7;
    await tester.pump();

    final attributionRect = tester.getRect(
      find.text('© OpenStreetMap contributors'),
    );
    final panelTop = tester.view.physicalSize.height * (1 - extent.value);
    expect(attributionRect.bottom, lessThanOrEqualTo(panelTop - 10));
    expect(
      tester.getSize(find.byType(AppPressable)).height,
      greaterThanOrEqualTo(44),
    );
    expect(
      tester.getSemantics(find.byType(AppPressable)),
      matchesSemantics(
        label: '© OpenStreetMap contributors',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
  });
}
