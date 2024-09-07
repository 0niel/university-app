import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/profile_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/container_label.dart';
import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/presentation/widgets/feedback_modal.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
      ),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _InitialProfileStatePage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InitialProfileStatePage extends StatefulWidget {
  const _InitialProfileStatePage({Key? key}) : super(key: key);

  @override
  State<_InitialProfileStatePage> createState() => _InitialProfileStatePageState();
}

class _InitialProfileStatePageState extends State<_InitialProfileStatePage> {
  void _onFeedbackTap(BuildContext context) {
    var defaultText = 'Возникла проблема с расписанием';
    final state = context.read<ScheduleBloc>().state;

    if (state.status == ScheduleStatus.loaded && state.selectedSchedule != null) {
      if (state.selectedSchedule is SelectedGroupSchedule) {
        defaultText += ' группы ${(state.selectedSchedule as SelectedGroupSchedule).group.name}';
      } else if (state.selectedSchedule is SelectedTeacherSchedule) {
        defaultText += ' преподавателя ${(state.selectedSchedule as SelectedTeacherSchedule).teacher.name}';
      } else if (state.selectedSchedule is SelectedClassroomSchedule) {
        defaultText += ' аудитории ${(state.selectedSchedule as SelectedClassroomSchedule).classroom.name}';
      }
    }

    final userBloc = context.read<UserBloc>();

    if (userBloc.state.status == UserStatus.authorized) {
      FeedbackBottomModalSheet.show(
        context,
        defaultText: defaultText,
        defaultEmail: userBloc.state.user!.email,
      );
    } else {
      FeedbackBottomModalSheet.show(
        context,
        defaultText: defaultText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ContainerLabel(label: "Управление расписанием"),
        const SizedBox(height: 8),
        ScheduleManagementSection(onFeedbackTap: _onFeedbackTap),
        const SizedBox(height: 24),
        const ContainerLabel(label: "Общее"),
        const SizedBox(height: 8),
        ProfileButton(
          text: 'О приложении',
          icon: HugeIcon(icon: HugeIcons.strokeRoundedCoffee02, color: AppTheme.colorsOf(context).active),
          onPressed: () => context.go('/profile/about'),
        ),
        const SizedBox(height: 8),
        ProfileButton(
          text: 'Тема',
          icon: HugeIcon(icon: HugeIcons.strokeRoundedMoon02, color: AppTheme.colorsOf(context).active),
          onPressed: () => context.go('/profile/settings'),
        ),
      ],
    );
  }
}
