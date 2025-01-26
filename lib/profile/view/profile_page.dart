import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:app_ui/app_ui.dart';

import 'package:rtu_mirea_app/profile/widgets/widgets.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            return const CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: _InitialProfileStatePage(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InitialProfileStatePage extends StatefulWidget {
  const _InitialProfileStatePage();

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
          icon:
              HugeIcon(icon: HugeIcons.strokeRoundedCoffee02, color: Theme.of(context).extension<AppColors>()!.active),
          onPressed: () => context.go('/profile/about'),
        ),
        const SizedBox(height: 8),
        ProfileButton(
          text: 'Тема',
          icon: HugeIcon(icon: HugeIcons.strokeRoundedMoon02, color: Theme.of(context).extension<AppColors>()!.active),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: Text("Выбор темы", style: AppTextStyle.titleS),
                contentPadding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).extension<AppColors>()!.background02,
                elevation: 0,
                children: [
                  ListTileThemeItem(
                    title: "Светлая",
                    trailing: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
                        ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                        : null,
                    onTap: () {
                      AdaptiveTheme.of(context).setLight();
                      context.pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTileThemeItem(
                    title: "Тёмная",
                    trailing: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                        ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                        : null,
                    onTap: () {
                      AdaptiveTheme.of(context).setDark();
                      context.pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  ListTileThemeItem(
                    title: "Как в системе",
                    trailing: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system
                        ? Icon(Icons.check, color: Theme.of(context).extension<AppColors>()!.active)
                        : null,
                    onTap: () {
                      AdaptiveTheme.of(context).setSystem();
                      context.pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
