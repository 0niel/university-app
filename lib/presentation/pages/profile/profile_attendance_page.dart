import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/profile/widgets/attendance_card.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/select_range_date_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class ProfileAttendancePage extends StatefulWidget {
  const ProfileAttendancePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileAttendancePageState();
}

class _ProfileAttendancePageState extends State<ProfileAttendancePage> {
  List<DateTime> _getFirstAndLastWeekDaysText() {
    final DateTime now = DateTime.now();
    final int currentDay = now.weekday;
    final DateTime firstDayOfWeek =
        now.subtract(Duration(days: currentDay)).add(const Duration(days: 1));
    final DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));
    return [firstDayOfWeek, lastDayOfWeek];
  }

  List<String> _getTextDates(List<DateTime> dates) {
    final List<String> res = [];
    for (var element in dates) {
      res.add(DateFormat('dd.MM.yyyy').format(element).toString());
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Посещаемость"),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            return userState.maybeMap(
              logInSuccess: (value) =>
                  BlocBuilder<AttendanceBloc, AttendanceState>(
                builder: (context, state) {
                  if (state is AttendanceInitial) {
                    context.read<AttendanceBloc>().add(LoadAttendance(
                        startDate:
                            _getTextDates(_getFirstAndLastWeekDaysText())[0],
                        endDate:
                            _getTextDates(_getFirstAndLastWeekDaysText())[1]));
                  } else if (state is AttendanceLoadError) {
                    return Center(
                      child: Text(
                          "Произошла ошибка при попытке загрузить посещаемость. Повторите попытку позже",
                          style: AppTextStyle.body),
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Промежуток: ',
                              style: AppTextStyle.body
                                  .copyWith(color: AppTheme.colors.active)),
                          const SizedBox(width: 16),
                          SelectRangeDateButton(
                            initialRange: PickerDateRange(
                                _getFirstAndLastWeekDaysText()[0],
                                _getFirstAndLastWeekDaysText()[1]),
                            text:
                                "с ${_getTextDates(_getFirstAndLastWeekDaysText())[0]} по ${_getTextDates(_getFirstAndLastWeekDaysText())[1]}",
                            onDateSelected: (date) {
                              context.read<AttendanceBloc>().add(
                                    LoadAttendance(
                                        startDate: _getTextDates(date)[0],
                                        endDate: _getTextDates(date)[1]),
                                  );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (state is AttendanceLoading)
                        const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                      else if (state is AttendanceLoaded &&
                          state.attendance.isNotEmpty)
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text('Дней посещено: ${state.visitsCount}',
                                  style: AppTextStyle.body),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.attendance.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 24),
                                      child: AttendanceCard(
                                        type: state.attendance[index].eventType,
                                        date: state.attendance[index].date,
                                        time: state.attendance[index].time,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (state is AttendanceLoaded && state.attendance.isEmpty)
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                "Ничего не найдено. Выберите другой промежуток времени",
                                style: AppTextStyle.body,
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              ),
              orElse: () => const Center(child: Text("Ошибка")),
            );
          },
        ),
      ),
    );
  }
}
