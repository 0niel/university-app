import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('AppAvatarStack', () {
    testWidgets('renders one avatar per name', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppAvatarStack(names: ['Иван', 'Мария', 'Олег'])),
      );

      expect(find.byType(AppAvatar), findsNWidgets(3));
    });

    testWidgets('box is tall enough for the ring (no clipping)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const AppAvatarStack(names: ['Иван', 'Мария'])),
      );

      // size (36) + 2 px ring on each side = 40; the old box was only 36 and
      // clipped the ring top/bottom.
      final box = tester.getSize(find.byType(AppAvatarStack));
      expect(box.height, 40);
    });

    testWidgets('renders nothing for empty names', (tester) async {
      await tester.pumpWidget(_wrap(const AppAvatarStack(names: [])));

      expect(find.byType(AppAvatar), findsNothing);
      expect(tester.getSize(find.byType(AppAvatarStack)), Size.zero);
    });
  });
}
