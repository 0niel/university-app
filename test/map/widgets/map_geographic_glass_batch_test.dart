import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:app_ui/src/widgets/app_control_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_geographic_view.dart';

void main() {
  for (final scale in [.98, 1.05]) {
    testWidgets(
      '49 content annotations retain hits without GPU layers at scale $scale',
      (tester) async {
        const ratio = 3.0;
        tester.view
          ..physicalSize = Size(AppScale.designWidth * scale * ratio, 2700)
          ..devicePixelRatio = ratio;
        addTearDown(tester.view.reset);
        final taps = <int>[];
        final places = [
          for (var index = 0; index < 49; index++)
            GeographicMapPlace(
              label: 'Place $index',
              position: LatLng(
                55.661 + (index ~/ 7 - 3) * .0006,
                37.477 + (index % 7 - 3) * .001,
              ),
              onTap: () => taps.add(index),
            ),
        ];
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.generateTheme(
              AppColors.dark,
              Brightness.dark,
            ),
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (_, child) => AppScale(child: child!),
            home: MapGeographicView(
              campusName: 'В-86',
              center: const LatLng(55.661, 37.477),
              places: places,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final markers = find.byType(MarkerLayer);
        expect(markers, findsOneWidget);
        expect(find.byTooltip('В-86'), findsOneWidget);
        final lenses = find.descendant(
          of: markers,
          matching: find.byType(AppGlassRenderer),
        );
        expect(lenses, findsNothing);
        final layers = find.descendant(
          of: markers,
          matching: find.byWidgetPredicate(
            (widget) => widget.runtimeType.toString() == 'LiquidGlassLayer',
          ),
        );
        expect(layers, findsNothing);
        expect(
          find.descendant(
            of: find.byType(AppInnerHeader),
            matching: find.byType(AppGlassRenderer),
          ),
          findsOneWidget,
        );
        final recenter = find.byWidgetPredicate(
          (widget) =>
              widget is AppIconButton &&
              widget.tooltip == tester.element(markers).l10n.mapShowCampus,
        );
        expect(
          find.descendant(
            of: recenter,
            matching: find.byType(AppGlassRenderer),
          ),
          findsOneWidget,
        );
        for (var index = 0; index < places.length; index++) {
          final button = find.byWidgetPredicate(
            (widget) =>
                widget is AppIconButton && widget.tooltip == 'Place $index',
          );
          expect(button.hitTestable(), findsOneWidget);
          expect(tester.getRect(button).width, closeTo(44 * scale, .001));
          final surface = find.descendant(
            of: button,
            matching: find.byType(AppControlSurface),
          );
          expect(tester.getRect(surface).width, closeTo(36 * scale, .001));
          expect(
            tester.widget<AppControlSurface>(surface).borderRadius,
            18,
          );
          await tester.tap(button);
          await tester.pumpAndSettle();
        }
        expect(taps, List.generate(49, (index) => index));
        MapController.of(tester.element(markers.first))
          ..move(const LatLng(55.6612, 37.4772), 16)
          ..rotate(17);
        await tester.pumpAndSettle();
        for (final index in [16, 24, 32]) {
          final button = find.byWidgetPredicate(
            (widget) =>
                widget is AppIconButton && widget.tooltip == 'Place $index',
          );
          expect(button.hitTestable(), findsOneWidget);
          await tester.tap(button);
          await tester.pumpAndSettle();
        }
        expect(taps.skip(49), [16, 24, 32]);
        expect(layers, findsNothing);
        expect(lenses, findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
      variant: TargetPlatformVariant.only(TargetPlatform.android),
    );
  }
}
