@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_submit_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_apps_catalog_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_submit_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_apps_page.dart';

import 'gallery_fonts.dart';

class _Catalog extends MockCubit<MiniAppsCatalogState>
    implements MiniAppsCatalogCubit {}

class _Submit extends MockCubit<MiniAppSubmitState>
    implements MiniAppSubmitCubit {}

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final submit in [false, true]) {
      testWidgets('mini apps ${submit ? 'submit' : 'catalog'} dark=$dark', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(390, 844)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final catalog = _Catalog();
        final submission = _Submit();
        when(() => submission.state).thenReturn(const MiniAppSubmitState());
        when(() => catalog.state).thenReturn(
          const MiniAppsCatalogState(
            status: .populated,
            apps: [
              MiniApp(
                id: 'rooms',
                slug: 'rooms',
                name: 'Свободная аудитория',
                description: 'Найди место для учёбы между парами',
                iconEmoji: '🚪',
              ),
              MiniApp(
                id: 'study',
                slug: 'study',
                name: 'Учимся вместе',
                description: 'Карточки, заметки и подготовка к экзаменам',
                iconEmoji: '📚',
              ),
              MiniApp(
                id: 'lunch',
                slug: 'lunch',
                name: 'Что на обед?',
                description: 'Меню и любимые блюда рядом с кампусом',
                iconEmoji: '🥗',
              ),
            ],
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: submit
                ? BlocProvider<MiniAppSubmitCubit>.value(
                    value: submission,
                    child: const MiniAppSubmitView(),
                  )
                : BlocProvider<MiniAppsCatalogCubit>.value(
                    value: catalog,
                    child: const MiniAppsView(),
                  ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/mini_apps_${submit ? 'submit' : 'catalog'}_${dark ? 'dark' : 'light'}.png',
          ),
        );
      });
    }
  }
}
