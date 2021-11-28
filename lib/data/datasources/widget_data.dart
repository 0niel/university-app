import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:home_widget/home_widget.dart';

abstract class WidgetData {
  Future<bool> needWeeksReload();
  Future<bool> isScheduleLoaded();
  setWeeksData(Map<String, int> jsonToPut);
  setSchedule(String jsonToPut);
}

class WidgetDataImpl implements WidgetData {
  @override
  Future<bool> needWeeksReload() async {
    String? weeks = await HomeWidget.getWidgetData('daysStuff');
    int? year = await HomeWidget.getWidgetData('daysYear');
    return weeks == null || year == null || const Clock().now().year != year;
  }

  @override
  Future<bool> isScheduleLoaded() async {
    String? data = await HomeWidget.getWidgetData('schedule');
    return data != null;
  }

  @override
  setSchedule(String jsonToPut) {
    HomeWidget.saveWidgetData(
      'schedule',
      jsonToPut,
    );
  }

  @override
  setWeeksData(Map<String, int> days) {
    HomeWidget.saveWidgetData(
      'daysStuff',
      json.encode(days),
    );
    HomeWidget.saveWidgetData(
      'daysYear',
      const Clock().now().year,
    );
  }
}
