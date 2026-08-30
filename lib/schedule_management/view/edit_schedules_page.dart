import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/utils/utils.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'edit_schedules_view.dart';
part 'edit_body.dart';
part 'edit_entry.dart';
part 'reorderable_section.dart';
part 'edit_row.dart';

class EditSchedulesPage extends StatelessWidget {
  const EditSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) => const EditSchedulesView();
}
