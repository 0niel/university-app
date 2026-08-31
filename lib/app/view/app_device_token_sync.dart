import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/services/device_token_sync_controller.dart';

class AppDeviceTokenSync extends StatefulWidget {
  const AppDeviceTokenSync({
    required this.controller,
    required this.child,
    super.key,
  });

  final DeviceTokenSyncController? controller;
  final Widget child;

  @override
  State<AppDeviceTokenSync> createState() => _AppDeviceTokenSyncState();
}

class _AppDeviceTokenSyncState extends State<AppDeviceTokenSync> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_handleAuthState(context.read<AppBloc>().state));
    });
  }

  @override
  void didUpdateWidget(covariant AppDeviceTokenSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.controller, widget.controller)) return;
    unawaited(oldWidget.controller?.pause());
    if (context.read<AppBloc>().state.status.isLoggedIn) unawaited(_start());
  }

  @override
  void dispose() {
    unawaited(widget.controller?.pause());
    super.dispose();
  }

  Future<void> _start() async {
    try {
      await widget.controller?.start();
    } on Exception catch (error, stackTrace) {
      log('Device token sync failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _handleAuthState(AppState state) async {
    if (state.status.isLoggedIn) {
      await _start();
      return;
    }
    try {
      await widget.controller?.stopAndUnregister();
    } on Exception catch (error, stackTrace) {
      log('Device token cleanup failed', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        unawaited(_handleAuthState(state));
      },
      child: widget.child,
    );
  }
}
