import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_canvas_controls.dart';

void main() {
  for (final axis in Axis.values) {
    testWidgets(
      '$axis map controls keep geometry and actions across glass toggle',
      (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(844, 600)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        var enabled = true;
        late StateSetter update;
        final calls = <String>[];
        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return MaterialApp(
                theme: AppTheme.generateTheme(
                  AppColors.dark,
                  Brightness.dark,
                  glassEnabled: enabled,
                ),
                locale: const Locale('ru'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: Center(
                    child: Transform.translate(
                      offset: const Offset(13.5, 7.25),
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
            },
          ),
        );
        await tester.pumpAndSettle();
        final controls = find.byType(MapCanvasControls);
        expect(
          find.descendant(of: controls, matching: find.byType(AppGlassBatch)),
          findsOneWidget,
        );
        final bounds = tester.getRect(controls);
        final l10n = tester.element(controls).l10n;
        final labels = [
          l10n.mapZoomIn,
          l10n.mapZoomOut,
          l10n.mapFitFloorPlan,
          l10n.mapRotatePlan,
          l10n.mapVolumeView,
        ];
        final initialButtons = [
          for (final label in labels) tester.getRect(find.byTooltip(label)),
        ];
        for (final next in [false, true]) {
          update(() => enabled = next);
          await tester.pumpAndSettle();
          expect(tester.getRect(controls), bounds);
          for (var index = 0; index < labels.length; index++) {
            final button = find.byTooltip(labels[index]);
            expect(tester.getRect(button), initialButtons[index]);
            expect(button.hitTestable(), findsOneWidget);
            await tester.tap(button);
            await tester.pumpAndSettle();
          }
        }
        expect(calls, [
          for (var attempt = 0; attempt < 2; attempt++) ...[
            'in',
            'out',
            'fit',
            'rotate',
            '3d',
          ],
        ]);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
