import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

/// Manages data communication with the home screen widget
class HomeScreenWidgetService {
  static const String _scheduleKey = 'schedule';
  static const String _widgetName = 'ScheduleWidgetReceiver';
  static const String _widgetAndroidPackage = 'ninja.mirea.mireaapp.glance';

  /// Sets schedule data for the widget
  Future<void> setSchedule(String scheduleJson) async {
    try {
      // Validate JSON before saving
      final jsonData = json.decode(scheduleJson);
      if (jsonData == null) {
        debugPrint('Error: Invalid schedule JSON data');
        return;
      }

      debugPrint('Setting schedule data: ${scheduleJson.length} bytes');

      // Save widget data
      final result = await HomeWidget.saveWidgetData(_scheduleKey, scheduleJson);
      debugPrint('Widget data save result: $result');

      // Update the widget
      await updateWidget();
    } catch (e) {
      debugPrint('Error setting schedule data: $e');
    }
  }

  /// Updates the home screen widget to reflect new data
  Future<void> updateWidget() async {
    try {
      final result = await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: '$_widgetAndroidPackage.$_widgetName',
        qualifiedAndroidName: '$_widgetAndroidPackage.$_widgetName',
      );

      debugPrint('Widget update result: $result');

      // Verify data was saved correctly
      final savedData = await HomeWidget.getWidgetData<String>(_scheduleKey);
      if (savedData != null) {
        debugPrint('Verified widget data: ${savedData.length} bytes');
      } else {
        debugPrint('Warning: Could not verify widget data, saved data is null');
      }
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }

  /// Clears existing widget data
  Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData(_scheduleKey, null);
      await updateWidget();
    } catch (e) {
      debugPrint('Error clearing widget data: $e');
    }
  }
}
