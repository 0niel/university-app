import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_plan.dart';
import 'package:rtu_mirea_app/map/widgets/map_skeleton.dart';

void main() {
  for (final dark in [false, true]) {
    for (final locale in const [Locale('ru'), Locale('en')]) {
      for (final size in [
        const Size(320, 420),
        const Size(640, 320),
        const Size(640, 240),
      ]) {
        for (final textScale in [1.0, 2.0]) {
          testWidgets(
            'map loading fits $size at ${textScale}x text '
            'in ${locale.languageCode}, dark: $dark',
            (tester) async {
              tester.view
                ..physicalSize = size
                ..devicePixelRatio = 1;
              addTearDown(tester.view.reset);
              await tester.pumpWidget(
                MaterialApp(
                  theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
                  locale: locale,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: MediaQuery(
                    data: MediaQueryData(
                      size: size,
                      padding: const EdgeInsets.only(top: 36),
                      textScaler: TextScaler.linear(textScale),
                      disableAnimations: true,
                    ),
                    child: const AppBottomBarViewport(
                      bottomInset: 104,
                      child: MapSkeleton(),
                    ),
                  ),
                ),
              );
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull);
              expect(find.byType(MapLoadingPlan), findsOneWidget);
              expect(find.byType(AppSpinner), findsOneWidget);
              expect(find.byType(NinjaSkeleton), findsNothing);
              expect(find.byType(NinjaSkeletonGroup), findsNothing);
              final message = locale.languageCode == 'ru'
                  ? 'Загружаем план кампуса'
                  : 'Loading campus plan';
              final status = find.bySemanticsLabel(message);
              expect(status, findsOneWidget);
              expect(
                tester.getSemantics(status).flagsCollection.isLiveRegion,
                isTrue,
              );
              final label = tester.getRect(find.text(message));
              expect(label.top, greaterThanOrEqualTo(36));
              expect(label.bottom, lessThanOrEqualTo(size.height - 104));
              expect(label.left, greaterThanOrEqualTo(16));
              expect(label.right, lessThanOrEqualTo(size.width - 16));
              final canvas = tester.widget<ColoredBox>(
                find
                    .descendant(
                      of: find.byType(MapSkeleton),
                      matching: find.byType(ColoredBox),
                    )
                    .first,
              );
              expect(
                canvas.color,
                dark ? AppColors.mapCanvasDark : AppColors.mapCanvasLight,
              );
              expect(tester.binding.transientCallbackCount, 0);
            },
          );
        }
      }
    }
  }
}
