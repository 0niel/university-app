import 'package:activity_calendar/activity_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:shimmer/shimmer.dart';

class ActivityCalendarGraph extends StatefulWidget {
  const ActivityCalendarGraph({super.key});

  @override
  State<ActivityCalendarGraph> createState() => _ActivityCalendarGraphState();
}

class _ActivityCalendarGraphState extends State<ActivityCalendarGraph> {
  List<int> _activities([int length = 365]) => List.generate(length, (index) => 0);

  List<int> _getActivitiesByDate(List<Attendance> attendance) {
    final List<int> activities = _activities();

    for (final element in attendance) {
      final DateTime date = DateFormat('dd.MM.yyyy').parse(element.date);
      final int index = DateTime.now().difference(date).inDays;

      activities[index] = 1;
    }

    return activities;
  }

  final List<String> _weekdays = List.generate(7, (i) => DateFormat.E().format(DateTime(2000, 0, 6 + i)));

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserBloc>().state;

    if (user.user == null || user.status != UserStatus.authorized) {
      return const SizedBox.shrink();
    }

    final bloc = context.read<AttendanceBloc>();

    return BlocBuilder<AttendanceBloc, AttendanceState>(builder: (context, state) {
      if (state is AttendanceLoaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Посещаемость за год",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 124,
                child: Row(
                  children: [
                    Column(
                      children: [
                        for (final weekday in _weekdays)
                          Expanded(
                            child: Center(
                              child: Text(
                                weekday,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Card(
                        child: ActivityCalendar(
                          weekday: 6,
                          fromColor: Theme.of(context).extension<AppColors>()!.background01,
                          toColor: Theme.of(context).extension<AppColors>()!.primary,
                          steps: 2,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          activities: _getActivitiesByDate(state.attendance),
                          tooltipBuilder: TooltipBuilder.rich(
                            builder: (i) => TextSpan(children: [
                              TextSpan(
                                text: DateFormat('dd.MM.yyyy').format(DateTime.now().subtract(Duration(days: i))),
                                style: AppTextStyle.body,
                              ),
                              const TextSpan(text: '\n'),
                              TextSpan(
                                text: _getActivitiesByDate(state.attendance)[i] == 1 ? 'Посещение' : 'Пропуск',
                                style: AppTextStyle.body,
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        bloc.add(
          LoadAttendance(
            startDate: DateFormat('dd.MM.yyyy').format(DateTime.now().subtract(const Duration(days: 365))),
            endDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppColors>()!.background01,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).extension<AppColors>()!.background03,
          highlightColor: Theme.of(context).extension<AppColors>()!.background02,
          child: const SizedBox(height: 124),
        ),
      );
    });
  }
}
