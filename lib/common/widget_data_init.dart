import 'dart:math';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:rtu_mirea_app/common/calendar.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';
import 'package:rtu_mirea_app/service_locator.dart';

/// Sets data for home widgets
class WidgetDataProvider {
  static void initData() {
    HomeWidget.setAppGroupId('group.com.MireaNinja.rtuMireaApp');
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
      Map<String, int> days = {};
      DateTime now = DateTime.now();
      DateTime firstDayOfYear = DateTime(now.year, 1, 1, 0, 0);
      for (DateTime indexDay = DateTime(now.year, now.month, now.day);
          indexDay.year == now.year;
          indexDay = indexDay.add(const Duration(days: 1))) {
        //  print(indexDay.toString());
        days[indexDay.difference(firstDayOfYear).inDays.toString()] = min(
            Calendar.getCurrentWeek(mCurrentDate: indexDay),
            Calendar.kMaxWeekInSemester);
      }
      getIt<WidgetData>().setWeeksData(days);
      // print('done weeks');
    }
  }

  /// Set schedule info on first start
  static _checkSchedule() async {
    // if (true) {
    // print(
    //     'isScheduleLoaded ${!(await getIt<WidgetData>().isScheduleLoaded())}');
    if (!(await getIt<WidgetData>().isScheduleLoaded())) {
      try {
        var a = await getIt<ScheduleLocalData>().getScheduleFromCache();
        var a2 = await getIt<ScheduleLocalData>().getActiveGroupFromCache();

        for (ScheduleModel schedule in a) {
          if (schedule.group == a2) {
            getIt<WidgetData>().setSchedule(schedule.toRawJson());
            // print('done schedule');
          }
        }
      } on CacheException {
        debugPrint("Tried to set schedule for widgets, but no cache saved");
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  /// Update schedule when active group is changed
  static setSchedule(Schedule schedule) {
    final model = ScheduleModel(
        group: schedule.group, isRemote: false, schedule: schedule.schedule);
    getIt<WidgetData>().setSchedule(model.toRawJson());
    _update();
  }

  /// Refresh widgets
  static _update() {
    HomeWidget.updateWidget(
      name: 'HomeWidgetExampleProvider',
      androidName: 'HomeWidgetProvider',
      iOSName: 'HomeWidget',
    );
  }
}
