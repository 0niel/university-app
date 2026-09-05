import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_app_accent.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_refresh_surface.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';
import 'package:stac_bridge/stac_bridge.dart';

class MiniAppInnerScreenController {
  _MiniAppInnerScreenState? _state;

  String? get path => _state?.widget.path;

  Future<void> refresh() => _state?._reload() ?? Future<void>.value();
}

class MiniAppInnerScreen extends StatefulWidget {
  const MiniAppInnerScreen({
    required this.path,
    required this.title,
    super.key,
    this.accentColor,
    this.controller,
  });

  final String path;
  final String title;
  final String? accentColor;
  final MiniAppInnerScreenController? controller;

  @override
  State<MiniAppInnerScreen> createState() => _MiniAppInnerScreenState();
}

class _MiniAppInnerScreenState extends State<MiniAppInnerScreen> {
  Map<String, dynamic>? _screen;
  Future<void>? _request;
  Future<void>? _foregroundRequest;
  bool _requestSilent = false;
  Timer? _refreshTimer;
  bool _failed = false;
  bool _refreshing = false;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
    unawaited(_reload());
  }

  @override
  void didUpdateWidget(MiniAppInnerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
    if (oldWidget.path != widget.path) {
      _requestId += 1;
      _request = null;
      _foregroundRequest = null;
      _screen = null;
      _failed = false;
      unawaited(_reload());
    }
  }

  Future<void> _reload({bool silent = false}) {
    final active = _request;
    if (active != null) {
      if (!silent && !_refreshing && _screen != null) {
        setState(() => _refreshing = true);
      }
      if (!silent && _requestSilent) return _queueForegroundRequest(active);
      return active;
    }
    _refreshTimer?.cancel();
    final requestId = ++_requestId;
    setState(() {
      _failed = false;
      _refreshing = !silent && _screen != null;
    });
    _requestSilent = silent;
    late final Future<void> future;
    future = _fetchScreen(requestId).whenComplete(() {
      if (identical(_request, future)) _request = null;
    });
    _request = future;
    return future;
  }

  Future<void> _queueForegroundRequest(Future<void> active) {
    final queued = _foregroundRequest;
    if (queued != null) return queued;
    final requestId = _requestId;
    late final Future<void> future;
    future = active
        .then((_) async {
          if (mounted && requestId == _requestId) await _reload();
        })
        .whenComplete(() {
          if (identical(_foregroundRequest, future)) _foregroundRequest = null;
        });
    _foregroundRequest = future;
    return future;
  }

  Future<void> _fetchScreen(int requestId) async {
    Map<String, dynamic>? screen;
    try {
      screen = await context.read<MiniAppRunnerCubit>().fetchPage(widget.path);
    } on Exception {
      screen = null;
    }
    if (!mounted || requestId != _requestId) return;
    if (_requestSilent && _foregroundRequest != null) return;
    setState(() {
      _failed = screen == null;
      _screen = screen ?? _screen;
      _refreshing = false;
    });
    final interval = _screen?['refreshIntervalSeconds'];
    if (interval is num && interval > 0) {
      _refreshTimer = Timer(
        Duration(seconds: interval.toInt().clamp(5, 3600)),
        () => unawaited(_reload(silent: true)),
      );
    }
  }

  @override
  void dispose() {
    _requestId += 1;
    _refreshTimer?.cancel();
    widget.controller?._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor;
    return MiniAppScaffold(
      title: widget.title,
      body: Builder(
        builder: (context) {
          final screen = _screen;
          if (screen == null) {
            return _failed
                ? _error(context, key: const ValueKey('inner-failure'))
                : const MiniAppRunnerSkeleton(key: ValueKey('inner-loading'));
          }
          return KeyedSubtree(
            key: const ValueKey('inner-ready'),
            child: MiniAppAccentTheme(
              accentColor: accentColor,
              child: MiniAppRefreshSurface(
                refreshing: _refreshing,
                failed: _failed,
                onRetry: () => unawaited(_reload()),
                child: Builder(
                  builder: (themedContext) =>
                      StacBridge.render(screen, themedContext) ??
                      _error(
                        themedContext,
                        key: const ValueKey('inner-render-error'),
                        renderError: true,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _error(
    BuildContext context, {
    required Key key,
    bool renderError = false,
  }) {
    final l10n = context.l10n;
    return Center(
      key: key,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xlg,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        child: AppErrorState(
          lineIcon: renderError ? AppLineIcon.grid : AppLineIcon.wifiOff,
          title: renderError ? l10n.miniAppsRunnerError : l10n.loadingError,
          message: renderError ? null : l10n.tryAgain,
          footnote: null,
          primaryLabel: l10n.retry,
          onPrimary: () => unawaited(_reload()),
        ),
      ),
    );
  }
}
