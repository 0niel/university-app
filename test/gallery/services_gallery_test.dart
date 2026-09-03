@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/widgets/app_bottom_navigation_bar.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/services/cubit/cubit.dart';
import 'package:rtu_mirea_app/services/view/services_view.dart';

import 'gallery_fonts.dart';

class _Catalog extends MockCubit<ServiceCatalogState>
    implements ServiceCatalogCubit {}

class _Favorites extends MockCubit<FavoriteServicesState>
    implements FavoriteServicesCubit {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class _Pass extends MockCubit<NfcPassState> implements NfcPassCubit {}

class _Hce extends MockCubit<NfcHceState> implements NfcHceCubit {}

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('actual services at 390x844 ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final catalog = _Catalog();
      final favorites = _Favorites();
      final schedule = _Schedule();
      final pass = _Pass();
      final hce = _Hce();
      when(() => catalog.state).thenReturn(const ServiceCatalogState());
      when(
        () => catalog.load(locale: any(named: 'locale')),
      ).thenAnswer((_) async {});
      when(() => favorites.state).thenReturn(FavoriteServicesState());
      when(() => schedule.state).thenReturn(const ScheduleState());
      when(() => pass.state).thenReturn(
        const NfcPassState(status: NfcPassStatus.bound, passId: 2411837),
      );
      when(() => hce.state).thenReturn(
        const NfcHceState(loaded: true, available: true),
      );
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RepositoryProvider.value(
            value: const UniversityConfig(
              organizationId: 'test',
              appName: 'Университет',
              universityName: 'Университет',
              universityShortName: 'Университет',
              websiteUrl: 'https://example.test',
              supportEmail: 'support@example.test',
              deepLinkScheme: 'university',
              webAppHost: 'app.example.test',
              webAppPathPrefix: '/app',
              enabledCapabilities: {.campusMap, .nfcPass},
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ServiceCatalogCubit>.value(value: catalog),
                BlocProvider<FavoriteServicesCubit>.value(value: favorites),
                BlocProvider<ScheduleBloc>.value(value: schedule),
                BlocProvider<NfcPassCubit>.value(value: pass),
                BlocProvider<NfcHceCubit>.value(value: hce),
              ],
              child: Builder(
                builder: (context) => Scaffold(
                  backgroundColor: context.colors.canvas,
                  body: Stack(
                    children: [
                      const ServicesView(),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AppBottomNavigationBar(
                          currentIndex: 3,
                          onSelected: (_) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/services_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
