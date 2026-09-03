@Tags(['gallery'])
library;

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/room_model.dart';
import 'package:rtu_mirea_app/map/widgets/map_room_sheet.dart';

import 'gallery_fonts.dart';

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    for (final known in [false, true]) {
      testWidgets(
        'room sheet ${known ? 'free' : 'unknown'} ${dark ? 'dark' : 'light'}',
        (tester) async {
          tester.view
            ..physicalSize = const Size(390, 844)
            ..devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  backgroundColor: context.colors.canvas,
                  body: Center(
                    child: AppButton.primary(
                      label: 'Открыть',
                      onPressed: () {
                        if (known) {
                          unawaited(
                            showFreeRoomSheet(
                              context,
                              FreeRoomViewModel(
                                room: const FreeRoom(
                                  room: 'А-101',
                                  campus: 'В-78',
                                ),
                                now: DateTime(2026, 9, 2, 12),
                                floor: 1,
                              ),
                              onRoute: () {},
                            ),
                          );
                        } else {
                          unawaited(
                            showAppSheet<void>(
                              context,
                              child: MapRoomSheet(
                                room: RoomModel(
                                  roomId: 'А-101',
                                  path: Path(),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text('Открыть'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              'goldens/room_${known ? 'free' : 'unknown'}_${dark ? 'dark' : 'light'}.png',
            ),
          );
          await tester.pumpWidget(const SizedBox());
        },
      );
    }
  }
}
