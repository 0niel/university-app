import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friend_card.dart';

void main() {
  testWidgets('card stays readable at 320 width and 200 percent text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(320, 568),
            textScaler: TextScaler.linear(2),
            disableAnimations: true,
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              child: NinjaFindFriendCard(
                name: 'Александра Константинопольская',
                subtitle: '@alexandra · ИКБО-01-24',
                trailing: SizedBox(width: 44, height: 44),
                selected: true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final semantics = tester.getSemantics(find.byType(NinjaFindFriendCard));
    expect(semantics.flagsCollection.isSelected, Tristate.isTrue);
  });
}
