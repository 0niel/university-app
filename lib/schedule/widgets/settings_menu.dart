import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/feedback_modal.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_switch_button.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';

import '../models/models.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useSafeArea: true,
      context: context,
      builder: (context) => const SettingsMenu(),
    );
  }

  void _onFeedbackTap(BuildContext context) {
    var defaultText = 'Возникла проблема с расписанием';

    final state = context.read<ScheduleBloc>().state;

    if (state.status == ScheduleStatus.loaded &&
        state.selectedSchedule != null) {
      if (state.selectedSchedule is SelectedGroupSchedule) {
        defaultText +=
            ' группы ${(state.selectedSchedule as SelectedGroupSchedule).group.name}';
      } else if (state.selectedSchedule is SelectedTeacherSchedule) {
        defaultText +=
            ' преподавателя ${(state.selectedSchedule as SelectedTeacherSchedule).teacher.name}';
      } else if (state.selectedSchedule is SelectedClassroomSchedule) {
        defaultText +=
            ' аудитории ${(state.selectedSchedule as SelectedClassroomSchedule).classroom.name}';
      }
    }

    final userBloc = context.read<UserBloc>();

    userBloc.state.maybeMap(
      logInSuccess: (value) => FeedbackBottomModalSheet.show(
        context,
        defaultText: defaultText,
        defaultEmail: value.user.email,
      ),
      orElse: () => FeedbackBottomModalSheet.show(
        context,
        defaultText: defaultText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.colors.background01,
      ),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ScheduleDrawerButton(
                text: "Добавить расписание",
                icon: SvgPicture.asset(
                  'assets/icons/add_group.svg',
                  height: 16,
                  width: 16,
                ),
                onTap: () => context.go('/schedule/search'),
              ),
              ScheduleDrawerButton(
                text: "Проблемы с расписанием",
                icon: SvgPicture.asset(
                  'assets/icons/social-sharing.svg',
                  height: 16,
                  width: 16,
                ),
                onTap: () => _onFeedbackTap(context),
              ),
              SizedBox(
                height: 60,
                child: SettingsSwitchButton(
                  initialValue: state.isMiniature,
                  svgPicture: SvgPicture.asset(
                    'assets/icons/lessons.svg',
                    height: 16,
                    width: 16,
                  ),
                  text: "Компактный вид",
                  onChanged: (value) {
                    context
                        .read<ScheduleBloc>()
                        .add(ScheduleSetDisplayMode(isMiniature: value));
                  },
                ),
              ),
            ],
          ),
          const SchedulesList(),
        ],
      ),
    );
  }
}
