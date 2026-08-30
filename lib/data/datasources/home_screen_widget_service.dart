import 'dart:convert';
import 'dart:developer';

import 'package:home_widget/home_widget.dart';

class HomeScreenWidgetService {
  const HomeScreenWidgetService();

  static const _scheduleKey = 'schedule';
  static const _widgetName = 'ScheduleWidgetReceiver';
  static const _widgetAndroidPackage = 'ninja.mirea.mireaapp.glance';

  Future<void> setSchedule(String scheduleJson) async {
    try {
      if (jsonDecode(scheduleJson) is! Map) {
        log('Invalid schedule JSON root', name: 'HomeScreenWidgetService');
        return;
      }

      log(
        'Saving ${scheduleJson.length} bytes of schedule data',
        name: 'HomeScreenWidgetService',
      );
      final saved = await HomeWidget.saveWidgetData(_scheduleKey, scheduleJson);
      log(
        'Widget data saved: ${saved == true}',
        name: 'HomeScreenWidgetService',
      );
      await updateWidget();
    } on Exception catch (error, stackTrace) {
      log(
        'Could not save schedule widget data',
        error: error,
        stackTrace: stackTrace,
        name: 'HomeScreenWidgetService',
      );
    }
  }

  Future<void> updateWidget() async {
    try {
      final updated = await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: '$_widgetAndroidPackage.$_widgetName',
        qualifiedAndroidName: '$_widgetAndroidPackage.$_widgetName',
      );
      log(
        'Widget updated: ${updated == true}',
        name: 'HomeScreenWidgetService',
      );

      final savedData = await HomeWidget.getWidgetData<String>(_scheduleKey);
      if (savedData case final String data) {
        log(
          'Verified ${data.length} bytes of widget data',
          name: 'HomeScreenWidgetService',
        );
      } else {
        log('Widget data is unavailable', name: 'HomeScreenWidgetService');
      }
    } on Exception catch (error, stackTrace) {
      log(
        'Could not update schedule widget',
        error: error,
        stackTrace: stackTrace,
        name: 'HomeScreenWidgetService',
      );
    }
  }
}
