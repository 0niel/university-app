import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/view/add_schedule_page.dart';
import 'package:rtu_mirea_app/schedule_management/view/edit_schedules_page.dart';
import 'package:rtu_mirea_app/schedule_management/view/schedule_management_page.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_view.dart';
import 'package:rtu_mirea_app/search/widgets/search_mode_select.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../gallery/gallery_fonts.dart';

class _ScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _SearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  setUpAll(loadGalleryFonts);

  for (final page in ['hub', 'edit', 'add', 'search']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('$page header spacing remains usable at ${scale * 100}%', (
        tester,
      ) async {
        final size = scale == 1 ? const Size(390, 844) : const Size(320, 568);
        tester.view
          ..physicalSize = size
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final schedules = _ScheduleBloc();
        final search = _SearchBloc();
        when(() => schedules.state).thenReturn(
          const ScheduleState(
            status: ScheduleStatus.loaded,
            selectedSchedule: SelectedGroupSchedule(
              group: Group(name: 'ИКБО-10-23'),
              schedule: [],
            ),
          ),
        );
        when(() => search.state).thenReturn(const SearchState());
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale),
                padding: const EdgeInsets.only(top: 24),
                disableAnimations: true,
              ),
              child: child!,
            ),
            home: MultiBlocProvider(
              providers: [
                BlocProvider<ScheduleBloc>.value(value: schedules),
                BlocProvider<SearchBloc>.value(value: search),
              ],
              child: switch (page) {
                'hub' => const ScheduleManagementPage(),
                'edit' => const EditSchedulesPage(),
                'add' => const Scaffold(body: AddScheduleView()),
                _ => const Scaffold(body: SearchView()),
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final context = tester.element(find.byType(Scaffold).first);
        final l10n = context.l10n;
        if (page == 'search') {
          final field = tester.getRect(
            find.byKey(const Key('searchPage_searchTextField')),
          );
          final cancel = tester.getRect(
            find.widgetWithText(AppButton, l10n.cancel),
          );
          final tabs = tester.getRect(find.byType(SearchModeSelect));
          expect(
            tabs.top - math.max(field.bottom, cancel.bottom),
            closeTo(AppSpacing.lg, .01),
          );
        } else {
          final header = tester.getRect(find.byType(AppInnerHeader));
          final next = switch (page) {
            'hub' => find.text(l10n.scheduleHubPrimarySection),
            'edit' => find.text(l10n.editSchedulesHint),
            _ => find.byType(AppSegmentedControl<ScheduleTarget>),
          };
          expect(
            tester.getTopLeft(next).dy - header.bottom,
            closeTo(AppSpacing.xl, .01),
          );
        }
        if (const bool.fromEnvironment('CAPTURE_HEADER_GOLDENS')) {
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              '../../../build/reports/header_spacing_${page}_${scale.toInt()}.png',
            ),
          );
        }
        if (page == 'add' || page == 'search') {
          tester.view.viewInsets = const FakeViewPadding(bottom: 250);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await tester.ensureVisible(find.byType(TextField));
          await tester.pumpAndSettle();
          final field = tester.getRect(find.byType(TextField));
          expect(field.top, greaterThanOrEqualTo(0));
          expect(field.bottom, lessThanOrEqualTo(size.height - 250));
          await tester.enterText(find.byType(TextField), 'ИКБО');
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (const bool.fromEnvironment('CAPTURE_HEADER_GOLDENS')) {
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                '../../../build/reports/header_spacing_${page}_${scale.toInt()}_keyboard.png',
              ),
            );
          }
        }
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
