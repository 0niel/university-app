import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:nextcloud/uppush.dart' as uppush;
import 'package:rxdart/rxdart.dart';

/// Bloc for checking NextPush compatibility.
sealed class NextPushBloc implements Disposable {
  @internal
  factory NextPushBloc(
    AccountsBloc accountsBloc,
    GlobalOptions globalOptions, {
    bool disabled = false,
  }) =>
      _NextPushBloc(
        accountsBloc,
        globalOptions,
        disabled: disabled,
      );

  /// Emits if NextPush is supported by the server.
  BehaviorSubject<void> get onNextPushSupported;
}

class _NextPushBloc extends Bloc implements NextPushBloc {
  _NextPushBloc(
    this.accountsBloc,
    this.globalOptions, {
    bool disabled = false,
  }) {
    if (disabled) {
      return;
    }
    Rx.merge([
      globalOptions.pushNotificationsEnabled.stream,
      globalOptions.pushNotificationsDistributor.stream,
      accountsBloc.accounts,
    ]).debounceTime(const Duration(milliseconds: 100)).listen((_) async {
      if (!globalOptions.pushNotificationsEnabled.enabled || !globalOptions.pushNotificationsEnabled.value) {
        return;
      }
      if (globalOptions.pushNotificationsDistributor.value != null) {
        return;
      }
      if (globalOptions.pushNotificationsDistributor.values.containsKey(unifiedPushNextPushID)) {
        // NextPush is already installed
        return;
      }

      var isSupported = false;
      for (final account in accountsBloc.accounts.value) {
        if (!supported.containsKey(account)) {
          try {
            final response = await account.client.uppush.check();
            supported[account] = response.body.success;
          } catch (e, s) {
            debugPrint(e.toString());
            debugPrint(s.toString());
            supported[account] = false;
          }
        }
        if (supported[account]!) {
          isSupported = true;
          break;
        }
      }

      if (!isSupported) {
        return;
      }

      if (onNextPushSupported.hasValue) {
        return;
      }
      onNextPushSupported.add(null);
    });
  }

  final AccountsBloc accountsBloc;
  final GlobalOptions globalOptions;
  final supported = <Account, bool>{};

  @override
  void dispose() {
    unawaited(onNextPushSupported.close());
  }

  @override
  BehaviorSubject<void> onNextPushSupported = BehaviorSubject();
}
