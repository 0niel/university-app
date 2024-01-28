// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/pages/account_settings.dart';
import 'package:neon_framework/src/pages/app_implementation_settings.dart';
import 'package:neon_framework/src/pages/home.dart';
import 'package:neon_framework/src/pages/login.dart';
import 'package:neon_framework/src/pages/login_check_account.dart';
import 'package:neon_framework/src/pages/login_check_server_status.dart';
import 'package:neon_framework/src/pages/login_flow.dart';
import 'package:neon_framework/src/pages/login_qr_code.dart';
import 'package:neon_framework/src/pages/route_not_found.dart';
import 'package:neon_framework/src/pages/settings.dart';
import 'package:neon_framework/src/utils/findable.dart';
import 'package:neon_framework/src/utils/provider.dart';

part 'router.g.dart';

/// Redirect function for the Neon GoRouter.
typedef NeonRedirectFunction = String? Function(
  AccountsBloc accountsBloc,
  BuildContext context,
  GoRouterState state,
);

final NeonRedirectFunction redirect = (accountsBloc, context, state) {
  final loginQRcode = LoginQRcode.tryParse(state.uri.toString());
  if (loginQRcode != null) {
    return LoginCheckServerStatusRoute.withCredentials(
      serverUrl: loginQRcode.serverURL,
      loginName: loginQRcode.username,
      password: loginQRcode.password,
    ).location;
  }

  if (accountsBloc.hasAccounts && state.uri.hasScheme) {
    final strippedUri = accountsBloc.activeAccount.value!.stripUri(state.uri);
    if (strippedUri != state.uri) {
      return strippedUri.toString();
    }
  }

  // Redirect to login screen when no account is logged in
  // We only check the prefix of the current location as we also don't want to redirect on any of the other login routes.
  if (!accountsBloc.hasAccounts && !state.matchedLocation.contains(const LoginRoute().location)) {
    return const LoginRoute().location;
  }

  return null;
};

/// Internal router for the Neon framework.
@internal
GoRouter buildAppRouter({
  required GlobalKey<NavigatorState> navigatorKey,
  required AccountsBloc accountsBloc,
}) =>
    GoRouter(
      debugLogDiagnostics: kDebugMode,
      navigatorKey: navigatorKey,
      initialLocation: const HomeRoute().location,
      errorPageBuilder: _buildErrorPage,
      redirect: (context, state) => redirect(accountsBloc, context, state),
      routes: $appRoutes,
    );

Page<void> _buildErrorPage(BuildContext context, GoRouterState state) => MaterialPage(
      child: RouteNotFoundPage(
        uri: state.uri,
      ),
    );

/// {@template AppRoutes.AccountSettingsRoute}
/// Route for the [AccountSettingsPage].
/// {@endtemplate}
@immutable
class AccountSettingsRoute extends GoRouteData {
  /// {@macro AppRoutes.AccountSettingsRoute}
  const AccountSettingsRoute({
    required this.accountID,
  });

  /// The id of the account to show the settings for.
  ///
  /// Passed to [AccountSettingsPage.account].
  final String accountID;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final bloc = NeonProvider.of<AccountsBloc>(context);
    final account = bloc.accounts.value.find(accountID);

    return AccountSettingsPage(
      bloc: bloc,
      account: account,
    );
  }
}

/// {@template AppRoutes.HomeRoute}
/// Route for the the [HomePage].
/// {@endtemplate}
@TypedGoRoute<HomeRoute>(
  path: 'neon',
  name: 'home',
  routes: [
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      name: 'Settings',
      routes: [
        TypedGoRoute<AppImplementationSettingsRoute>(
          path: 'apps/:appid',
          name: 'AppImplementationSettings',
        ),
        TypedGoRoute<_AddAccountRoute>(
          path: 'account/add',
          name: 'addAccount',
          routes: [
            TypedGoRoute<_AddAccountFlowRoute>(
              path: 'flow',
            ),
            TypedGoRoute<_AddAccountQRcodeRoute>(
              path: 'qr-code',
            ),
            TypedGoRoute<_AddAccountCheckServerStatusRoute>(
              path: 'check/server',
            ),
            TypedGoRoute<_AddAccountCheckAccountRoute>(
              path: 'check/account',
            ),
          ],
        ),
        TypedGoRoute<AccountSettingsRoute>(
          path: 'account/:accountID',
          name: 'AccountSettings',
        ),
      ],
    ),
  ],
)
@immutable
class HomeRoute extends GoRouteData {
  /// {@macro AppRoutes.HomeRoute}
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    return StreamBuilder(
      stream: accountsBloc.activeAccount,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final account = snapshot.requireData!;
        return HomePage(
          account: account,
          key: Key(account.id),
        );
      },
    );
  }
}

