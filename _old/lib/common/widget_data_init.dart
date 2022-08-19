import 'dart:developer';

import 'package:home_widget/home_widget.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/service_locator.dart';

/// Sets data for home widgets
class WidgetDataProvider {
  static void initData() {
    HomeWidget.setAppGroupId('group.mirea.ninja.mireaapp');
    _init();
  }

  /// initial settings
  static _init() async {
    await _checkWeeks();
    await _checkSchedule();
    _update();
  }

  /// Set weeks info. Has to be set on first start
  static _checkWeeks() async {
    final need = await getIt<WidgetData>().needWeeksReload();
    // print('isNeedWeek $need');
    // if (true) {
    if (need) {
      // Map for day_of_year : schedule_week_number
      Map<String, int> days = {};

      final DateTime now = DateTime.now();
      final DateTime firstDayOfYear =
          DateTime(now.year, DateTime.january, 1, 0, 0);
      final lastDay = CalendarUtils.getSemesterLastDay();

      for (DateTime indexDay = DateTime(now.year, now.month, now.day);
          indexDay.year == now.year;
          indexDay = indexDay.add(const Duration(days: 1))) {
        //  print(indexDay.toString());
        final dayOfYear = indexDay.difference(firstDayOfYear).inDays.toString();
        if (indexDay.isBefore(lastDay)) {
          days[dayOfYear] =
              CalendarUtils.getCurrentWeek(mCurrentDate: indexDay);
        } else {
          days[dayOfYear] = -228;
        }
      }
      // set stuff for last calendar day
      days['365'] = -228;
      days['366'] = -228; // for leap year case

      getIt<WidgetData>().setWeeksData(days);
    }
  }

  /// Set schedule info on first start
  static _checkSchedule() async {
    final scheduleIsLoaded = await getIt<WidgetData>().isScheduleLoaded();
    // print('isScheduleLoaded ${scheduleIsLoaded}');
    if (!scheduleIsLoaded) {
      try {
        var a = await getIt<ScheduleLocalData>().getScheduleFromCache();
        var a2 = await getIt<ScheduleLocalData>().getActiveGroupFromCache();
        // log('Going to set schedule from group: $a');

        for (ScheduleModel schedule in a) {
          if (schedule.group == a2) {
            getIt<WidgetData>().setSchedule(schedule.toRawJson());
            // log('done schedule');
          }
        }
      } on CacheException {
        log("Tried to set schedule for widgets, but no cache saved");
      } catch (e) {
        log(e.toString());
      }
    }
  }

  /// Update schedule when active group is changed
  static void setSchedule(Schedule schedule) {
    final model = ScheduleModel(
      group: schedule.group,
      isRemote: false,
      schedule: schedule.schedule,
    );
    getIt<WidgetData>().setSchedule(model.toRawJson());
    _update();
  }

  /// Refresh widgets
  static _update() {
    log('widget update');
    HomeWidget.updateWidget(
      name: 'HomeWidgetExampleProvider',
      androidName: 'HomeWidgetProvider',
      iOSName: 'HomeWidget',
    );
  }
}
