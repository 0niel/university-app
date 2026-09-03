import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

mixin ScheduleClockTicker<T extends StatefulWidget> on State<T> {
  Timer? _clockTicker;
  ValueListenable<TickerModeData>? _tickerMode;

  bool get isClockTickNeeded;

  void onClockTick();

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
  void dispose() {
    _tickerMode?.removeListener(_syncClockTicker);
    _clockTicker?.cancel();
    super.dispose();
  }

  void _syncClockTicker() {
    _clockTicker?.cancel();
    _clockTicker = null;
    if (_tickerMode?.value.enabled != true) return;
    _clockTicker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && isClockTickNeeded) onClockTick();
    });
  }
}
