import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
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
  bool modalShown = false;
  String? _activeGroup;
  List<String>? _downloadedGrouops;

  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();

  double _borderRadius = 12.0;

  void handleSlideIsOpenChanged(bool? isOpen) {
    if (isOpen != null) {
      final newRadius = isOpen ? 0.0 : 12.0;
      if (newRadius != _borderRadius) {
        setState(() {
          _borderRadius = newRadius;
        });
      }
    }
  }

  void initState() {
    super.initState();
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
              padding: EdgeInsets.all(8),
              child: Text(
                'Управление группами',
                style: DarkTextTheme.title,
              ),
            ),
            BlocBuilder<ScheduleBloc, ScheduleState>(builder: (context, state) {
              if (state is ScheduleLoaded) {
                return Column(
                    children: List.generate(
                        state.downloadedScheduleGroups.length,
                        (index) =>
                            Text(state.downloadedScheduleGroups[index])));
              }
              return Container();
            }),
          ],
        ),
        sliderMain: SafeArea(
          child: BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleInitial) {
                context.read<ScheduleBloc>().add(ScheduleOpenEvent());
                return Container();
              } else if (state is ScheduleActiveGroupEmpty) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) {
                    if (!modalShown)
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => ScheduleSettingsModal(
                            groups: state.groups, isFirstRun: true),
                      );
                    this.modalShown = true;
                  },
                );

                return Container();
              } else if (state is ScheduleLoading) {
                if (modalShown) {
                  modalShown = false;
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
