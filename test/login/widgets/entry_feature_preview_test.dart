import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/auth_page_layout.dart';
import 'package:rtu_mirea_app/login/widgets/entry_campus_preview.dart';
import 'package:rtu_mirea_app/login/widgets/entry_feature_preview.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_top_bar.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_strip.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_view.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header.dart';
import 'package:rtu_mirea_app/services/view/widgets/service_row.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(EntryCampusPreview.preload);

  for (final dark in [false, true]) {
    for (final feature in EntryFeature.values) {
      testWidgets('$feature uses real UI at 320px, dark=$dark', (tester) async {
        tester.view
          ..physicalSize = const Size(320, 568)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        AppColors? nativeColors;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
                disableAnimations: true,
              ),
              child: child!,
            ),
            home: Scaffold(
              body: AuthPageLayout(
                title: 'В твоём ритме',
                showBack: false,
                visual: Builder(
                  builder: (context) {
                    nativeColors = context.colors;
                    return EntryFeaturePreview(feature: feature);
                  },
                ),
                actions: AppButton.primary(
                  key: const Key('continue'),
                  label: 'Продолжить',
                  onPressed: () {},
                ),
                child: const SizedBox.shrink(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          nativeColors?.accent,
          (dark ? AppColors.dark : AppColors.light).accent,
        );
        switch (feature) {
          case EntryFeature.schedule:
            expect(find.byType(ScheduleHeader), findsOneWidget);
            expect(find.byType(ScheduleDayStrip), findsOneWidget);
            expect(find.byType(ScheduleTimelineLesson), findsNWidgets(2));
          case EntryFeature.campus:
            expect(find.byType(MapTopBar), findsOneWidget);
            final canvas = tester.widget<MapFloorCanvas>(
              find.byType(MapFloorCanvas),
            );
            expect(canvas.rooms.length, greaterThan(200));
            expect(canvas.rooms.any((room) => room.name == 'А-125'), isTrue);
            expect(canvas.showRoomLabels, isTrue);
          case EntryFeature.community:
            expect(find.byType(ServiceRow), findsNWidgets(4));
            expect(find.text('Сообщества'), findsOneWidget);
        }
        await tester.scrollUntilVisible(
          find.byKey(const Key('continue')),
          120,
          scrollable: find
              .byWidgetPredicate(
                (widget) =>
                    widget is Scrollable &&
                    widget.axisDirection == AxisDirection.down,
              )
              .first,
        );
        await tester.tap(find.byKey(const Key('continue')));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
