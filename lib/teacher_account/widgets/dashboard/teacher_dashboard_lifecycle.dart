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

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) => context.read<TeacherDashboardBloc>().add(
        TeacherDashboardEvent.activityChanged(
          active: state == AppLifecycleState.resumed,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
