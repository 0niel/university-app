import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/utils/user_agent.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:nextcloud/nextcloud.dart';
import 'package:rxdart/rxdart.dart';

/// Bloc for running the Nextcloud Login Flow V2.
sealed class LoginFlowBloc implements InteractiveBloc {
  @internal
  factory LoginFlowBloc(Uri serverURL) => _LoginFlowBloc(serverURL);

  /// Contains the initialization of the login flow.
  BehaviorSubject<Result<core.LoginFlowV2>> get init;

  /// Emits the result of the login flow.
  ///
  /// Only gets called when the login flow was successful.
  Stream<core.LoginFlowV2Credentials> get result;
}

class _LoginFlowBloc extends InteractiveBloc implements LoginFlowBloc {
  _LoginFlowBloc(this.serverURL) {
    unawaited(refresh());
  }

  final Uri serverURL;
  late final client = NextcloudClient(
    serverURL,
    userAgentOverride: neonUserAgent,
  );
  final resultController = StreamController<core.LoginFlowV2Credentials>();

  Timer? pollTimer;

  @override
  void dispose() {
    cancelPollTimer();
    unawaited(init.close());
    unawaited(resultController.close());

    super.dispose();
  }

  @override
  BehaviorSubject<Result<core.LoginFlowV2>> init = BehaviorSubject();

  @override
  late Stream<core.LoginFlowV2Credentials> result = resultController.stream.asBroadcastStream();

  @override
  Future<void> refresh() async {
    try {
      init.add(Result.loading());

      final initResponse = await client.core.clientFlowLoginV2.init();
      init.add(Result.success(initResponse.body));

      cancelPollTimer();
      pollTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
        try {
          final resultResponse = await client.core.clientFlowLoginV2.poll(token: initResponse.body.poll.token);
          cancelPollTimer();
          resultController.add(resultResponse.body);
        } catch (e, s) {
          debugPrint(e.toString());
          debugPrint(s.toString());
        }
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      init.add(Result.error(e));
    }
  }

  void cancelPollTimer() {
    if (pollTimer != null) {
      pollTimer!.cancel();
      pollTimer = null;
    }
  }
}
