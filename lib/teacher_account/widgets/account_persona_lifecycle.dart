import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';

class AccountPersonaLifecycle extends StatefulWidget {
  const AccountPersonaLifecycle({required this.child, super.key});

  final Widget child;

  @override
  State<AccountPersonaLifecycle> createState() =>
      _AccountPersonaLifecycleState();
}

class _AccountPersonaLifecycleState extends State<AccountPersonaLifecycle> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _retryPending);
  }

  void _retryPending() {
    final account = context.read<AccountPersonaCubit>();
    final state = account.state;
    if (state.loaded &&
        !state.loading &&
        !state.saving &&
        (state.syncError || state.pendingSync)) {
      unawaited(account.retry());
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
