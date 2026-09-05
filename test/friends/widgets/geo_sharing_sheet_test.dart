import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_map_cubit.dart';
import 'package:rtu_mirea_app/friends/services/friends_location_service.dart';
import 'package:rtu_mirea_app/friends/widgets/ninja_geo_sharing_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import 'mock_friends_map_cubit.dart';

void main() {
  setUpAll(() => registerFallbackValue(const GeoSharingSettings()));

  testWidgets('permanently denied permission offers explicit retry', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    when(() => cubit.state).thenReturn(
      const FriendsMapState(
        locationPermissionDenied: true,
        locationStatus: FriendsLocationStatus.permissionDeniedForever,
      ),
    );
    when(cubit.retryLocation).thenAnswer((_) async {});

    await tester.pumpWidget(_app(cubit));
    await tester.ensureVisible(find.text('Разрешить геопозицию'));
    await tester.tap(find.text('Разрешить геопозицию'));

    verify(cubit.retryLocation).called(1);
    expect(find.text('Фоновое обновление включено'), findsNothing);
  });

  testWidgets('shows a retryable warning when privacy sync fails', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState(privacySyncFailed: true);
    when(() => cubit.state).thenReturn(state);
    when(cubit.retryPrivacy).thenAnswer((_) async {});

    await tester.pumpWidget(_app(cubit));

    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.text('Ошибка'), findsOneWidget);
    expect(find.textContaining('Сервер не подтвердил'), findsOneWidget);
    expect(find.textContaining('Повторить'), findsOneWidget);
    tester.widget<AppErrorState>(find.byType(AppErrorState)).onPrimary!();
    verify(cubit.retryPrivacy).called(1);
  });

  testWidgets('disables manual ghost mode when sharing is off', (tester) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState(
      isGhost: true,
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

    expect(find.byType(AppSegmentedControl<GeoVisibility>), findsOneWidget);
    expect(find.byType(AppSegmentedControl<GeoPrecision>), findsOneWidget);
    expect(find.text('Все друзья'), findsOneWidget);
    expect(find.text('Всем'), findsOneWidget);
    expect(find.text('Никто'), findsOneWidget);
    expect(find.text('тебя нет на карте'), findsNothing);
  });

  testWidgets('public audience is an explicit choice and keeps sharing off', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    when(() => cubit.state).thenReturn(const FriendsMapState());
    when(() => cubit.updateGeoSettings(any())).thenAnswer((_) async {});

    await tester.pumpWidget(_app(cubit));
    await tester.tap(find.text('Всем'));

    verify(
      () => cubit.updateGeoSettings(
        const GeoSharingSettings(visibility: GeoVisibility.students),
      ),
    ).called(1);
  });

  testWidgets('public audience explains who can view and how to stop', (
    tester,
  ) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    when(() => cubit.state).thenReturn(
      const FriendsMapState(
        geoSettings: GeoSharingSettings(visibility: GeoVisibility.students),
      ),
    );

    await tester.pumpWidget(_app(cubit));

    expect(find.textContaining('без добавления в друзья'), findsOneWidget);
    expect(find.textContaining('пока не скроешь'), findsOneWidget);
    expect(find.text('Фоновое обновление включено'), findsNothing);
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

  testWidgets('the full sharing row toggles its setting', (tester) async {
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    const state = FriendsMapState();
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.updateGeoSettings(any())).thenAnswer((_) async {});

    await tester.pumpWidget(_app(cubit));
    await tester.tap(find.text('Делиться геопозицией'));

    verify(
      () => cubit.updateGeoSettings(
        const GeoSharingSettings(sharing: true),
      ),
    ).called(1);
  });

  testWidgets('settings remain usable with large text on a compact screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final cubit = MockFriendsMapCubit();
    addTearDown(cubit.close);
    when(() => cubit.state).thenReturn(const FriendsMapState());

    await tester.pumpWidget(
      _app(cubit, textScaler: const TextScaler.linear(2)),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Точно'), findsOneWidget);
    expect(find.text('Корпус'), findsOneWidget);
    expect(find.text('Город'), findsOneWidget);
  });
}

Widget _app(FriendsMapCubit cubit, {TextScaler? textScaler}) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: textScaler == null
        ? null
        : (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
    home: Scaffold(
      body: BlocProvider.value(
        value: cubit,
        child: const SingleChildScrollView(child: NinjaGeoSharingSheet()),
      ),
    ),
  );
}
