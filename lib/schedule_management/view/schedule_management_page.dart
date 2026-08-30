import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/utils/utils.dart';
import 'package:rtu_mirea_app/schedule_management/view/add_schedule_page.dart';
import 'package:rtu_mirea_app/schedule_management/view/edit_schedules_page.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';

part 'hub_body.dart';
part 'hub_empty.dart';
part 'hub_error.dart';
part 'hub_section.dart';
part 'hub_row_skeleton.dart';
part 'hub_skeleton.dart';
part 'schedule_management_view.dart';

class ScheduleManagementPage extends StatelessWidget {
  const ScheduleManagementPage({super.key});

  @override
  Widget build(BuildContext context) => const ScheduleManagementView();
}
