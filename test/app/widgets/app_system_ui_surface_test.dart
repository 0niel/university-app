import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/app/widgets/app_system_ui_surface.dart';

void main() {
  for (final dark in [false, true]) {
    for (final bottom in [0.0, 24.0, 48.0]) {
      for (final appBar in [false, true]) {
        testWidgets('system surface dark=$dark inset=$bottom appBar=$appBar', (
          tester,
        ) async {
          tester.view
            ..physicalSize = const Size(390, 844)
            ..devicePixelRatio = 1
            ..viewPadding = FakeViewPadding(top: 32, bottom: bottom)
            ..padding = FakeViewPadding(top: 32, bottom: bottom);
          addTearDown(tester.view.reset);
          final boundary = GlobalKey();
          final theme = dark ? AppTheme.darkTheme : AppTheme.lightTheme;
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              builder: (_, child) => RepaintBoundary(
                key: boundary,
                child: AppSystemUiSurface(child: child!),
              ),
              home: Scaffold(
                backgroundColor: Colors.transparent,
                extendBody: true,
                appBar: appBar ? AppBar(title: const Text('Screen')) : null,
                body: const SizedBox.expand(),
                bottomNavigationBar: AppBottomBar(
                  items: const [
                    AppBottomBarItem(icon: Icon(Icons.home), label: 'Home'),
                    AppBottomBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                  currentIndex: 0,
                  onSelected: (_) {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            SystemChrome.latestStyle!.systemNavigationBarColor,
            theme.scaffoldBackgroundColor,
          );
          expect(
            SystemChrome.latestStyle!.systemNavigationBarContrastEnforced,
            isFalse,
          );
          expect(
            SystemChrome.latestStyle!.systemNavigationBarIconBrightness,
            dark ? Brightness.light : Brightness.dark,
          );
          final barRect = tester.getRect(find.byType(AppBottomBar));
          expect(barRect.bottom, 844);
          final iconRect = tester.getRect(find.byIcon(Icons.home));
          expect(iconRect.bottom, lessThanOrEqualTo(844 - bottom));
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final color = await tester.runAsync(() async {
            final image = await render.toImage();
            final bytes = (await image.toByteData())!;
            final offset =
                ((image.height - 1) * image.width + image.width ~/ 2) * 4;
            final color = Color.fromARGB(
              bytes.getUint8(offset + 3),
              bytes.getUint8(offset),
              bytes.getUint8(offset + 1),
              bytes.getUint8(offset + 2),
            );
            image.dispose();
            return color;
          });
          expect(color, theme.scaffoldBackgroundColor);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
