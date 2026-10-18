import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_plan.dart';
import 'package:rtu_mirea_app/map/widgets/map_skeleton.dart';

void main() {
  for (final locale in const [Locale('ru'), Locale('en')]) {
    for (final size in [const Size(320, 420), const Size(640, 320)]) {
      for (final textScale in [1.0, 2.0]) {
        testWidgets(
          'loading plan fits $size at ${textScale}x text '
          'in ${locale.languageCode}',
          (
            tester,
          ) async {
            tester.view
              ..physicalSize = size
              ..devicePixelRatio = 1;
            addTearDown(tester.view.reset);
            await tester.pumpWidget(
              MaterialApp(
                theme: AppTheme.lightTheme,
                locale: locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
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
            expect(find.byType(AppSkeletonRow), findsNothing);
            final message = locale.languageCode == 'ru'
                ? 'Загружаем план кампуса'
                : 'Loading campus plan';
            expect(
              find.bySemanticsLabel(message),
              findsOneWidget,
            );
            final label = tester.getRect(find.text(message));
            expect(label.top, greaterThanOrEqualTo(36));
            expect(label.bottom, lessThanOrEqualTo(size.height - 104));
          },
        );
      }
    }
  }
}
