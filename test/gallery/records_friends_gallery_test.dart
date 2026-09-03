@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/friends/view/friends_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:user_repository/user_repository.dart';

import '../profile/helpers/profile_test_environment.dart';
import 'gallery_fonts.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    testWidgets('friends reference ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final environment = ProfileTestEnvironment();
      final app = _App();
      addTearDown(app.close);
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'me'),
        ),
      );
      final now = DateTime.now();
      when(environment.friends.getFriends).thenAnswer(
        (_) async => [
          for (final (i, name) in [
            'Аня Козлова',
            'Миша Волков',
            'Даша Петрова',
            'Саша Орлов',
            'Никита Белый',
          ].indexed)
            Friend(
              friendshipId: '$i',
              userId: 'friend-$i',
              fullName: name,
              group: 'ИКБО-01-24',
              latitude: i < 3 ? 55.67 : null,
              longitude: i < 3 ? 37.48 : null,
              isGhost: i == 4,
              locationUpdatedAt: i < 3 ? now : null,
            ),
        ],
      );
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        environment.wrap(
          child: BlocProvider<AppBloc>.value(
            value: app,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(disableAnimations: true),
                child: child!,
              ),
              home: const FriendsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/friends_${dark ? 'dark' : 'light'}.png',
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
