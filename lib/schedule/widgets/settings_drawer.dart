import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/feedback_modal.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';

import '../models/models.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.colors.background01,
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                bottom: 24,
                top: 24,
                right: 16,
              ),
              child: Text("Настройки", style: AppTextStyle.title),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ScheduleDrawerButton(
                  text: "Добавить группу",
                  icon: SvgPicture.asset(
                    'assets/icons/add_group.svg',
                    height: 16,
                    width: 16,
                  ),
                  onTap: () => context.go('/schedule/search'),
                ),
                const SizedBox(height: 16),
                ScheduleDrawerButton(
                  text: "Проблемы с расписанием",
                  icon: SvgPicture.asset(
                    'assets/icons/social-sharing.svg',
                    height: 16,
                    width: 16,
                  ),
                  onTap: () {
                    var defaultText = 'Возникла проблема с расписанием';

                    final state = context.read<ScheduleBloc>().state;

                    if (state.status == ScheduleStatus.loaded &&
                        state.selectedSchedule != null) {
                      if (state.selectedSchedule is SelectedGroupSchedule) {
                        defaultText +=
                            ' группы ${(state.selectedSchedule as SelectedGroupSchedule).group.name}';
                      } else if (state.selectedSchedule
                          is SelectedTeacherSchedule) {
                        defaultText +=
                            ' преподавателя ${(state.selectedSchedule as SelectedTeacherSchedule).teacher.name}';
                      } else if (state.selectedSchedule
                          is SelectedClassroomSchedule) {
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
                  },
                ),
              ],
            ),
            const SchedulesList(),
          ],
        ),
      ),
    );
  }
}
