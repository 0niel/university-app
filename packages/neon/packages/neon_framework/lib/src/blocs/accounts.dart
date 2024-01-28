import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/blocs/apps.dart';
import 'package:neon_framework/src/blocs/capabilities.dart';
import 'package:neon_framework/src/blocs/unified_search.dart';
import 'package:neon_framework/src/blocs/user_details.dart';
import 'package:neon_framework/src/blocs/user_status.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/account_cache.dart';
import 'package:neon_framework/src/models/app_implementation.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/settings/models/storage.dart';
import 'package:neon_framework/src/utils/account_options.dart';
import 'package:neon_framework/src/utils/findable.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

const _keyAccounts = 'accounts';

/// The Bloc responsible for managing the [Account]s
@sealed
abstract interface class AccountsBloc implements Disposable {
  @internal
  factory AccountsBloc(
    GlobalOptions globalOptions,
    Iterable<AppImplementation> allAppImplementations,
  ) =>
      _AccountsBloc(
        globalOptions,
        allAppImplementations,
      );

  /// Logs in the given [account].
  ///
  /// It will also call [setActiveAccount] when no other accounts are registered in [AccountsBloc.accounts].
  void addAccount(Account account);

  /// Logs out the given [account].
  ///
  /// If [account] is the current [AccountsBloc.activeAccount] it will automatically activate the first one in [AccountsBloc.accounts].
  /// It is not defined whether listeners of [AccountsBloc.accounts] or [AccountsBloc.activeAccount] are informed first.
  void removeAccount(Account account);

  /// Updates the given [account].
  ///
  /// It triggers an event in both [AccountsBloc.accounts] and [AccountsBloc.activeAccount] to inform all listeners.
  void updateAccount(Account account);

  /// Sets the active [account].
  ///
  /// It triggers an event in [AccountsBloc.activeAccount] to inform all listeners.
  void setActiveAccount(Account account);

  /// All registered accounts.
  ///
  /// An empty value represents a state where no account is logged in.
  BehaviorSubject<List<Account>> get accounts;

  /// Currently active account.
  ///
  /// It should be ensured to only emit an event when it's value changes.
  /// A null value represents a state where no user is logged in.
  BehaviorSubject<Account?> get activeAccount;

  /// Whether accounts are logged in.
  bool get hasAccounts;

  /// The options for the [activeAccount].
  ///
  /// Convenience method for [getOptionsFor] with the currently active account.
  AccountOptions get activeOptions;

  /// The options for the specified [account].
  ///
  /// Use [activeOptions] to get them for the [activeAccount].
  AccountOptions getOptionsFor(Account account);

  /// The appsBloc for the [activeAccount].
  ///
  /// Convenience method for [getAppsBlocFor] with the currently active account.
  AppsBloc get activeAppsBloc;

  /// The appsBloc for the specified [account].
  ///
  /// Use [activeAppsBloc] to get them for the [activeAccount].
  AppsBloc getAppsBlocFor(Account account);

  /// The capabilitiesBloc for the [activeAccount].
  ///
  /// Convenience method for [getCapabilitiesBlocFor] with the currently active account.
  CapabilitiesBloc get activeCapabilitiesBloc;

  /// The capabilitiesBloc for the specified [account].
  ///
  /// Use [activeCapabilitiesBloc] to get them for the [activeAccount].
  CapabilitiesBloc getCapabilitiesBlocFor(Account account);

  /// The userDetailsBloc for the [activeAccount].
  ///
  /// Convenience method for [getUserDetailsBlocFor] with the currently active account.
  UserDetailsBloc get activeUserDetailsBloc;

  /// The userDetailsBloc for the specified [account].
  ///
  /// Use [activeUserDetailsBloc] to get them for the [activeAccount].
  UserDetailsBloc getUserDetailsBlocFor(Account account);

  /// The userStatusBloc for the [activeAccount].
  ///
  /// Convenience method for [getUserStatusBlocFor] with the currently active account.
  UserStatusBloc get activeUserStatusBloc;

