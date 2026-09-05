import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/notifications_toggle_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';

class _Profile extends MockCubit<ProfileState> implements ProfileCubit {}

class _Notifications extends Mock implements LocalNotificationsRepository {}

void main() {
  late _Profile profile;
  late _Notifications notifications;

  setUpAll(() => registerFallbackValue(const UserSettings()));

  setUp(() {
    profile = _Profile();
    notifications = _Notifications();
    when(() => profile.state).thenReturn(const ProfileState());
    when(() => profile.isClosed).thenReturn(false);
    when(() => profile.updateSettings(any())).thenAnswer((_) async {});
    when(notifications.hasPermission).thenAnswer((_) async => false);
    when(notifications.ensurePermission).thenAnswer((_) async => false);
  });

  Widget app() => RepositoryProvider<LocalNotificationsRepository>.value(
    value: notifications,
    child: BlocProvider<ProfileCubit>.value(
      value: profile,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NinjaToastHost(
          child: Scaffold(
            body: NotificationsToggleRow(label: 'Push notifications'),
          ),
        ),
      ),
    ),
  );

  SettingsToggleRow toggle(WidgetTester tester) =>
      tester.widget<SettingsToggleRow>(find.byType(SettingsToggleRow));

  testWidgets('blocked device does not show an enabled cloud setting as on', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(toggle(tester).value, isFalse);
    verifyNever(() => profile.updateSettings(any()));
    verifyNever(notifications.ensurePermission);
  });

  testWidgets('returning from system settings refreshes device permission', (
    tester,
  ) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    when(notifications.hasPermission).thenAnswer((_) async => true);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(toggle(tester).value, isTrue);
    when(notifications.hasPermission).thenAnswer((_) async => false);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(toggle(tester).value, isFalse);
    verifyNever(() => profile.updateSettings(any()));
  });

  testWidgets(
    'enabling requests permission without overwriting denied settings',
    (
      tester,
    ) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      toggle(tester).onChanged!(true);
      await tester.pumpAndSettle();
      verify(notifications.ensurePermission).called(1);
      verifyNever(() => profile.updateSettings(any()));
      expect(toggle(tester).value, isFalse);
    },
  );

  testWidgets('granting permission enables notifications', (tester) async {
    when(notifications.ensurePermission).thenAnswer((_) async => true);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    toggle(tester).onChanged!(true);
    await tester.pumpAndSettle();
    expect(toggle(tester).value, isTrue);
    verify(
      () => profile.updateSettings(
        const UserSettings(),
      ),
    ).called(1);
  });

  testWidgets('permission lookup finishing after disposal is harmless', (
    tester,
  ) async {
    final permission = Completer<bool>();
    when(notifications.hasPermission).thenAnswer((_) => permission.future);
    await tester.pumpWidget(app());
    expect(toggle(tester).onChanged, isNull);
    await tester.pumpWidget(const SizedBox());
    permission.complete(true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
