import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as renderer;
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_canvas_controls.dart';

void main() {
  for (final axis in Axis.values) {
    for (final glassEnabled in [true, false]) {
      testWidgets(
        'floating $axis controls share zoom glass with effect $glassEnabled',
        (tester) async {
          tester.view
            ..physicalSize = const Size(320, 600)
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          final calls = <String>[];
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.generateTheme(
                AppColors.light,
                Brightness.light,
                glassEnabled: glassEnabled,
              ),
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Center(
                  child: MapCanvasControls(
                    axis: axis,
                    onZoomIn: () => calls.add('in'),
                    onZoomOut: () => calls.add('out'),
                    onFit: () => calls.add('fit'),
                    onRotate: () => calls.add('rotate'),
                    onToggle3D: () => calls.add('3d'),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final zoom = find.byKey(const ValueKey('map-zoom-controls'));
          expect(
            find.descendant(of: zoom, matching: find.byType(AppIconButton)),
            findsNWidgets(2),
          );
          expect(
            find.descendant(of: zoom, matching: find.byType(AppGlassSurface)),
            findsNothing,
          );
          final lenses = find.byType(AppGlassRenderer);
          expect(lenses, glassEnabled ? findsWidgets : findsNothing);
          expect(find.byType(renderer.LiquidGlassLayer), findsOneWidget);
          for (final lens in lenses.evaluate()) {
            expect(AppGlassRendererScope.sharesLayerOf(lens), isTrue);
          }
          final l10n = tester.element(find.byType(MapCanvasControls)).l10n;
          for (final label in [
            l10n.mapZoomIn,
            l10n.mapZoomOut,
            l10n.mapFitFloorPlan,
            l10n.mapRotatePlan,
            l10n.mapVolumeView,
          ]) {
            final button = find.byTooltip(label);
            expect(button.hitTestable(), findsOneWidget);
            await tester.tap(button);
            await tester.pumpAndSettle();
          }
          expect(calls, ['in', 'out', 'fit', 'rotate', '3d']);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
