@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'gallery_fonts.dart';
import 'home_dashboard_fixture.dart';

void main() {
  setUpAll(loadGalleryFonts);
  testWidgets(
    'reported 384px dark dashboard preserves compact header and long content',
    (tester) async {
      tester.view
        ..physicalSize = const Size(384, 832)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final selected = DateTime(2026, 9, 4);
      const subject = 'Управление информационно-технологическими проектами';
      final lessons = [
        for (final (index, name) in [
          subject,
          'Вторая пара',
          'Третья пара',
        ].indexed)
          LessonSchedulePart(
            subject: name,
            lessonType: LessonType.practice,
            teachers: const [Teacher(name: 'Габриелян Гайк Ашотович')],
            classrooms: const [Classroom(name: 'И-202-а')],
            dates: [selected],
            lessonBells: LessonBells(
              startTime: TimeOfDay(hour: 12 + index * 2, minute: 40),
              endTime: TimeOfDay(hour: 14 + index * 2, minute: 10),
            ),
          ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: true,
              padding: const EdgeInsets.only(top: 24, bottom: 24),
            ),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              backgroundColor: context.colors.canvas,
              extendBody: true,
              body: AppBottomBarViewport(
                bottomInset: AppBottomBar.extentOf(context),
                child: homeDashboardFixture(
                  controller: controller,
                  clock: DateTime(2026, 9, 2, 20, 56),
                  selectedDay: selected,
                  scheduleOverride: lessons,
                  userName: 'Студент',
                ),
              ),
              bottomNavigationBar: AppBottomNavigationBar(
                currentIndex: 0,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(HomeTopRow)).height, 44);
      expect(
        tester.getCenter(find.byType(HomeClockPill)).dy,
        closeTo(tester.getCenter(find.byType(AppAvatar).first).dy, .1),
      );
      expect(
        tester
            .widgetList<HomeLessonRow>(find.byType(HomeLessonRow))
            .where((row) => row.entry.lesson.subject == subject),
        isEmpty,
      );
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/home_reported_384_dark.png'),
      );
    },
  );
}
