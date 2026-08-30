import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension AppContentThemedTester on WidgetTester {
  Future<void> pumpContentThemedApp(Widget widgetUnderTest) async {
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: Center(child: widgetUnderTest)),
      ),
    );
    await pump();
  }
}
