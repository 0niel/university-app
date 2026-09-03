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
  Future<void> _controllerReady = Future.value();
  final _retiring = <DeviceTokenSyncController>[];
  var _controllerRevision = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_synchronize());
    });
  }

  @override
  void didUpdateWidget(covariant AppDeviceTokenSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.controller, widget.controller)) return;
    _controllerRevision++;
    if (oldWidget.controller case final controller?) {
      _retiring.add(controller);
      unawaited(controller.pause());
    }
    unawaited(_synchronize());
  }

  @override
  void dispose() {
    unawaited(widget.controller?.pause());
    super.dispose();
  }

  Future<void> _synchronize() async {
    final controller = widget.controller;
    final revision = _controllerRevision;
    try {
      await _prepareControllers();
      if (!mounted || revision != _controllerRevision) return;
      final state = context.read<AppBloc>().state;
      await controller?.synchronizeUser(
        state.status.isLoggedIn ? state.user.id : null,
      );
    } on Exception catch (error, stackTrace) {
      log('Device token sync failed', error: error, stackTrace: stackTrace);
    }
  }

  Future<void> _prepareControllers() {
    final result = _controllerReady.then((_) async {
      while (_retiring.isNotEmpty) {
        await _retiring.first.invalidate();
        _retiring.removeAt(0);
      }
    });
    _controllerReady = result.then<void>(
      (_) => null,
      onError: (Object _, StackTrace _) => null,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.user.id != current.user.id,
      listener: (context, state) {
        unawaited(_synchronize());
      },
      child: widget.child,
    );
  }
}
