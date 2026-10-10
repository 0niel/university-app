@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../gallery/gallery_fonts.dart';

class _Repository extends Mock implements ScheduleRepository {}

enum _Scene { selected, empty, failure, narrow, keyboard, disabled }

void main() {
  setUpAll(loadGalleryFonts);
  for (final scene in _Scene.values) {
    testWidgets('teacher picker ${scene.name} design reference', (
      tester,
    ) async {
      final repository = _Repository();
      const teacher = Teacher(
        name: 'Александровский Александр Александрович',
        uid: 'schedule-teacher-01',
      );
      const duplicate = Teacher(
        name: 'Александровский Александр Александрович',
        uid: 'schedule-teacher-02',
      );
      when(
        () => repository.searchTeachers(query: any(named: 'query')),
      ).thenAnswer((_) async {
        if (scene == _Scene.failure) throw Exception('offline');
        return SearchTeachersResponse(
          results: scene == _Scene.empty
              ? const []
              : const [
                  teacher,
                  duplicate,
                  Teacher(name: 'Иванов Иван Иванович', uid: 'ivanov'),
                ],
        );
      });
      final narrow = scene == _Scene.narrow || scene == _Scene.keyboard;
      final dark = scene == _Scene.failure || scene == _Scene.disabled;
      tester.view
        ..physicalSize = Size(narrow ? 320 : 390, 780)
        ..devicePixelRatio = 1;
      if (scene == _Scene.keyboard) {
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      }
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        RepositoryProvider<ScheduleRepository>.value(
          value: repository,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(narrow ? 1.6 : 1),
                disableAnimations: true,
              ),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: TeacherPicker(
                  selected: scene == _Scene.empty || scene == _Scene.failure
                      ? null
                      : teacher,
                  enabled: scene != _Scene.disabled,
                  onSelected: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (scene == _Scene.keyboard) {
        expect(
          tester
              .getSize(find.byKey(const ValueKey('teacher-picker-results')))
              .height,
          lessThanOrEqualTo(240),
        );
      }
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/teacher_picker_${scene.name}.png'),
      );
    });
  }
}
