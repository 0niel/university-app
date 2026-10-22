import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/profile_page.dart';

class _Storage extends Mock implements Storage {}

class _Profile extends MockCubit<ProfileState> implements ProfileCubit {}

void main() {
  testWidgets('a late profile snapshot cannot overwrite the chosen accent', (
    tester,
  ) async {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    final theme = ThemeCubit()..setColorScheme(AppColorScheme.red);
    final profile = _Profile();
    final states = StreamController<ProfileState>();
    const initial = ProfileState(status: ProfileStatus.error);
    whenListen(profile, states.stream, initialState: initial);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      await states.close();
      await profile.close();
      await theme.close();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: theme),
          BlocProvider<ProfileCubit>.value(value: profile),
        ],
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfileView(),
        ),
      ),
    );
    await tester.pump();
    states.add(
      initial.copyWith(settings: const UserSettings(accentColor: 'violet')),
    );
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.red);
    expect(tester.takeException(), isNull);
  });
}
