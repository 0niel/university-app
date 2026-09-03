import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';

class ScheduleLocalScope extends StatelessWidget {
  const ScheduleLocalScope({required this.child, super.key});

  final Widget child;

  static bool _has<T>(BuildContext context) {
    try {
      context.read<T>();
      return true;
    } on Object catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = child;
    if (!_has<ScheduleDisplayCubit>(context)) {
      body = BlocProvider(
        create: (_) => ScheduleDisplayCubit(),
        child: body,
      );
    }
    if (!_has<LessonRemindersCubit>(context)) {
      body = BlocProvider(
        create: (_) => LessonRemindersCubit(),
        child: body,
      );
    }
    return body;
  }
}