  /// The userStatusBloc for the specified [account].
  ///
  /// Use [activeUserStatusBloc] to get them for the [activeAccount].
  UserStatusBloc getUserStatusBlocFor(Account account);

  /// The UnifiedSearchBloc for the [activeAccount].
  ///
  /// Convenience method for [getUnifiedSearchBlocFor] with the currently active account.
  UnifiedSearchBloc get activeUnifiedSearchBloc;

  /// The UnifiedSearchBloc for the specified [account].
  ///
  /// Use [activeUnifiedSearchBloc] to get them for the [activeAccount].
  UnifiedSearchBloc getUnifiedSearchBlocFor(Account account);
}

/// Implementation of [AccountsBloc].
class _AccountsBloc extends Bloc implements AccountsBloc {
  /// Creates a new account bloc.
  ///
  /// The last state will be loaded from storage and all necessary listeners
  /// will be set up.
  _AccountsBloc(
    this.globalOptions,
    this.allAppImplementations,
  ) {
    const lastUsedStorage = SingleValueStorage(StorageKeys.lastUsedAccount);

    accounts
      ..add(loadAccounts())
      ..listen((as) async {
        globalOptions.updateAccounts(as);
        await saveAccounts(as);
      });
    activeAccount.listen((aa) async {
      if (aa != null) {
        await lastUsedStorage.setString(aa.id);
      } else {
        await lastUsedStorage.remove();
      }
    });

    final as = accounts.value;

    if (globalOptions.rememberLastUsedAccount.value && lastUsedStorage.hasValue()) {
      final lastUsedAccountID = lastUsedStorage.getString();
      if (lastUsedAccountID != null) {
        final aa = as.tryFind(lastUsedAccountID);
        if (aa != null) {
          setActiveAccount(aa);
        }
      }
    }

    final account = as.tryFind(globalOptions.initialAccount.value);
    if (activeAccount.valueOrNull == null) {
      if (account != null) {
        setActiveAccount(account);
      } else if (as.isNotEmpty) {
        setActiveAccount(as.first);
      }
    }

    accounts.listen((accounts) {
      accountsOptions.pruneAgainst(accounts);
      appsBlocs.pruneAgainst(accounts);
      capabilitiesBlocs.pruneAgainst(accounts);
      userDetailsBlocs.pruneAgainst(accounts);
      userStatusBlocs.pruneAgainst(accounts);
      unifiedSearchBlocs.pruneAgainst(accounts);
      for (final app in allAppImplementations) {
        app.blocsCache.pruneAgainst(accounts);
      }
    });
  }

  final GlobalOptions globalOptions;
  final Iterable<AppImplementation> allAppImplementations;

  final accountsOptions = AccountCache<AccountOptions>();
  final appsBlocs = AccountCache<AppsBloc>();
  final capabilitiesBlocs = AccountCache<CapabilitiesBloc>();
  final userDetailsBlocs = AccountCache<UserDetailsBloc>();
  final userStatusBlocs = AccountCache<UserStatusBloc>();
  final unifiedSearchBlocs = AccountCache<UnifiedSearchBloc>();

  @override
  void dispose() {
    unawaited(activeAccount.close());
    unawaited(accounts.close());
    appsBlocs.dispose();
    capabilitiesBlocs.dispose();
    userDetailsBlocs.dispose();
    userStatusBlocs.dispose();
    unifiedSearchBlocs.dispose();
    accountsOptions.dispose();
  }

  @override
  BehaviorSubject<List<Account>> accounts = BehaviorSubject<List<Account>>.seeded([]);

  @override
  BehaviorSubject<Account?> activeAccount = BehaviorSubject();

  @override
  void addAccount(Account account) {
    if (activeAccount.valueOrNull == null) {
      setActiveAccount(account);
    }
    accounts.add(accounts.value..add(account));
  }

