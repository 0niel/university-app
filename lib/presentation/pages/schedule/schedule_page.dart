import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/schedule_settings_drawer.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/colorful_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/page_with_theme_consumer.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_switch_button.dart';
import '../../widgets/feedback_modal.dart';
import 'widgets/schedule_page_view.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';


class SchedulePage extends PageWithThemeConsumer {
  const SchedulePage({Key? key}) : super(key: key);

  Widget _buildGroupButton(
    BuildContext context,
    String group,
    String activeGroup,
    bool isActive,
    Schedule schedule,
  ) {
    if (isActive) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1.5,
              color: schedule.isRemote
                  ? AppTheme.colors.colorful05
                  : AppTheme.colors.colorful06,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: AppTextStyle.buttonL,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!schedule.isRemote)
                    Text('кэш',
                        style: AppTextStyle.buttonS
                            .copyWith(color: AppTheme.colors.colorful06)),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                    child: Icon(Icons.refresh_rounded,
                        color: schedule.isRemote
                            ? AppTheme.colors.colorful05
                            : AppTheme.colors.colorful06),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.colors.deactive),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: AppTextStyle.buttonL,
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      context
                          .read<ScheduleBloc>()
                          .add(ScheduleSetActiveGroupEvent(group: group));
                    },
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                    child: const Icon(Icons.check_rounded),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                    child: const Icon(Icons.refresh_rounded),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleDeleteEvent(
                          group: group, schedule: schedule));
                    },
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                    child: const Icon(Icons.delete_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) => Scaffold(
        endDrawer: ScheduleSettingsDrawer(
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                BlocBuilder<ScheduleBloc, ScheduleState>(
                    buildWhen: (prevState, currentState) {
                  if (currentState is ScheduleLoaded &&
                      prevState is ScheduleLoaded) {
                    if (prevState.activeGroup != currentState.activeGroup ||
                        prevState.downloadedScheduleGroups !=
                            currentState.downloadedScheduleGroups ||
                        prevState.schedule.isRemote !=
                            currentState.schedule.isRemote) return true;
                  }
                  if (currentState is ScheduleLoaded &&
                      prevState.runtimeType != ScheduleLoaded) return true;
                  return false;
                }, builder: (context, state) {
                  if (state is ScheduleLoaded ||
                      state is ScheduleActiveGroupEmpty) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state is ScheduleLoaded)
                            SettingsSwitchButton(
                              initialValue:
                                  state.scheduleSettings.showEmptyLessons,
                              svgPicture: SvgPicture.asset(
                                'assets/icons/lessons.svg',
                                height: 16,
                                width: 16,
                              ),
                              text: "Пустые пары",
                              onChanged: (value) {
                                context.read<ScheduleBloc>().add(
                                    ScheduleUpdateSettingsEvent(
                                        showEmptyLessons: value));
                              },
                            ),
                          // SizedBox(height: 10),
                          // SettingsSwitchButton(
                          //   initialValue:
                          //       state.scheduleSettings.showLessonsNumbers,
                          //   svgPicture: SvgPicture.asset(
                          //     'assets/icons/number.svg',
                          //     height: 16,
                          //     width: 16,
                          //   ),
                          //   text: "Номера пар",
                          //   onChanged: (value) {
                          //     context.read<ScheduleBloc>().add(
                          //         ScheduleUpdateSettingsEvent(
                          //             showLesonsNums: value));
                          //   },
                          // ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/add_group.svg',
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(width: 20),
                                        Text("Добавить группу",
                                            style: AppTextStyle.buttonL),
                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.05,
                                    child: Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              // onTap: () => _showModal(isFirstRun: false),
                              onTap: () => context.go('/schedule/select-group'),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/social-sharing.svg',
                                          height: 16,
                                          width: 16,
                                        ),
                                        const SizedBox(width: 20),
                                        Text("Проблемы с расписанием",
                                            style: AppTextStyle.buttonL),
                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.05,
                                    child: Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                final defaultText = state is ScheduleLoaded
                                    ? 'Возникла проблема с расписанием группы ${state.activeGroup}:\n\n'
                                    : null;

                                final userBloc = context.read<UserBloc>();

                                userBloc.state.maybeMap(
                                  logInSuccess: (value) =>
                                      FeedbackBottomModalSheet.show(
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
                          ),

                          if (state is ScheduleLoaded)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    "Группы".toUpperCase(),
                                    style: AppTextStyle.chip.copyWith(
                                        color: AppTheme.colors.deactiveDarker),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildGroupButton(
                                    context,
                                    state.activeGroup,
                                    state.activeGroup,
                                    true,
                                    state.schedule,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          state.downloadedScheduleGroups.length,
                                      itemBuilder: (context, index) {
                                        if (state.downloadedScheduleGroups[
                                                index] !=
                                            state.activeGroup) {
                                          return _buildGroupButton(
                                            context,
                                            state.downloadedScheduleGroups[
                                                index],
                                            state.activeGroup,
                                            false,
                                            state.schedule,
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    // Schedule not loaded info
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  "Группы".toUpperCase(),
                                  style: AppTextStyle.chip.copyWith(
                                      color: AppTheme.colors.deactiveDarker),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
        appBar: BlocProvider.of<ScheduleBloc>(context).state is ScheduleLoaded
            ? null
            : AppBar(
                title: const Text('Расписание'),
              ),
        body: Container(
          color: AppTheme.colors.background01,
          child: SafeArea(
            child: BlocBuilder<ScheduleBloc, ScheduleState>(
              buildWhen: (prevState, currentState) {
                if (prevState is ScheduleLoaded &&
                    currentState is ScheduleLoaded) {
                  return prevState != currentState;
                }
                return true;
              },
              builder: (context, state) {
                if (state is ScheduleLoading) {
                  // Add post frame callback to hide modal after build
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   if (_modalShown) {
                  //     _modalShown = false;
                  //     context.router.root.pop();
                  //   }
                  // });

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ScheduleLoaded) {
                  return SchedulePageView(schedule: state.schedule);
                } else if (state is ScheduleLoadError) {
                  return Column(
                    children: [
                      Text(
                        'Упс!',
                        style: AppTextStyle.h3,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.errorMessage,
                        style: AppTextStyle.bodyBold,
                      )
                    ],
                  );
                } else {
                  // return _NoActiveGroupFoundMessage(onTap: () => _showModal());
                  return _NoActiveGroupFoundMessage(
                      onTap: () => context.go('/schedule/select-group'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NoActiveGroupFoundMessage extends StatelessWidget {
  const _NoActiveGroupFoundMessage({Key? key, required this.onTap})
      : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTable = MediaQuery.of(context).size.width > tabletBreakpoint;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isTable ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/Saly-2.png',
                height: 200,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Не установлена активная группа",
              style: AppTextStyle.h5,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Скачайте расписание по крайней мере для одной группы, чтобы отобразить календарь.",
              style: AppTextStyle.captionL.copyWith(
                color: AppTheme.colors.deactive,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: isTable ? 420 : double.infinity,
              child: ColorfulButton(
                text: "Настроить",
                onClick: onTap,
                backgroundColor: AppTheme.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
