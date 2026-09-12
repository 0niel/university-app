import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';

class NfcSessionAccountBoundary extends StatefulWidget {
  const NfcSessionAccountBoundary({
    required this.synchronizeSessionAccount,
    required this.organizationId,
    required this.child,
    super.key,
  });

  final Future<void> Function(String? accountId) synchronizeSessionAccount;
  final String organizationId;
  final Widget child;

  @override
  State<NfcSessionAccountBoundary> createState() =>
      _NfcSessionAccountBoundaryState();
}

class _NfcSessionAccountBoundaryState extends State<NfcSessionAccountBoundary> {
  @override
  void initState() {
    super.initState();
    _synchronizeAccount(context.read<AppBloc>().state);
  }

  @override
  void didUpdateWidget(NfcSessionAccountBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.organizationId != widget.organizationId ||
        oldWidget.synchronizeSessionAccount !=
            widget.synchronizeSessionAccount) {
      _synchronizeAccount(context.read<AppBloc>().state);
    }
  }

  void _synchronizeAccount(AppState state) {
    final accountId = state.user.id.isEmpty
        ? null
        : '${Uri.encodeComponent(widget.organizationId)}:'
              '${Uri.encodeComponent(state.user.id)}';
    unawaited(
      Future<void>.sync(
        () => widget.synchronizeSessionAccount(accountId),
      ).onError((_, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: StateError(
              'Unable to restore the digital-pass session.',
            ),
            stack: stackTrace,
            library: 'digital-pass session',
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) => BlocListener<AppBloc, AppState>(
    listenWhen: (previous, current) => previous.user.id != current.user.id,
    listener: (_, state) => _synchronizeAccount(state),
    child: widget.child,
  );
}
