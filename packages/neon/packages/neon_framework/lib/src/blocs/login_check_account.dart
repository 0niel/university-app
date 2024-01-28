import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/utils/user_agent.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/provisioning_api.dart' as provisioning_api;
import 'package:rxdart/rxdart.dart';

/// Bloc that checks that the account is ready for logging in.
sealed class LoginCheckAccountBloc implements InteractiveBloc {
  @internal
  factory LoginCheckAccountBloc(
    Uri serverURL,
    String loginName,
    String password,
  ) =>
      _LoginCheckAccountBloc(
        serverURL,
        loginName,
        password,
      );

  /// Contains the account for the user
  BehaviorSubject<Result<Account>> get state;
}

class _LoginCheckAccountBloc extends InteractiveBloc implements LoginCheckAccountBloc {
  _LoginCheckAccountBloc(
    this.serverURL,
    this.loginName,
    this.password,
  ) {
    unawaited(refresh());
  }

  final Uri serverURL;
  final String loginName;
  final String password;

  @override
  void dispose() {
    unawaited(state.close());

    super.dispose();
  }

  @override
  BehaviorSubject<Result<Account>> state = BehaviorSubject();

  @override
  Future<void> refresh() async {
    state.add(Result.loading());

    try {
      final client = NextcloudClient(
        serverURL,
        loginName: loginName,
        password: password,
        userAgentOverride: neonUserAgent,
      );

      final response = await client.provisioningApi.users.getCurrentUser();

      final account = Account(
        serverURL: serverURL,
        username: response.body.ocs.data.id,
        password: password,
        userAgent: neonUserAgent,
      );

      state.add(Result.success(account));
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      state.add(Result.error(e));
    }
  }
}
