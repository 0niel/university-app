import 'dart:async';

import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/bloc.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/utils/request_manager.dart';
import 'package:nextcloud/core.dart' as core;
import 'package:rxdart/rxdart.dart';

/// Bloc that manages the server capabilities
@sealed
abstract class CapabilitiesBloc implements InteractiveBloc {
  /// Creates a new capabilities bloc.
  @internal
  factory CapabilitiesBloc(Account account) => _CapabilitiesBloc(account);

  /// The capabilities of the server.
  BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>> get capabilities;
}

class _CapabilitiesBloc extends InteractiveBloc implements CapabilitiesBloc {
  _CapabilitiesBloc(
    this.account,
  ) {
    unawaited(refresh());
  }

  final Account account;

  @override
  void dispose() {
    unawaited(capabilities.close());
    super.dispose();
  }

  @override
  BehaviorSubject<Result<core.OcsGetCapabilitiesResponseApplicationJson_Ocs_Data>> capabilities = BehaviorSubject();

  @override
  Future<void> refresh() async {
    await RequestManager.instance.wrapNextcloud(
      account: account,
      cacheKey: 'capabilities',
      subject: capabilities,
      rawResponse: account.client.core.ocs.getCapabilitiesRaw(),
      unwrap: (response) => response.body.ocs.data,
    );
  }
}
