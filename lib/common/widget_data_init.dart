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

class WidgetDataProvider {
  static void initData() {
    HomeWidget.setAppGroupId('group.com.MireaNinja.rtuMireaApp');

    _checkWeeks();
    _checkSchedule();
  }

  static _checkWeeks() async {
    final need = await getIt<WidgetData>().needWeeksReload();
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
    }
  }

  static _checkSchedule() async {
    if (!(await getIt<WidgetData>().isScheduleLoaded())) {
      try {
        var a = await getIt<ScheduleLocalData>().getScheduleFromCache();
        var a2 = await getIt<ScheduleLocalData>().getActiveGroupFromCache();

        for (ScheduleModel schedule in a) {
          if (schedule.group == a2) {
            getIt<WidgetData>().setSchedule(schedule.toRawJson());
          }
        }
      } on CacheException {
        debugPrint("Tried to set schedule for widgets, but no cache saved");
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  static setSchedule(Schedule schedule) {
    final model = ScheduleModel(
        group: schedule.group, isRemote: false, schedule: schedule.schedule);
    getIt<WidgetData>().setSchedule(model.toRawJson());
  }

  /// Update timetable for IOS
  // void setDataForIOSHomeWidget() async {
  //   // HomeWidget.setAppGroupId('group.com.MireaNinja.rtuMireaApp');
  //   // HomeWidget.saveWidgetData(
  //   //   'testString',
  //   //   'Updated from Background',
  //   // );

  //   // var b2 = getIt<SharedPreferences>();
  //   // b2.setString('test122', json.encode('lol'));
  //   // HomeWidget.saveWidgetData(
  //   //   'daysStuff',
  //   //   json.encode(days),
  //   // );
  //   HomeWidget.updateWidget(
  //     name: 'HomeWidgetExampleProvider',
  //     androidName: 'HomeWidgetProvider',
  //     iOSName: 'HomeWidget',
  //   );
  //   final b = 1 + 1;
  //   // if (Platform.isIOS) {
  //   //   print('save some data');
  //   //   WidgetKit.setItem(
  //   //       'testString', 'Hello World', 'group.com.MireaNinja.rtuMireaApp');
  //   //   WidgetKit.reloadAllTimelines();
  //   // }
  // }
}
