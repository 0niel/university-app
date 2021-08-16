import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/schedule_settings_modal.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/schedule_page_view.dart';

class ScheduleScreen extends StatefulWidget {
  static const String routeName = '/schedule';
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _modalShown = false;

  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  void initState() {
    super.initState();
  }

  ValueNotifier<bool> _switchValueNotifier = ValueNotifier(false);

  Widget _buildGroupButton(String group, String activeGroup, bool isActive,
      [Schedule? schedule]) {
    if (isActive) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 8),
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
                  IconButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DarkThemeColors.colorful05,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 10, right: 8),
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 8),
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
                  IconButton(
                    onPressed: () {
                      context
                          .read<ScheduleBloc>()
                          .add(ScheduleSetActiveGroupEvent(group));
                    },
                    icon: const Icon(Icons.check_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleUpdateEvent(
                          group: group, activeGroup: activeGroup));
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ScheduleBloc>().add(ScheduleDeleteEvent(
                          group: group, schedule: schedule!));
                    },
                    icon: const Icon(Icons.delete_rounded),
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
    return SafeArea(
      child: SliderMenuContainer(
        key: _key,
        appBarColor: DarkThemeColors.background01,
        isDraggable: false,
        drawerIconColor: DarkThemeColors.white,
        appBarHeight: 60,
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
        appBarPadding: const EdgeInsets.all(0),
        isTitleCenter: false,
        sliderMenuOpenSize: MediaQuery.of(context).size.width * 0.80,
        title: Text(
          'Расписание',
          style: DarkTextTheme.title,
        ),
        sliderMenu: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: Text(
                'Управление расписанием и группами',
                style: DarkTextTheme.h6,
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/lessons.svg',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 20),
                        Text("Пустые пары", style: DarkTextTheme.buttonL),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ValueListenableBuilder(
                        valueListenable: _switchValueNotifier,
                        builder: (context, hasError, child) => CupertinoSwitch(
                          activeColor: DarkThemeColors.primary,
                          value: _switchValueNotifier.value,
                          onChanged: (value) {
                            _switchValueNotifier.value = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
            BlocBuilder<ScheduleBloc, ScheduleState>(
                buildWhen: (prevState, currentState) {
              if (currentState is ScheduleLoaded &&
                  prevState.runtimeType != ScheduleLoaded)
                return true;
              else if (currentState is ScheduleLoaded &&
                  prevState is ScheduleLoaded) {
                if (prevState.activeGroup != currentState.activeGroup ||
                    prevState.downloadedScheduleGroups !=
                        currentState.downloadedScheduleGroups) return true;
              }
              return false;
            }, builder: (context, state) {
              if (state is ScheduleLoaded) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/add_group.svg',
                                    height: 16,
                                    width: 16,
                                  ),
                                  SizedBox(width: 20),
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
                          if (!_modalShown)
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ScheduleSettingsModal(
                                  groups: state.groups, isFirstRun: false),
                            ).whenComplete(() {
                              this._modalShown = false;
                            });
                          this._modalShown = true;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Группы".toUpperCase(),
                        style: DarkTextTheme.chip
                            .copyWith(color: DarkThemeColors.deactiveDarker),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      _buildGroupButton(
                          state.activeGroup, state.activeGroup, true),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.downloadedScheduleGroups.length - 1,
                          itemBuilder: (context, index) {
                            if (state.downloadedScheduleGroups[index] !=
                                state.activeGroup)
                              return _buildGroupButton(
                                  state.downloadedScheduleGroups[index],
                                  state.activeGroup,
                                  false,
                                  state.schedule);
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            }),
          ],
        ),
        sliderMain: SafeArea(
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            buildWhen: (prevState, currentState) {
              if (prevState is ScheduleLoaded && currentState is ScheduleLoaded)
                return prevState.schedule != currentState.schedule
                    ? true
                    : false;
              else
                return prevState != currentState ? true : false;
            },
            builder: (context, state) {
              if (state is ScheduleInitial) {
                context.read<ScheduleBloc>().add(ScheduleOpenEvent());
                return Container();
              } else if (state is ScheduleActiveGroupEmpty) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) {
                    if (!_modalShown)
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ScheduleSettingsModal(
                            groups: state.groups, isFirstRun: true),
                      ).whenComplete(() {
                        this._modalShown = false;
                      });
                    this._modalShown = true;
                  },
                );

                return Container();
              } else if (state is ScheduleLoading) {
                if (_modalShown) {
                  _modalShown = false;
                  Navigator.pop(context);
                }
                return Center(
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
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      state.errorMessage,
                      style: DarkTextTheme.bodyBold,
                    )
                  ],
                );
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }
}

// class ScheduleScreen extends StatelessWidget {
//   static const String routeName = '/schedule';

//   bool modalShown = false;

//   GlobalKey<SliderMenuContainerState> _key =
//       new GlobalKey<SliderMenuContainerState>();

//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     automaticallyImplyLeading: false,
//     //     title: Text(
//     //       'Расписание',
//     //       style: DarkTextTheme.title,
//     //     ),
//     //   ),
//     //   body: SafeArea(
//     //     child: BlocBuilder<ScheduleBloc, ScheduleState>(
//     //       builder: (context, state) {
//     //         if (state is ScheduleInitial) {
//     //           context.read<ScheduleBloc>().add(ScheduleOpenEvent());
//     //           return Container();
//     //         } else if (state is ScheduleActiveGroupEmpty) {
//     //           WidgetsBinding.instance!.addPostFrameCallback(
//     //             (_) {
//     //               if (!modalShown)
//     //                 showModalBottomSheet(
//     //                   context: context,
//     //                   isScrollControlled: true,
//     //                   backgroundColor: Colors.transparent,
//     //                   builder: (context) =>
//     //                       ScheduleSettingsModal(groups: state.groups),
//     //                 );
//     //               this.modalShown = true;
//     //             },
//     //           );

//     //           return Container();
//     //         } else if (state is ScheduleLoading) {
//     //           if (modalShown) {
//     //             modalShown = false;
//     //             Navigator.pop(context);
//     //           }
//     //           return Center(
//     //             child: CircularProgressIndicator(
//     //               backgroundColor: DarkThemeColors.primary,
//     //               strokeWidth: 5,
//     //             ),
//     //           );
//     //         } else if (state is ScheduleLoaded) {
//     //           return SchedulePageView();
//     //         } else if (state is ScheduleLoadError) {
//     //           return Column(
//     //             children: [
//     //               Text(
//     //                 'Упс!',
//     //                 style: DarkTextTheme.h3,
//     //               ),
//     //               SizedBox(
//     //                 height: 24,
//     //               ),
//     //               Text(
//     //                 state.errorMessage,
//     //                 style: DarkTextTheme.bodyBold,
//     //               )
//     //             ],
//     //           );
//     //         } else
//     //           return Container();
//     //       },
//     //     ),
//     //   ),
//     // );
//   }
// }