/// {@template AppRoutes.LoginRoute}
/// Route for the the initial [LoginPage].
///
/// All routes related to the login flow are subroutes of this.
/// All subroutes redirect to subroutes of [HomeRoute] if a at least one
/// account is already logged in and further accounts should be added.
/// {@endtemplate}
@TypedGoRoute<LoginRoute>(
  path: 'neon-login',
  name: 'login',
  routes: [
    TypedGoRoute<LoginFlowRoute>(
      path: 'flow',
    ),
    TypedGoRoute<LoginQRcodeRoute>(
      path: 'qr-code',
    ),
    TypedGoRoute<LoginCheckServerStatusRoute>(
      path: 'check/server',
    ),
    TypedGoRoute<LoginCheckAccountRoute>(
      path: 'check/account',
    ),
  ],
)
@immutable
class LoginRoute extends GoRouteData {
  /// {@macro AppRoutes.LoginRoute}
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return const _AddAccountRoute().location;
    }

    return null;
  }
}

/// {@template AppRoutes.LoginFlowRoute}
/// Route for the the [LoginFlowPage].
///
/// Redirects to [_AddAccountFlowRoute] when at least one account is already
/// logged in.
/// {@endtemplate}
@immutable
class LoginFlowRoute extends GoRouteData {
  /// {@macro AppRoutes.LoginFlowRoute}
  const LoginFlowRoute({
    required this.serverUrl,
  });

  /// {@template AppRoutes.LoginFlow.serverUrl}
  /// The url of the server to initiate the login flow for.
  /// {@endtemplate}
  final Uri serverUrl;

  @override
  Widget build(BuildContext context, GoRouterState state) => LoginFlowPage(serverURL: serverUrl);

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return _AddAccountFlowRoute(serverUrl: serverUrl).location;
    }

    return null;
  }
}

/// {@template AppRoutes.LoginQRcodeRoute}
/// Route for the the [LoginQRcodePage].
///
/// Redirects to [_AddAccountQRcodeRoute] when at least one account is already
/// logged in.
/// {@endtemplate}
@immutable
class LoginQRcodeRoute extends GoRouteData {
  /// {@macro AppRoutes.LoginQRcodeRoute}
  const LoginQRcodeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginQRcodePage();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return const _AddAccountQRcodeRoute().location;
    }

    return null;
  }
}

/// {@template AppRoutes.LoginCheckServerStatusRoute}
/// Route for the the [LoginCheckServerStatusPage].
///
/// Redirects to [_AddAccountCheckServerStatusRoute] when at least one account
/// is already logged in.
/// {@endtemplate}
@immutable
class LoginCheckServerStatusRoute extends GoRouteData {
  /// {@macro AppRoutes.LoginCheckServerStatusRoute}
  ///
  /// [loginName] and [password] must both be null.
  /// Use [LoginCheckServerStatusRoute.withCredentials] to specify credentials.
  const LoginCheckServerStatusRoute({
    required this.serverUrl,
    this.loginName,
    this.password,
  }) : assert(
          loginName == null && password == null,
          'loginName and password must be null. Use LoginCheckServerStatusRoute.withCredentials instead.',
        );

  /// {@macro AppRoutes.LoginCheckServerStatusRoute}
  ///
  /// See [LoginCheckServerStatusRoute] for a route without initial credentials.
  const LoginCheckServerStatusRoute.withCredentials({
    required this.serverUrl,
    required String this.loginName,
    required String this.password,
  }) : assert(!kIsWeb, 'Might leak the password to the browser history');

  /// {@macro AppRoutes.LoginFlow.serverUrl}
  final Uri serverUrl;

  /// {@template AppRoutes.LoginFlow.loginName}
  /// The login name of the credentials.
  /// {@endtemplate}
  final String? loginName;

  /// {@template AppRoutes.LoginFlow.password}
  /// The password of the credentials.
  /// {@endtemplate}
  final String? password;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    if (loginName != null && password != null) {
      return LoginCheckServerStatusPage.withCredentials(
        serverURL: serverUrl,
        loginName: loginName!,
        password: password!,
      );
    }

