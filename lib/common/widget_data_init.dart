import 'dart:developer';
import 'dart:io';

import 'package:home_widget/home_widget.dart';

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
