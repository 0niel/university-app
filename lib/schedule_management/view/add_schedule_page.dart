import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'add_schedule_view.dart';
part 'add_schedule_results.dart';
part 'add_schedule_results_skeleton.dart';
part 'add_schedule_row_skeleton.dart';
part 'add_schedule_result_row.dart';
part 'create_schedule_row.dart';
part 'empty_schedule_results.dart';
part 'schedule_zero_state.dart';

class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        scheduleRepository: context.read(),
        friendsRepository: context.read(),
        campusRepository: context.read(),
      ),
      child: Scaffold(
        backgroundColor: context.ninja.canvas,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: context.ninja.canvas,
              surfaceTintColor: Colors.transparent,
              title: Text(
                context.l10n.addScheduleTitle,
                style: NinjaText.headline.copyWith(color: context.ninja.ink),
              ),
            ),
          ],
          body: const AddScheduleView(),
        ),
      ),
    );
  }
}
