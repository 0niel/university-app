import 'dart:developer';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:rtu_mirea_app/common/utils/calendar_utils.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
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
    if (!(Platform.isIOS || Platform.isAndroid)) {
      return;
    }

    // TODO: implement
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
