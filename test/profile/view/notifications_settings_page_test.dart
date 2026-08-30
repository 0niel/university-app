import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/notifications_settings_page.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  late ProfileCubit cubit;

  setUpAll(() {
    registerFallbackValue(const UserSettings());
  });

  setUp(() {
    cubit = _MockProfileCubit();
    when(() => cubit.updateSettings(any())).thenAnswer((_) async {});
  });

  Widget subject(UserSettings settings) {
    when(() => cubit.state).thenReturn(ProfileState(settings: settings));
    return BlocProvider<ProfileCubit>.value(
      value: cubit,
      child: MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NotificationsSettingsPage(),
      ),
    );
  }

  List<NinjaSwitch> toggles(WidgetTester tester) =>
      tester.widgetList<NinjaSwitch>(find.byType(NinjaSwitch)).toList();

  testWidgets('children follow the master switch when it is on', (
    tester,
  ) async {
    await tester.pumpWidget(subject(const UserSettings()));
    await tester.pumpAndSettle();

    final rows = toggles(tester);
    expect(rows, hasLength(5));
    expect(rows.every((toggle) => toggle.onChanged != null), isTrue);
    expect(rows.first.value, isTrue);
  });

  testWidgets('children go inert and off while the master is off', (
    tester,
  ) async {
    await tester.pumpWidget(
      subject(const UserSettings(notificationsEnabled: false)),
    );
    await tester.pumpAndSettle();

    final rows = toggles(tester);
    expect(rows.first.onChanged, isNotNull);
    expect(rows.skip(1).every((toggle) => toggle.onChanged == null), isTrue);
    expect(rows.skip(1).every((toggle) => !toggle.value), isTrue);
  });

  testWidgets('a child toggle persists only its own field', (tester) async {
    await tester.pumpWidget(subject(const UserSettings()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NinjaSwitch).last);
    await tester.pumpAndSettle();

    verify(
      () => cubit.updateSettings(
        const UserSettings(leaderboardUpdates: true),
      ),
    ).called(1);
  });
}
