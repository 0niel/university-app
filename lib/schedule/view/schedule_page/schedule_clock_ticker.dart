import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

mixin ScheduleClockTicker<T extends StatefulWidget> on State<T> {
  Timer? _clockTicker;
  ValueListenable<TickerModeData>? _tickerMode;
  AppLifecycleListener? _lifecycleListener;
  bool _refreshPending = false;

  bool get isClockTickNeeded;

  void onClockTick();

  bool get _canTick =>
      mounted &&
      isClockTickNeeded &&
      _tickerMode?.value.enabled == true &&
      (WidgetsBinding.instance.lifecycleState == null ||
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed);

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (_) => _syncClockTicker(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tickerMode = TickerMode.getValuesNotifier(context);
    if (identical(tickerMode, _tickerMode)) return;
    _tickerMode?.removeListener(_syncClockTicker);
    _tickerMode = tickerMode..addListener(_syncClockTicker);
    _syncClockTicker();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncClockTicker();
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    _tickerMode?.removeListener(_syncClockTicker);
    _clockTicker?.cancel();
    super.dispose();
  }

  void _syncClockTicker() {
    _clockTicker?.cancel();
    _clockTicker = null;
    if (!_canTick) return;
    _scheduleClockTick();
    if (_refreshPending) return;
    _refreshPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshPending = false;
      if (_canTick) onClockTick();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _scheduleClockTick() {
    final now = clock.now();
    final remaining =
        const Duration(minutes: 1) -
        Duration(
          seconds: now.second,
          milliseconds: now.millisecond,
          microseconds: now.microsecond,
        );
    _clockTicker = Timer(remaining, () {
      _clockTicker = null;
      if (!_canTick) return;
      onClockTick();
      _scheduleClockTick();
    });
  }
}
