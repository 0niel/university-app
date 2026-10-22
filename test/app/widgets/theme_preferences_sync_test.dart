import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/app/theme/app_color_schemes.dart';
import 'package:rtu_mirea_app/app/theme/cubit/theme_cubit.dart';
import 'package:rtu_mirea_app/app/widgets/theme_preferences_sync.dart';

class _Storage extends Mock implements Storage {}

class _Gamification extends Mock implements GamificationRepository {}

class _Preferences extends Mock implements PreferencesRepository {}

void main() {
  late _Gamification repository;
  late _Preferences preferences;
  late ThemeCubit theme;
  late Completer<UserSettings> pending;
  late String? currentUserId;

  void initialize() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    repository = _Gamification();
    preferences = _Preferences();
    currentUserId = 'one';
    when(() => preferences.currentUserId).thenAnswer((_) => currentUserId);
    pending = Completer<UserSettings>();
    when(repository.getSettings).thenAnswer((_) => pending.future);
    theme = ThemeCubit();
    addTearDown(theme.close);
  }

  Widget app({String userId = 'one'}) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<GamificationRepository>.value(value: repository),
      RepositoryProvider<PreferencesRepository>.value(value: preferences),
    ],
    child: BlocProvider<ThemeCubit>.value(
      value: theme,
      child: ThemePreferencesSync(
        userId: userId,
        child: const SizedBox(key: ValueKey('schedule')),
      ),
    ),
  );

  testWidgets('restores an account accent without opening its profile', (
    tester,
  ) async {
    initialize();
    await tester.pumpWidget(app());
    expect(find.byKey(const ValueKey('schedule')), findsOneWidget);
    pending.complete(const UserSettings(accentColor: 'violet'));
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.violet);
    verify(repository.getSettings).called(1);
    verifyNoMoreInteractions(repository);
  });

  testWidgets('keeps the hydrated appearance until settings arrive', (
    tester,
  ) async {
    initialize();
    theme
      ..setColorScheme(AppColorScheme.red)
      ..setGlassEnabled(enabled: false);
    await tester.pumpWidget(app());
    expect(theme.state.colorScheme, AppColorScheme.red);
    expect(theme.state.glassEnabled, isFalse);

    pending.complete(const UserSettings(accentColor: 'green'));
    await tester.pump();
    expect(theme.state.colorScheme, AppColorScheme.green);
    expect(theme.state.glassEnabled, isFalse);
  });

  testWidgets('an offline settings request preserves the saved appearance', (
    tester,
  ) async {
    initialize();
    theme.setColorScheme(AppColorScheme.red);
    await tester.pumpWidget(app());
    pending.completeError(Exception('offline'), StackTrace.current);
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.red);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an unknown remote accent preserves the saved appearance', (
    tester,
  ) async {
    initialize();
    theme.setColorScheme(AppColorScheme.red);
    await tester.pumpWidget(app());
    pending.complete(const UserSettings(accentColor: 'unknown'));
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.red);
  });

  for (final userId in ['', 'other']) {
    testWidgets('does not request settings outside its session: $userId', (
      tester,
    ) async {
      initialize();
      await tester.pumpWidget(app(userId: userId));
      verifyNever(repository.getSettings);
    });
  }

  testWidgets('ignores an old session response before the tree rebuilds', (
    tester,
  ) async {
    initialize();
    await tester.pumpWidget(app());
    currentUserId = 'two';
    pending.complete(const UserSettings(accentColor: 'red'));
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.blue);
  });

  testWidgets(
    'account changes request their own settings and ignore old data',
    (
      tester,
    ) async {
      initialize();
      await tester.pumpWidget(app());
      final oldRequest = pending;
      pending = Completer<UserSettings>();
      currentUserId = 'two';
      await tester.pumpWidget(app(userId: 'two'));
      pending.complete(const UserSettings(accentColor: 'violet'));
      await tester.pump();
      oldRequest.complete(const UserSettings(accentColor: 'red'));
      await tester.pump();

      expect(theme.state.colorScheme, AppColorScheme.violet);
      verify(repository.getSettings).called(2);
    },
  );

  testWidgets('returning to an account cannot revive its earlier request', (
    tester,
  ) async {
    initialize();
    await tester.pumpWidget(app());
    final oldRequest = pending;
    pending = Completer<UserSettings>();
    final otherRequest = pending;
    currentUserId = 'two';
    await tester.pumpWidget(app(userId: 'two'));
    pending = Completer<UserSettings>();
    currentUserId = 'one';
    await tester.pumpWidget(app());
    oldRequest.complete(const UserSettings(accentColor: 'red'));
    otherRequest.complete(const UserSettings(accentColor: 'green'));
    await tester.pump();
    expect(theme.state.colorScheme, AppColorScheme.blue);

    pending.complete(const UserSettings(accentColor: 'violet'));
    await tester.pump();
    expect(theme.state.colorScheme, AppColorScheme.violet);
  });

  for (final scheme in [AppColorScheme.red, AppColorScheme.blue]) {
    testWidgets('a local $scheme choice wins over a pending restore', (
      tester,
    ) async {
      initialize();
      await tester.pumpWidget(app());
      theme.setColorScheme(scheme);
      pending.complete(const UserSettings(accentColor: 'violet'));
      await tester.pump();

      expect(theme.state.colorScheme, scheme);
    });
  }

  testWidgets('returning to the previous accent still preserves local intent', (
    tester,
  ) async {
    initialize();
    await tester.pumpWidget(app());
    theme
      ..setColorScheme(AppColorScheme.red)
      ..setColorScheme(AppColorScheme.blue);
    pending.complete(const UserSettings(accentColor: 'violet'));
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.blue);
  });

  testWidgets(
    'an independent glass choice does not cancel accent restoration',
    (
      tester,
    ) async {
      initialize();
      await tester.pumpWidget(app());
      theme.setGlassEnabled(enabled: false);
      pending.complete(const UserSettings(accentColor: 'violet'));
      await tester.pump();

      expect(theme.state.colorScheme, AppColorScheme.violet);
      expect(theme.state.glassEnabled, isFalse);
    },
  );

  testWidgets('a response after disposal cannot change the global theme', (
    tester,
  ) async {
    initialize();
    await tester.pumpWidget(app());
    await tester.pumpWidget(const SizedBox());
    pending.complete(const UserSettings(accentColor: 'red'));
    await tester.pump();

    expect(theme.state.colorScheme, AppColorScheme.blue);
    expect(tester.takeException(), isNull);
  });
}
