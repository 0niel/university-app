import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/widgets/ninja_geo_sharing_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import 'mock_friends_map_cubit.dart';

void main() {
  testWidgets('shows a retryable warning when privacy sync fails', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState(privacySyncFailed: true);
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(_app(cubit));

    expect(find.byType(NinjaBanner), findsOneWidget);
    expect(find.text('Ошибка'), findsOneWidget);
    expect(find.textContaining('Сервер не подтвердил'), findsOneWidget);
    expect(find.textContaining('Повторить'), findsOneWidget);
  });

  testWidgets('disables manual ghost mode when sharing is off', (tester) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState(
      isGhost: true,
      geoSettings: GeoSharingSettings(sharing: false),
    );
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(_app(cubit));

    final disabledSwitches = tester
        .widgetList<NinjaSwitch>(find.byType(NinjaSwitch))
        .where((widget) => widget.onChanged == null);
    expect(disabledSwitches, hasLength(1));
  });

  testWidgets('visibility and precision are pill segmented controls', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState();
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(_app(cubit));

    expect(find.byType(NinjaSegmented<GeoVisibility>), findsOneWidget);
    expect(find.byType(NinjaSegmented<GeoPrecision>), findsOneWidget);
    expect(find.text('Все друзья'), findsOneWidget);
    expect(find.text('Никто'), findsOneWidget);
    expect(find.text('тебя нет на карте'), findsNothing);
  });

  testWidgets('hiding from everyone explains itself with helper text', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState(
      geoSettings: GeoSharingSettings(visibility: GeoVisibility.none),
    );
    when(() => cubit.state).thenReturn(state);

    await tester.pumpWidget(_app(cubit));

    expect(find.text('тебя нет на карте'), findsOneWidget);
  });
}

Widget _app(FriendsMapCubit cubit) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider.value(
        value: cubit,
        child: const SingleChildScrollView(child: NinjaGeoSharingSheet()),
      ),
    ),
  );
}
