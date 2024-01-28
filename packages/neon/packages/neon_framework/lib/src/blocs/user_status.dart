import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/platform.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/timer.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/models/disposable.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/user_status.dart' as user_status;
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

/// Bloc for managing user statuses.
sealed class UserStatusBloc implements Disposable {
  @internal
  factory UserStatusBloc(Account account) => _UserStatusBloc(account);

  /// Load the user status of the user with the [username] on the same server.
  ///
  /// Set [force] to true to load the status even if one has already been loaded.
  void load(String username, {bool force = false});

  /// All user status mapped by username.
  BehaviorSubject<Map<String, Result<user_status.$PublicInterface>>> get statuses;
}

class _UserStatusBloc extends InteractiveBloc implements UserStatusBloc {
  _UserStatusBloc(
    this.account,
  ) {
    unawaited(refresh());
    timer = TimerBloc().registerTimer(const Duration(minutes: 5), refresh);
  }

  final Account account;
  late final NeonTimer timer;

  @override
  void dispose() {
    timer.cancel();
    unawaited(statuses.close());
    super.dispose();
  }

  @override
  final statuses = BehaviorSubject<Map<String, Result<user_status.$PublicInterface>>>.seeded({});

  @override
  Future<void> refresh() async {
    await Future.wait(statuses.value.keys.map((username) => load(username, force: true)));
  }

  @override
  Future<void> load(String username, {bool force = false}) async {
    if (!force && statuses.value.containsKey(username) && !statuses.value[username]!.hasError) {
      return;
    }

    try {
      updateStatus(username, statuses.value[username]?.asLoading() ?? Result.loading());

      user_status.$PublicInterface? data;

      if (account.username == username) {
        var isAway = false;
        if (NeonPlatform.instance.canUseWindowManager) {
          final focused = await windowManager.isFocused();
          final visible = await windowManager.isVisible();
          isAway = !focused || !visible;
        }
        try {
          final response = await account.client.userStatus.heartbeat.heartbeat(
            status: isAway ? 'away' : 'online',
          );
          data = response.body.ocs.data;
        } catch (e) {
          // 204 is returned if the heartbeat failed because the current status is different. Ignore this and fetch the normal status
          if (e is! DynamiteStatusCodeException || e.statusCode != 204) {
            rethrow;
          }
        }
      }

      if (data == null) {
        final response = await account.client.userStatus.statuses.find(userId: username);
        data = response.body.ocs.data;
      }

      updateStatus(username, Result.success(data));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      updateStatus(username, Result.error(e));
    }
  }

  void updateStatus(String username, Result<user_status.$PublicInterface> result) {
    statuses.add({
      ...statuses.value,
      username: result,
    });
  }
}
