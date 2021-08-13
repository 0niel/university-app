import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/pages/schedule/widgets/schedule_settings_modal.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'widgets/schedule_page_view.dart';

class ScheduleScreen extends StatelessWidget {
  static const String routeName = '/schedule';

  bool modalShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Расписание',
          style: DarkTextTheme.title,
        ),
      ),
      body: SafeArea(
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
                      builder: (context) =>
                          ScheduleSettingsModal(groups: state.groups),
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
              return SchedulePageView();
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
    );
  }
}
