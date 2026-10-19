import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_submit_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_submit_page.dart';

import '../../helpers/pump_app.dart';

class _Submit extends MockCubit<MiniAppSubmitState>
    implements MiniAppSubmitCubit {}

void main() {
  testWidgets('submission categories and templates receive both edge swipes', (
    tester,
  ) async {
    final cubit = _Submit();
    when(() => cubit.state).thenReturn(const MiniAppSubmitState());
    await tester.pumpApp(
      BlocProvider<MiniAppSubmitCubit>.value(
        value: cubit,
        child: const MiniAppSubmitView(),
      ),
      size: const Size(320, 900),
      textScaler: const TextScaler.linear(2),
    );
    for (final key in [
      'mini-app-submit-categories',
      'mini-app-submit-templates',
    ]) {
      final rail = find.byKey(ValueKey(key));
      await tester.scrollUntilVisible(
        rail,
        240,
        scrollable: find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.pumpAndSettle();
      final viewport = tester.getRect(rail);
      expect(viewport.left, 0);
      expect(viewport.right, 320);
      final firstChip = find
          .descendant(of: rail, matching: find.byType(NinjaChip))
          .first;
      expect(tester.getRect(firstChip).left, AppSpacing.screen);
      final scroll = tester.state<ScrollableState>(
        find.descendant(of: rail, matching: find.byType(Scrollable)),
      );
      await tester.dragFrom(
        Offset(318, viewport.center.dy),
        const Offset(-220, 0),
      );
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, greaterThan(0));
      final previous = scroll.position.pixels;
      await tester.dragFrom(
        Offset(2, viewport.center.dy),
        const Offset(220, 0),
      );
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, lessThan(previous));
      if (key == 'mini-app-submit-categories') {
        await tester.ensureVisible(firstChip);
        await tester.tap(firstChip);
        await tester.pumpAndSettle();
        expect(tester.widget<NinjaChip>(firstChip).selected, isTrue);
      }
    }
    expect(tester.takeException(), isNull);
  });
}