    return LoginCheckServerStatusPage(
      serverURL: serverUrl,
    );
  }

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      if (loginName != null && password != null) {
        return _AddAccountCheckServerStatusRoute.withCredentials(
          serverUrl: serverUrl,
          loginName: loginName!,
          password: password!,
        ).location;
      }

      return _AddAccountCheckServerStatusRoute(
        serverUrl: serverUrl,
      ).location;
    }

    return null;
  }
}

/// {@template AppRoutes.LoginCheckAccountRoute}
/// Route for the the [LoginCheckAccountPage].
///
/// Redirects to [_AddAccountCheckAccountRoute] when at least one account
/// is already logged in.
/// {@endtemplate}
@immutable
class LoginCheckAccountRoute extends GoRouteData {
  /// {@macro AppRoutes.LoginCheckAccountRoute}
  const LoginCheckAccountRoute({
    required this.serverUrl,
    required this.loginName,
    required this.password,
  }) : assert(!kIsWeb, 'Might leak the password to the browser history');

  /// {@macro AppRoutes.LoginFlow.serverUrl}
  final Uri serverUrl;

  /// {@macro AppRoutes.LoginFlow.loginName}
  final String loginName;

  /// {@macro AppRoutes.LoginFlow.password}
  final String password;

  @override
  Widget build(BuildContext context, GoRouterState state) => LoginCheckAccountPage(
        serverURL: serverUrl,
        loginName: loginName,
        password: password,
      );

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final hasAccounts = NeonProvider.of<AccountsBloc>(context).hasAccounts;

    if (state.fullPath == location && hasAccounts) {
      return _AddAccountCheckAccountRoute(
        serverUrl: serverUrl,
        loginName: loginName,
        password: password,
      ).location;
    }

    return null;
  }
}

@immutable
class _AddAccountRoute extends LoginRoute {
  const _AddAccountRoute();
}

@immutable
class _AddAccountFlowRoute extends LoginFlowRoute {
  const _AddAccountFlowRoute({
    required super.serverUrl,
  });

  @override
  Uri get serverUrl => super.serverUrl;
}

@immutable
class _AddAccountQRcodeRoute extends LoginQRcodeRoute {
  const _AddAccountQRcodeRoute();
}

@immutable
class _AddAccountCheckServerStatusRoute extends LoginCheckServerStatusRoute {
  const _AddAccountCheckServerStatusRoute({
    required super.serverUrl,
  });

  const _AddAccountCheckServerStatusRoute.withCredentials({
    required super.serverUrl,
    required super.loginName,
    required super.password,
  }) : super.withCredentials();

  @override
  Uri get serverUrl => super.serverUrl;
  @override
  String? get loginName => super.loginName;
  @override
  String? get password => super.password;
}

@immutable
class _AddAccountCheckAccountRoute extends LoginCheckAccountRoute {
  const _AddAccountCheckAccountRoute({
    required super.serverUrl,
    required super.loginName,
    required super.password,
  });

  @override
  Uri get serverUrl => super.serverUrl;
  @override
  String get loginName => super.loginName;
  @override
  String get password => super.password;
}

/// {@template AppRoutes.AppImplementationSettingsRoute}
/// Route for the the [AppImplementationSettingsPage].
/// {@endtemplate}
@immutable
class AppImplementationSettingsRoute extends GoRouteData {
  /// {@macro AppRoutes.AppImplementationSettingsRoute}
  const AppImplementationSettingsRoute({
    required this.appid,
  });

  /// The id of the app to display the settings for.
  final String appid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final appImplementations = NeonProvider.of<Iterable<AppImplementation>>(context);
    final appImplementation = appImplementations.tryFind(appid)!;

    return AppImplementationSettingsPage(appImplementation: appImplementation);
  }
}

/// {@template AppRoutes.SettingsRoute}
/// Route for the the [SettingsPage].
/// {@endtemplate}
@immutable
class SettingsRoute extends GoRouteData {
  /// {@macro AppRoutes.SettingsRoute}
  const SettingsRoute({
    this.initialCategory,
  });

  /// The initial category to show.
  final SettingsCategories? initialCategory;

  @override
  Widget build(BuildContext context, GoRouterState state) => SettingsPage(initialCategory: initialCategory);
}
