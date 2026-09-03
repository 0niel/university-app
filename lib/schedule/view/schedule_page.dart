import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_body.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_scope.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScheduleLocalScope(child: ScheduleBody());
  }
}
