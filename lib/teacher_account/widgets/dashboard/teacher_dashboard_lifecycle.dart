import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';

class TeacherDashboardLifecycle extends StatefulWidget {
  const TeacherDashboardLifecycle({required this.child, super.key});

  final Widget child;

  @override
  State<TeacherDashboardLifecycle> createState() =>
      _TeacherDashboardLifecycleState();
}

class _TeacherDashboardLifecycleState extends State<TeacherDashboardLifecycle> {
  late final AppLifecycleListener _lifecycle;
  ValueListenable<TickerModeData>? _tickerMode;
  bool? _active;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (_) => _syncActivity(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tickerMode = TickerMode.getValuesNotifier(context);
    if (identical(tickerMode, _tickerMode)) return;
    _tickerMode?.removeListener(_syncActivity);
    _tickerMode = tickerMode;
    _tickerMode?.addListener(_syncActivity);
    _syncActivity();
  }

  void _syncActivity() {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    final active =
        _tickerMode?.value.enabled == true &&
        (lifecycle == null || lifecycle == AppLifecycleState.resumed);
    if (_active == active) return;
    _active = active;
    context.read<TeacherDashboardBloc>().add(
      TeacherDashboardEvent.activityChanged(active: active),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _tickerMode?.removeListener(_syncActivity);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
