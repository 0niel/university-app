import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/schedule_settings_modal.dart';
import 'package:rtu_mirea_app/presentation/widgets/settings_switch_button.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/schedule_page_view.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool _modalShown = false;

  //  Current State of InnerDrawerState
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildGroupButton(
      String group, String activeGroup, bool isActive, Schedule schedule) {
    if (isActive) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: DarkTextTheme.buttonL,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!schedule.isRemote)
                    Text('кэш',
                        style: DarkTextTheme.buttonS
                            .copyWith(color: DarkThemeColors.colorful06)),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    child: Icon(Icons.refresh_rounded,
                        color: schedule.isRemote
                            ? DarkThemeColors.colorful05
                            : DarkThemeColors.colorful06),
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1.5,
              color: schedule.isRemote
                  ? DarkThemeColors.colorful05
                  : DarkThemeColors.colorful06,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group,
                style: DarkTextTheme.buttonL,
              ),
              Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      context
                          .read<ScheduleBloc>()
                          .add(ScheduleSetActiveGroupEvent(group));
                    },
                    child: const Icon(Icons.check_rounded),
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    child: const Icon(Icons.refresh_rounded),
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleDeleteEvent(
                          group: group, schedule: schedule));
                    },
                    child: const Icon(Icons.delete_rounded),
                    shape: const CircleBorder(),
                    constraints:
                        const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DarkThemeColors.deactive),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InnerDrawer(
        key: _innerDrawerKey,
        offset: IDOffset.horizontal(
            (100 / (MediaQuery.of(context).size.width / 250)) / 100),
        swipeChild: true,
        onTapClose: true,
        boxShadow: const [],
        rightChild: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Управление расписанием и группами',
                    style: DarkTextTheme.h6,
                  ),
                ),
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
                                            style: DarkTextTheme.buttonL),
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
                                if (!_modalShown) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        const ScheduleSettingsModal(
                                            isFirstRun: false),
                                  ).whenComplete(() {
                                    _modalShown = false;
                                  });
                                }
                                _modalShown = true;
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
                                    style: DarkTextTheme.chip.copyWith(
                                        color: DarkThemeColors.deactiveDarker),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildGroupButton(
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
                    return Container();
                  }
                }),
              ],
            ),
          ),
        ),
        scaffold: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Расписание',
              style: DarkTextTheme.title,
            ),
            backgroundColor: DarkThemeColors.background01,
            actions: [
              IconButton(
                icon: const Icon(Icons.dehaze),
                onPressed: () {
                  _innerDrawerKey.currentState!.toggle();
                },
              ),
            ],
          ),
          body: SafeArea(
            child: BlocConsumer<ScheduleBloc, ScheduleState>(
              buildWhen: (prevState, currentState) {
                if (prevState is ScheduleLoaded &&
                    currentState is ScheduleLoaded) {
                  return prevState != currentState;
                }
                return true;
              },
              listener: (context, state) {
                if (state is ScheduleActiveGroupEmpty) {
                  if (!_modalShown) {
                    showModalBottomSheet(
                      useRootNavigator: false,
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          const ScheduleSettingsModal(isFirstRun: true),
                    ).whenComplete(() {
                      _modalShown = false;
                    });
                  }
                  _modalShown = true;
                }
              },
              builder: (context, state) {
                if (state is ScheduleLoading) {
                  if (_modalShown) {
                    _modalShown = false;
                    context.router.root.pop();
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: DarkThemeColors.primary,
                      strokeWidth: 5,
                    ),
                  );
                } else if (state is ScheduleLoaded) {
                  return SchedulePageView(schedule: state.schedule);
                } else if (state is ScheduleLoadError) {
                  return Column(
                    children: [
                      Text(
                        'Упс!',
                        style: DarkTextTheme.h3,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.errorMessage,
                        style: DarkTextTheme.bodyBold,
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
