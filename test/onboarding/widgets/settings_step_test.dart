import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/widgets.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';

class _MockGamificationRepository extends Mock
    implements GamificationRepository {}

class _MockLocalNotificationsRepository extends Mock
    implements LocalNotificationsRepository {}

class _MockPermissionClient extends Mock implements PermissionClient {}

class _TestGeoSharingCubit extends Cubit<GeoSharingState>
    implements GeoSharingCubit {
  _TestGeoSharingCubit() : super(const GeoSharingState(loaded: true));
  bool fails = false;
  bool? requested;

  @override
  Future<void> load() async {}

  @override
  Future<bool> setSharing({required bool enabled}) async {
    requested = enabled;
    if (fails) return false;
    emit(state.copyWith(settings: state.settings.copyWith(sharing: enabled)));
    return true;
  }
}

void main() {
  setUp(ToastManager.debugReset);
  tearDown(ToastManager.debugReset);
  late _MockGamificationRepository gamification;
  late _MockLocalNotificationsRepository notifications;
  late _MockPermissionClient permissions;
  late _TestGeoSharingCubit sharing;
  late int finished;
  late int backs;

  setUpAll(() {
    registerFallbackValue(const UserSettings());
  });

  setUp(() {
    finished = 0;
    backs = 0;
    gamification = _MockGamificationRepository();
    notifications = _MockLocalNotificationsRepository();
    permissions = _MockPermissionClient();
    sharing = _TestGeoSharingCubit();
    addTearDown(sharing.close);
    when(
      () => gamification.getSettings(),
    ).thenAnswer((_) async => const UserSettings());
    when(
      () => gamification.updateSettings(
        any(),
        previous: any(named: 'previous'),
      ),
    ).thenAnswer((invocation) async {
      return invocation.positionalArguments.first as UserSettings;
    });
    when(() => notifications.hasPermission()).thenAnswer((_) async => false);
    when(() => notifications.ensurePermission()).thenAnswer((_) async => true);
    when(
      () => permissions.locationWhenInUseStatus(),
    ).thenAnswer((_) async => PermissionStatus.denied);
    when(
      () => permissions.requestLocationWhenInUse(),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(
      () => permissions.openPermissionSettings(),
    ).thenAnswer((_) async => true);
  });

  Future<void> pumpStep(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GamificationRepository>.value(
            value: gamification,
          ),
          RepositoryProvider<LocalNotificationsRepository>.value(
            value: notifications,
          ),
          RepositoryProvider<GeoSharingCubit>.value(value: sharing),
        ],
        child: MaterialApp(
          locale: const Locale('ru'),
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              accessibleNavigation: true,
              disableAnimations: true,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
          home: Scaffold(
            body: OnboardingSettingsStep(
              step: 3,
              totalSteps: 3,
              permissionClient: permissions,
              onBack: () => backs++,
              onFinish: () => finished++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  Finder switchIn(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(AppSwitch),
  );

  bool switchValue(WidgetTester tester, String key) =>
      tester.widget<AppSwitch>(switchIn(key)).value;

  testWidgets('renders toggles, theme segmented and done', (tester) async {
    await pumpStep(tester);

    expect(find.text('Пара настроек'), findsOneWidget);
    expect(find.text('Всё можно поменять позже.'), findsOneWidget);
    expect(find.text('Уведомления'), findsOneWidget);
    expect(find.text('Пары, дедлайны, изменения'), findsOneWidget);
    expect(find.text('Геолокация на кампусе'), findsOneWidget);
    expect(find.text('Показывать меня друзьям'), findsOneWidget);
    expect(find.text('Тема'), findsOneWidget);
    expect(find.text('Светлая'), findsOneWidget);
    expect(find.text('Тёмная'), findsOneWidget);
    expect(find.text('Готово'), findsOneWidget);
    expect(find.bySemanticsLabel('Шаг 3 из 3'), findsOneWidget);
    expect(switchValue(tester, 'onboarding_togglePush'), isFalse);
    expect(switchValue(tester, 'onboarding_toggleGeo'), isFalse);
    expect(switchValue(tester, 'onboarding_toggleFriends'), isFalse);
  });

  testWidgets('done and back call the callbacks', (tester) async {
    await pumpStep(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_finish')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_finish')));
    await tester.scrollUntilVisible(
      find.byType(AppBackButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppBackButton));
    await tester.pump();

    expect(finished, 1);
    expect(backs, 1);
  });

  testWidgets('geo toggle requests the location permission', (tester) async {
    await pumpStep(tester);
    await tester.tap(switchIn('onboarding_toggleGeo'));
    await tester.pump();
    await tester.pump();

    verify(() => permissions.requestLocationWhenInUse()).called(1);
    expect(switchValue(tester, 'onboarding_toggleGeo'), isTrue);
  });

  testWidgets('denied location shows a hint and stays off', (tester) async {
    when(
      () => permissions.requestLocationWhenInUse(),
    ).thenAnswer((_) async => PermissionStatus.permanentlyDenied);
    await pumpStep(tester);
    await tester.tap(switchIn('onboarding_toggleGeo'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(switchValue(tester, 'onboarding_toggleGeo'), isFalse);
    expect(
      find.text('Разрешите геолокацию в настройках системы'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('push toggle asks for notifications and persists', (
    tester,
  ) async {
    await pumpStep(tester);
    await tester.tap(switchIn('onboarding_togglePush'));
    await tester.pump();
    await tester.pump();

    verify(() => notifications.ensurePermission()).called(1);
    verify(
      () => gamification.updateSettings(
        any(
          that: isA<UserSettings>().having(
            (s) => s.notificationsEnabled,
            'notificationsEnabled',
            isTrue,
          ),
        ),
        previous: any(named: 'previous'),
      ),
    ).called(1);
    expect(switchValue(tester, 'onboarding_togglePush'), isTrue);
  });

  testWidgets(
    'friends toggle changes location sharing, not profile visibility',
    (tester) async {
      await pumpStep(tester);
      await tester.tap(switchIn('onboarding_toggleFriends'));
      await tester.pump();
      await tester.pump();

      expect(sharing.requested, isTrue);
      verifyNever(
        () => gamification.updateSettings(
          any(),
          previous: any(named: 'previous'),
        ),
      );
      expect(switchValue(tester, 'onboarding_toggleFriends'), isTrue);
    },
  );

  testWidgets('failed save reverts the friends toggle with an error', (
    tester,
  ) async {
    sharing.fails = true;
    await pumpStep(tester);
    await tester.tap(switchIn('onboarding_toggleFriends'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(switchValue(tester, 'onboarding_toggleFriends'), isFalse);
    expect(
      find.text('Не удалось сохранить настройку. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets(
    'turning location off opens system settings and keeps actual permission',
    (tester) async {
      when(
        () => permissions.locationWhenInUseStatus(),
      ).thenAnswer((_) async => PermissionStatus.granted);
      await pumpStep(tester);
      await tester.tap(switchIn('onboarding_toggleGeo'));
      await tester.pump();
      await tester.pump();
      verify(() => permissions.openPermissionSettings()).called(1);
      expect(switchValue(tester, 'onboarding_toggleGeo'), isTrue);
      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('notification opt-out failure keeps confirmed preference', (
    tester,
  ) async {
    when(() => notifications.hasPermission()).thenAnswer((_) async => true);
    when(
      () =>
          gamification.updateSettings(any(), previous: any(named: 'previous')),
    ).thenThrow(Exception('offline'));
    await pumpStep(tester);
    expect(switchValue(tester, 'onboarding_togglePush'), isTrue);
    await tester.tap(switchIn('onboarding_togglePush'));
    await tester.pump();
    await tester.pump();
    expect(switchValue(tester, 'onboarding_togglePush'), isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('finish is disabled while notification preference saves', (
    tester,
  ) async {
    final completer = Completer<UserSettings>();
    when(
      () =>
          gamification.updateSettings(any(), previous: any(named: 'previous')),
    ).thenAnswer((_) => completer.future);
    await pumpStep(tester);
    await tester.tap(switchIn('onboarding_togglePush'));
    await tester.pump();
    expect(
      tester
          .widget<AppButton>(find.byKey(const Key('onboarding_finish')))
          .onPressed,
      isNull,
    );
    completer.complete(const UserSettings());
    await tester.pump();
    await tester.pump();
    expect(
      tester
          .widget<AppButton>(find.byKey(const Key('onboarding_finish')))
          .onPressed,
      isNotNull,
    );
  });
}
