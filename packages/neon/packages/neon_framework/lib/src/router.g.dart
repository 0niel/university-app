// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $loginRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: 'neon',
      name: 'home',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'settings',
          name: 'Settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'apps/:appid',
              name: 'AppImplementationSettings',
              factory: $AppImplementationSettingsRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'account/add',
              name: 'addAccount',
              factory: $_AddAccountRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'flow',
                  factory: $_AddAccountFlowRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'qr-code',
                  factory: $_AddAccountQRcodeRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'check/server',
                  factory: $_AddAccountCheckServerStatusRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'check/account',
                  factory: $_AddAccountCheckAccountRouteExtension._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'account/:accountID',
              name: 'AccountSettings',
              factory: $AccountSettingsRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        'neon',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute(
        initialCategory:
            _$convertMapValue('initial-category', state.uri.queryParameters, _$SettingsCategoriesEnumMap._$fromName),
      );

  String get location => GoRouteData.$location(
        'neon/settings',
        queryParams: {
          if (initialCategory != null) 'initial-category': _$SettingsCategoriesEnumMap[initialCategory!],
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$SettingsCategoriesEnumMap = {
  SettingsCategories.apps: 'apps',
  SettingsCategories.theme: 'theme',
  SettingsCategories.navigation: 'navigation',
  SettingsCategories.pushNotifications: 'push-notifications',
  SettingsCategories.startup: 'startup',
  SettingsCategories.accounts: 'accounts',
  SettingsCategories.other: 'other',
};

extension $AppImplementationSettingsRouteExtension on AppImplementationSettingsRoute {
  static AppImplementationSettingsRoute _fromState(GoRouterState state) => AppImplementationSettingsRoute(
        appid: state.pathParameters['appid']!,
      );

  String get location => GoRouteData.$location(
        'neon/settings/apps/${Uri.encodeComponent(appid)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $_AddAccountRouteExtension on _AddAccountRoute {
  static _AddAccountRoute _fromState(GoRouterState state) => const _AddAccountRoute();

  String get location => GoRouteData.$location(
        'neon/settings/account/add',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $_AddAccountFlowRouteExtension on _AddAccountFlowRoute {
  static _AddAccountFlowRoute _fromState(GoRouterState state) => _AddAccountFlowRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
      );

  String get location => GoRouteData.$location(
        'neon/settings/account/add/flow',
        queryParams: {
          'server-url': serverUrl.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $_AddAccountQRcodeRouteExtension on _AddAccountQRcodeRoute {
  static _AddAccountQRcodeRoute _fromState(GoRouterState state) => const _AddAccountQRcodeRoute();

  String get location => GoRouteData.$location(
        'neon/settings/account/add/qr-code',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $_AddAccountCheckServerStatusRouteExtension on _AddAccountCheckServerStatusRoute {
  static _AddAccountCheckServerStatusRoute _fromState(GoRouterState state) => _AddAccountCheckServerStatusRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
      );

  String get location => GoRouteData.$location(
        'neon/settings/account/add/check/server',
        queryParams: {
          'server-url': serverUrl.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $_AddAccountCheckAccountRouteExtension on _AddAccountCheckAccountRoute {
  static _AddAccountCheckAccountRoute _fromState(GoRouterState state) => _AddAccountCheckAccountRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
        loginName: state.uri.queryParameters['login-name']!,
        password: state.uri.queryParameters['password']!,
      );

  String get location => GoRouteData.$location(
        'neon/settings/account/add/check/account',
        queryParams: {
          'server-url': serverUrl.toString(),
          'login-name': loginName,
          'password': password,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AccountSettingsRouteExtension on AccountSettingsRoute {
  static AccountSettingsRoute _fromState(GoRouterState state) => AccountSettingsRoute(
        accountID: state.pathParameters['accountID']!,
      );

  String get location => GoRouteData.$location(
        'neon/settings/account/${Uri.encodeComponent(accountID)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) => entries.singleWhere((element) => element.value == value).key;
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: 'neon-login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'flow',
          factory: $LoginFlowRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'qr-code',
          factory: $LoginQRcodeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'check/server',
          factory: $LoginCheckServerStatusRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'check/account',
          factory: $LoginCheckAccountRouteExtension._fromState,
        ),
      ],
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        'neon-login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginFlowRouteExtension on LoginFlowRoute {
  static LoginFlowRoute _fromState(GoRouterState state) => LoginFlowRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
      );

  String get location => GoRouteData.$location(
        'neon-login/flow',
        queryParams: {
          'server-url': serverUrl.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginQRcodeRouteExtension on LoginQRcodeRoute {
  static LoginQRcodeRoute _fromState(GoRouterState state) => const LoginQRcodeRoute();

  String get location => GoRouteData.$location(
        'neon-login/qr-code',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginCheckServerStatusRouteExtension on LoginCheckServerStatusRoute {
  static LoginCheckServerStatusRoute _fromState(GoRouterState state) => LoginCheckServerStatusRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
        loginName: state.uri.queryParameters['login-name'],
        password: state.uri.queryParameters['password'],
      );

  String get location => GoRouteData.$location(
        'neon-login/check/server',
        queryParams: {
          'server-url': serverUrl.toString(),
          if (loginName != null) 'login-name': loginName,
          if (password != null) 'password': password,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginCheckAccountRouteExtension on LoginCheckAccountRoute {
  static LoginCheckAccountRoute _fromState(GoRouterState state) => LoginCheckAccountRoute(
        serverUrl: Uri.parse(state.uri.queryParameters['server-url']!),
        loginName: state.uri.queryParameters['login-name']!,
        password: state.uri.queryParameters['password']!,
      );

  String get location => GoRouteData.$location(
        'neon-login/check/account',
        queryParams: {
          'server-url': serverUrl.toString(),
          'login-name': loginName,
          'password': password,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
