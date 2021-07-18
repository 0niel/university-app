import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/data/repositories/onboarding_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/onboarding/get_page.dart';
import 'package:rtu_mirea_app/main.dart';

class OnBoardingTest {
  static testEverythg() {
    testFirstPage();
  }

  static testFirstPage() {
    testWidgets('OnBoarding | Test first page content',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.
      await tester.pumpWidget(App(true));

      // Create the Finders.
      final mainText =
          find.text(GetOnBoardingPages.firstPage.textWidget.data!);
      final contentText =
          find.text(GetOnBoardingPages.firstPage.contentText);

      // Use the `findsOneWidget` matcher provided by flutter_test to
      // verify that the Text widgets appear exactly once in the widget tree.
      expect(mainText, findsOneWidget);
      expect(contentText, findsOneWidget);
    });

    OnBoardingRepositoryImpl repo = OnBoardingRepositoryImpl();


    testWidgets('OnBoarding | Test swipe',
        (WidgetTester tester) async {
      await tester.pumpWidget(App(true));

      await tester.drag(find.byType(PageView), const Offset(-401.0, 0.0));

      await tester.pumpAndSettle(Duration(milliseconds: 500));

      final contentText = find.text(repo.getPage(1).contentText);

      expect(contentText, findsOneWidget);
    });
    
  }
}
