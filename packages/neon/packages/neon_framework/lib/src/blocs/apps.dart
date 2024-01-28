import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/capabilities.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/models/notifications_interface.dart';
import 'package:neon_framework/src/settings/models/options_collection.dart';
import 'package:neon_framework/src/utils/findable.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// The Bloc responsible for managing the [AppImplementation]s.
@sealed
abstract class AppsBloc implements InteractiveBloc {
  /// Create a new apps bloc.
  @internal
  factory AppsBloc(
    CapabilitiesBloc capabilitiesBloc,
    AccountsBloc accountsBloc,
    Account account,
    Iterable<AppImplementation> allAppImplementations,
  ) =>
      _AppsBloc(
        capabilitiesBloc,
        accountsBloc,
        account,
        allAppImplementations,
      );

  /// Sets the active app using the [appID].
  ///
  /// If the app is already the active app nothing will happen.
  /// When using [skipAlreadySet] nothing will be done if there already is an active app.
  void setActiveApp(String appID, {bool skipAlreadySet = false});

  /// A collection of clients used in the app drawer.
  ///
  /// It does not contain clients for that are specially handled like for the notifications.
  BehaviorSubject<Result<Iterable<AppImplementation>>> get appImplementations;

  /// The interface of the notifications app.
  BehaviorSubject<Result<NotificationsAppInterface?>> get notificationsAppImplementation;

  /// The currently active app.
  BehaviorSubject<AppImplementation> get activeApp;

  /// A subject emitting an event when the notifications page should be opened.
  BehaviorSubject<void> get openNotifications;

  /// A collection of unsupported apps and their minimum required version.
  BehaviorSubject<Map<String, VersionCheck>> get appVersionChecks;

  /// Returns the active [Bloc] for the given [appImplementation].
  ///
  /// If no bloc exists yet a new one will be instantiated and cached in [AppImplementation.blocsCache].
  T getAppBloc<T extends Bloc>(AppImplementation<T, dynamic> appImplementation);

  /// Returns the active [Bloc] for every registered [AppImplementation] wrapped in a Provider.
  List<Provider<Bloc>> get appBlocProviders;
}

/// Implementation of [AppsBloc].
class _AppsBloc extends InteractiveBloc implements AppsBloc {
  /// Creates a new apps bloc.
  _AppsBloc(
    this.capabilitiesBloc,
    this.accountsBloc,
    this.account,
    this.allAppImplementations,
  ) {
    apps.listen((result) {
      appImplementations.add(result.transform((data) => filteredAppImplementations(data.map((a) => a.id))));

      if (result.hasData) {
        unawaited(updateApps());
      }
    });

    capabilitiesBloc.capabilities.listen((result) {
      notificationsAppImplementation.add(
        result.transform(
          (data) => data.capabilities.notificationsCapabilities?.notifications != null
              ? findAppImplementation(AppIDs.notifications)
              : null,
        ),
      );

      if (result.hasData) {
        unawaited(updateApps());
      }
    });

    unawaited(refresh());
  }

  /// Disposes all unsupported apps, sets the active app and checks the app compatibility.
  ///
  /// Blocs of apps that are no longer present on the server are disposed.
  /// The notifications app is handled separately because it does not appear in the list of apps.
  Future<void> updateApps() async {
    // dispose unsupported apps
    for (final app in allAppImplementations) {
      if (app.id == AppIDs.notifications) {
        if (notificationsAppImplementation.hasValue &&
            !notificationsAppImplementation.value.isCached &&
            notificationsAppImplementation.value.data == null) {
          app.blocsCache.remove(account);
        }
        continue;
      }

      if (appImplementations.hasValue &&
          !appImplementations.value.isCached &&
          appImplementations.value.data?.tryFind(app.id) == null) {
        app.blocsCache.remove(account);
      }
    }

    final initialApp = getInitialAppFallback();
    if (initialApp != null) {
      await setActiveApp(initialApp);
    }

    await checkCompatibility();
  }