  @override
  void removeAccount(Account account) {
    accounts.add(accounts.value..removeWhere((a) => a.id == account.id));

    final as = accounts.value;
    final aa = activeAccount.valueOrNull;
    if (aa?.id == account.id) {
      if (as.firstOrNull != null) {
        setActiveAccount(as.first);
      } else {
        activeAccount.add(null);
      }
    }

    unawaited(() async {
      try {
        await account.client.core.appPassword.deleteAppPassword();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
      }
    }());
  }

  @override
  void setActiveAccount(Account account) {
    if (activeAccount.valueOrNull != account) {
      activeAccount.add(account);
    }
  }

  @override
  void updateAccount(Account account) {
    final as = accounts.value;
    final index = as.indexWhere((a) => a.id == account.id);
    if (index == -1) {
      // TODO: Figure out how we can remove the old account without potentially race conditioning
      as.add(account);
    } else {
      as.replaceRange(
        index,
        index + 1,
        [account],
      );
    }

    accounts.add(as);
    setActiveAccount(account);
  }

  /// The currently active account.
  ///
  /// Equivalent to activeAccount.valueOrNull but throws a [StateError] when no user is logged in.
  @visibleForTesting
  Account get aa {
    final aa = activeAccount.valueOrNull;

    if (aa == null) {
      throw StateError('No user is logged in.');
    }

    return aa;
  }

  @override
  bool get hasAccounts => activeAccount.valueOrNull != null;

  @override
  AccountOptions get activeOptions => getOptionsFor(aa);

  @override
  AccountOptions getOptionsFor(Account account) => accountsOptions[account] ??= AccountOptions(
        AppStorage(StorageKeys.accounts, account.id),
        getAppsBlocFor(account),
      );

  @override
  AppsBloc get activeAppsBloc => getAppsBlocFor(aa);

  @override
  AppsBloc getAppsBlocFor(Account account) => appsBlocs[account] ??= AppsBloc(
        getCapabilitiesBlocFor(account),
        this,
        account,
        allAppImplementations,
      );

  @override
  CapabilitiesBloc get activeCapabilitiesBloc => getCapabilitiesBlocFor(aa);

  @override
  CapabilitiesBloc getCapabilitiesBlocFor(Account account) => capabilitiesBlocs[account] ??= CapabilitiesBloc(account);

  @override
  UserDetailsBloc get activeUserDetailsBloc => getUserDetailsBlocFor(aa);

  @override
  UserDetailsBloc getUserDetailsBlocFor(Account account) => userDetailsBlocs[account] ??= UserDetailsBloc(account);

  @override
  UserStatusBloc get activeUserStatusBloc => getUserStatusBlocFor(aa);

  @override
  UserStatusBloc getUserStatusBlocFor(Account account) => userStatusBlocs[account] ??= UserStatusBloc(account);

  @override
  UnifiedSearchBloc get activeUnifiedSearchBloc => getUnifiedSearchBlocFor(aa);

  @override
  UnifiedSearchBloc getUnifiedSearchBlocFor(Account account) => unifiedSearchBlocs[account] ??= UnifiedSearchBloc(
        getAppsBlocFor(account),
        account,
      );
}

/// Gets a list of logged in accounts from storage.
///
/// It is not checked whether the stored information is still valid.
List<Account> loadAccounts() {
  const storage = AppStorage(StorageKeys.accounts);

  if (storage.containsKey(_keyAccounts)) {
    return storage
        .getStringList(_keyAccounts)!
        .map((a) => Account.fromJson(json.decode(a) as Map<String, dynamic>))
        .toList();
  }
  return [];
}

/// Saves the given [accounts] to the storage.
Future<void> saveAccounts(List<Account> accounts) async {
  const storage = AppStorage(StorageKeys.accounts);
  final values = accounts.map((a) => json.encode(a.toJson())).toList();

  await storage.setStringList(_keyAccounts, values);
}
