import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const AppColors kitColors = AppColors.light;

Widget wrapKit(
  Widget child, {
  bool dark = false,
  bool accessibleNavigation = false,
  double textScale = 1,
}) {
  return MaterialApp(
    theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
    locale: const Locale('en'),
    localizationsDelegates: const [
      DefaultMaterialLocalizations.delegate,
      DefaultWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    builder: (context, page) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        accessibleNavigation: accessibleNavigation,
        textScaler: TextScaler.linear(textScale),
      ),
      child: page!,
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

BoxDecoration kitDecoration(WidgetTester tester, Finder finder) {
  final widget = tester.widget(finder);
  if (widget is Container) return widget.decoration! as BoxDecoration;
  if (widget is DecoratedBox) return widget.decoration as BoxDecoration;
  throw StateError('No decoration on ${widget.runtimeType}');
}

BoxDecoration kitDecorationOf(WidgetTester tester, Type type) {
  final finder = find
      .descendant(of: find.byType(type), matching: find.byType(Container))
      .first;
  return kitDecoration(tester, finder);
}

TextStyle? kitStyleOf(WidgetTester tester, String text) {
  final finder = find.text(text).first;
  return tester.widget<Text>(finder).style ??
      DefaultTextStyle.of(tester.element(finder)).style;
}
