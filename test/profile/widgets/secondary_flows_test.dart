import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/view/account_management_page.dart';
import 'package:rtu_mirea_app/profile/widgets/edit_identity_sheet.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_row.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:user_repository/user_repository.dart';

class _App extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _UserRepository extends Mock implements UserRepository {}

Widget _app(Widget child, {bool dark = false, double scale = 1}) => MaterialApp(
  theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(scale), disableAnimations: true),
    child: NinjaToastHost(child: child!),
  ),
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  ),
);

void main() {
  late AppLocalizations l10n;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  testWidgets(
    'profile visibility choices are compact full width and interactive',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      ProfileVisibility? selected;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => AppButton.primary(
              label: 'open',
              onPressed: () => showProfileVisibilitySheet(
                context,
                current: ProfileVisibility.everyone,
                onSelected: (value) => selected = value,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final choices = find.byType(AppRadioRow);
      expect(choices, findsNWidgets(3));
      expect(tester.getSize(choices.first).width, 350);
      expect(tester.getSize(choices.first).height, 58);
      await tester.tap(find.text(l10n.settingsVisibilityNobody));
      await tester.pumpAndSettle();
      expect(selected, ProfileVisibility.nobody);
      expect(find.byType(AppRadioRow), findsNothing);
      expect(find.text('open'), findsOneWidget);
    },
  );

  Widget accountApp(AppBloc app, UserRepository repository) =>
      RepositoryProvider<UserRepository>.value(
        value: repository,
        child: BlocProvider<AppBloc>.value(
          value: app,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AccountManagementPage(),
          ),
        ),
      );

  testWidgets(
    'account deletion requires confirmation and failure stays recoverable',
    (tester) async {
      final app = _App();
      final repository = _UserRepository();
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'one', email: 'anna@example.org'),
        ),
      );
      final deleted = Completer<void>();
      when(repository.deleteAccount).thenAnswer((_) => deleted.future);
      await tester.pumpWidget(accountApp(app, repository));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.accountDelete));
      await tester.pump(const Duration(milliseconds: 400));
      verifyNever(repository.deleteAccount);
      expect(find.text(l10n.accountDeleteConfirmTitle), findsOneWidget);
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is NinjaPillButton &&
              widget.label == l10n.accountDeleteAction,
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      verify(repository.deleteAccount).called(1);
      deleted.completeError(Exception('reauthentication required'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountDeleteError), findsOneWidget);
      final row = tester.widget<SettingsRow>(
        find.ancestor(
          of: find.text(l10n.accountDelete),
          matching: find.byType(SettingsRow),
        ),
      );
      expect(row.enabled, isTrue);
    },
  );

  testWidgets('guest account cannot reset or delete an unidentified account', (
    tester,
  ) async {
    final app = _App();
    final repository = _UserRepository();
    when(() => app.state).thenReturn(const AppState());
    await tester.pumpWidget(accountApp(app, repository));
    await tester.pumpAndSettle();
    expect(find.text(l10n.accountGuest), findsOneWidget);
    expect(find.text(l10n.accountChangePassword), findsNothing);
    final row = tester.widget<SettingsRow>(
      find.ancestor(
        of: find.text(l10n.accountDelete),
        matching: find.byType(SettingsRow),
      ),
    );
    expect(row.enabled, isFalse);
    verifyNever(repository.deleteAccount);
  });

  testWidgets(
    'real guest account has a save action without an empty-email reset',
    (tester) async {
      final app = _App();
      final repository = _UserRepository();
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'guest', email: '', isGuest: true),
        ),
      );
      await tester.pumpWidget(accountApp(app, repository));
      await tester.pumpAndSettle();
      expect(find.text(l10n.authGuestUpgradeTitle), findsOneWidget);
      expect(find.text(l10n.accountGuest), findsOneWidget);
      expect(find.text(l10n.accountChangePassword), findsNothing);
    },
  );

  testWidgets('widget refresh does not claim completion while pending', (
    tester,
  ) async {
    final result = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      _app(
        ScheduleWidgetRefreshSheet(
          onRefresh: () {
            calls++;
            return result.future;
          },
        ),
      ),
    );
    await tester.tap(find.text(l10n.settingsWidgetRefresh));
    await tester.pump();
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
    expect(find.text(l10n.settingsWidgetRefreshRequested), findsNothing);
    result.complete();
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.text(l10n.settingsWidgetRefreshRequested), findsOneWidget);
  });

  testWidgets('widget refresh unavailable is inert and explains why', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ScheduleWidgetRefreshSheet(
          unavailableMessage: l10n.scheduleNotSelected,
        ),
      ),
    );
    expect(tester.widget<AppButton>(find.byType(AppButton)).onPressed, isNull);
    expect(find.text(l10n.scheduleNotSelected), findsOneWidget);
    expect(find.text(l10n.settingsWidgetRefreshRequested), findsNothing);
  });

  testWidgets('widget failure remains retryable without success text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        ScheduleWidgetRefreshSheet(
          onRefresh: () async => throw Exception('offline'),
        ),
      ),
    );
    await tester.tap(find.text(l10n.settingsWidgetRefresh));
    await tester.pumpAndSettle();
    expect(find.byType(AppErrorState), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.byType(AppButton)).onPressed,
      isNotNull,
    );
    expect(find.text(l10n.settingsWidgetRefreshRequested), findsNothing);
  });

  testWidgets('identity availability failure is explicit and retryable', (
    tester,
  ) async {
    var checks = 0;
    await tester.pumpWidget(
      _app(
        EditIdentitySheet(
          initialName: 'Анна',
          initialHandle: 'anna',
          onCheckAvailable: (_) async {
            if (++checks == 1) throw Exception('offline');
            return true;
          },
          onSave: ({required fullName, required handle}) async =>
              IdentityUpdateResult.success,
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).at(1), 'new_anna');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text(l10n.identityHandleCheckError), findsOneWidget);
    await tester.tap(find.text(l10n.retry));
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    expect(find.text(l10n.identityHandleAvailable), findsOneWidget);
    expect(checks, 2);
  });

  testWidgets('identity fields and submit freeze until save resolves', (
    tester,
  ) async {
    final saved = Completer<IdentityUpdateResult>();
    await tester.pumpWidget(
      _app(
        EditIdentitySheet(
          initialName: 'Анна',
          initialHandle: 'anna',
          onCheckAvailable: (_) async => true,
          onSave: ({required fullName, required handle}) => saved.future,
        ),
      ),
    );
    await tester.tap(find.text(l10n.profileEditSave));
    await tester.pump();
    expect(
      tester
          .widgetList<AppInputField>(find.byType(AppInputField))
          .every((field) => !field.enabled),
      isTrue,
    );
    expect(tester.widget<AppButton>(find.byType(AppButton)).loading, isTrue);
    saved.complete(IdentityUpdateResult.error);
    await tester.pumpAndSettle();
    expect(find.text(l10n.identitySaveError), findsOneWidget);
    expect(
      tester.widget<NinjaToast>(find.byType(NinjaToast)).showCheck,
      isFalse,
    );
    expect(
      tester
          .widgetList<AppInputField>(find.byType(AppInputField))
          .every((field) => field.enabled),
      isTrue,
    );
  });

  for (final dark in [false, true]) {
    testWidgets(
      'identity sheet fits 320 wide at 200 percent ${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            EditIdentitySheet(
              initialName: 'Александра Константинопольская',
              initialHandle: 'alexandra',
              onCheckAvailable: (_) async => true,
              onSave: ({required fullName, required handle}) async =>
                  IdentityUpdateResult.error,
            ),
            dark: dark,
            scale: 2,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        for (final input in find.byType(AppInputField).evaluate()) {
          expect(
            tester.getRect(find.byWidget(input.widget)).right,
            lessThanOrEqualTo(300),
          );
        }
      },
    );
  }

  testWidgets(
    'account reset is single flight and exposes a recoverable error',
    (tester) async {
      final app = _App();
      final repository = _UserRepository();
      when(() => app.state).thenReturn(
        const AppState(
          status: AppStatus.authenticated,
          user: User(id: 'one', email: 'anna@example.org'),
        ),
      );
      final response = Completer<void>();
      when(
        () => repository.sendPasswordResetEmail(email: 'anna@example.org'),
      ).thenAnswer((_) => response.future);
      await tester.pumpWidget(
        RepositoryProvider<UserRepository>.value(
          value: repository,
          child: BlocProvider<AppBloc>.value(
            value: app,
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              locale: const Locale('ru'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const AccountManagementPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.accountChangePassword));
      await tester.pump();
      final row = tester.widget<SettingsRow>(
        find.ancestor(
          of: find.text(l10n.accountChangePassword),
          matching: find.byType(SettingsRow),
        ),
      );
      expect(row.enabled, isFalse);
      response.completeError(Exception('offline'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.accountResetError), findsOneWidget);
      expect(find.text(l10n.accountResetSent), findsNothing);
      verify(
        () => repository.sendPasswordResetEmail(email: 'anna@example.org'),
      ).called(1);
    },
  );
}
