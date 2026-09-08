import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

class AppScheduleRefresh extends StatefulWidget {
  const AppScheduleRefresh({required this.child, super.key});

  final Widget child;

  @override
  State<AppScheduleRefresh> createState() => _AppScheduleRefreshState();
}

class _AppScheduleRefreshState extends State<AppScheduleRefresh>
    with WidgetsBindingObserver {
  ScheduleBloc? _bloc;
  Timer? _timer;
  DateTime? _lastRequested;

  bool get _foreground =>
      WidgetsBinding.instance.lifecycleState == null ||
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = context.read<ScheduleBloc>();
    if (identical(bloc, _bloc)) return;
    _bloc = bloc;
    _lastRequested = null;
    _sync();
  }

  void _refresh() {
    final bloc = _bloc;
    if (bloc == null || bloc.isClosed || !_foreground) return;
    final now = clock.now();
    final last = _lastRequested;
    if (last != null &&
        !now.isBefore(last) &&
        now.difference(last) < const Duration(minutes: 1)) {
      return;
    }
    _lastRequested = now;
    bloc.add(const SelectedScheduleRefreshRequested());
  }

  void _sync() {
    _timer?.cancel();
    _timer = null;
    if (!_foreground) return;
    _refresh();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _refresh());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _sync();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