  /// Determines the appid of initial app.
  ///
  /// First the user selected initial app is checked, then the dashboard app and as the last one the files app.
  /// If none of those apps are installed, the first supported one will be returned.
  /// Returns null when no app is supported by the server.
  String? getInitialAppFallback() {
    final supportedApps = appImplementations.valueOrNull?.data;
    if (supportedApps == null) {
      return null;
    }

    final options = accountsBloc.getOptionsFor(account);
    for (final fallback in {options.initialApp.value, AppIDs.dashboard, AppIDs.files}) {
      if (supportedApps.tryFind(fallback) != null) {
        return fallback;
      }
    }

    if (supportedApps.isNotEmpty) {
      return supportedApps.first.id;
    }

    return null;
  }

  Future<void> checkCompatibility() async {
    final apps = appImplementations.valueOrNull;
    final capabilities = capabilitiesBloc.capabilities.valueOrNull;

    // ignore cached data
    if (capabilities == null || apps == null || !capabilities.hasSuccessfulData || !apps.hasSuccessfulData) {
      return;
    }

    final notSupported = <String, VersionCheck>{};

    try {
      final coreCheck = account.client.core.getVersionCheck(capabilities.requireData);
      if (!coreCheck.isSupported && !capabilities.requireData.version.string.contains('dev')) {
        notSupported['core'] = coreCheck;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    for (final app in apps.requireData) {
      try {
        final check = await app.getVersionCheck(account, capabilities.requireData);

        if (check == null) {
          continue;
        }

        if (!check.isSupported) {
          notSupported[app.id] = check;
        }
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
    }

    if (notSupported.isNotEmpty) {
      appVersionChecks.add(notSupported);
    }
  }

  T? findAppImplementation<T extends AppImplementation>(String id) {
    final matches = filteredAppImplementations([id]);
    if (matches.isNotEmpty) {
      return matches.single as T;
    }

    return null;
  }

  Iterable<AppImplementation> filteredAppImplementations(Iterable<String> appIds) =>
      allAppImplementations.where((a) => appIds.contains(a.id));

  final CapabilitiesBloc capabilitiesBloc;
  final AccountsBloc accountsBloc;
  final Account account;
  final Iterable<AppImplementation> allAppImplementations;
  final apps = BehaviorSubject<Result<BuiltList<core.NavigationEntry>>>();

  @override
  void dispose() {
    unawaited(apps.close());
    unawaited(appImplementations.close());
    unawaited(notificationsAppImplementation.close());
    unawaited(activeApp.close());
    unawaited(openNotifications.close());
    unawaited(appVersionChecks.close());

    super.dispose();
  }

  @override
  BehaviorSubject<AppImplementation> activeApp = BehaviorSubject();

  @override
  BehaviorSubject<Result<Iterable<AppImplementation<Bloc, AppImplementationOptions>>>> appImplementations =
      BehaviorSubject();

  @override
  BehaviorSubject<Result<NotificationsAppInterface?>> notificationsAppImplementation = BehaviorSubject();

  @override
  BehaviorSubject<void> openNotifications = BehaviorSubject();

  @override
  BehaviorSubject<Map<String, VersionCheck>> appVersionChecks = BehaviorSubject();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud(
      account: account,
      cacheKey: 'apps-apps',
      subject: apps,
      rawResponse: account.client.core.navigation.getAppsNavigationRaw(),
      unwrap: (response) => response.body.ocs.data,
    );
  }

  @override
  Future<void> setActiveApp(String appID, {bool skipAlreadySet = false}) async {
    if (appID == AppIDs.notifications) {
      openNotifications.add(null);
      return;
    }

    final apps = await appImplementations.firstWhere((a) => a.hasData);
    final app = apps.requireData.tryFind(appID);
    if (app != null) {
      if ((!activeApp.hasValue || !skipAlreadySet) && activeApp.valueOrNull?.id != appID) {
        activeApp.add(app);
      }
    } else {
      throw Exception('App $appID not found');
    }
  }

  @override
  T getAppBloc<T extends Bloc>(AppImplementation<T, dynamic> appImplementation) => appImplementation.getBloc(account);

  @override
  List<Provider<Bloc>> get appBlocProviders =>
      allAppImplementations.map((appImplementation) => appImplementation.blocProvider).toList();
}
