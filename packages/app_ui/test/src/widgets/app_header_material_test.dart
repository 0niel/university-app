import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/glass/app_glass_renderer.dart';
import 'package:app_ui/src/widgets/app_control_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  for (final inner in [false, true]) {
    testWidgets(
      'glass header preserves geometry and keyboard with fallback inner=$inner',
      (tester) async {
        var backs = 0;
        var taps = 0;
        Widget view({required bool glassEnabled}) => wrapKit(
          Theme(
            data: AppTheme.generateTheme(
              AppColors.light,
              Brightness.light,
              glassEnabled: glassEnabled,
            ),
            child: SizedBox(
              width: 320,
              child: inner
                  ? AppInnerHeader(
                      title: 'Сервисы',
                      onBack: () => backs++,
                      backSemanticsLabel: 'Назад',
                      actions: [
                        AppHeaderAction(
                          icon: AppLineIcon.tune,
                          semanticsLabel: 'Настройки',
                          onTap: () => taps++,
                        ),
                      ],
                    )
                  : AppScreenHeader(
                      title: 'Сервисы',
                      actions: [
                        AppHeaderAction(
                          icon: AppLineIcon.tune,
                          semanticsLabel: 'Настройки',
                          onTap: () => taps++,
                        ),
                      ],
                    ),
            ),
          ),
        );

        await tester.pumpWidget(view(glassEnabled: true));
        await tester.pumpAndSettle();
        final count = inner ? 2 : 1;
        expect(find.byType(AppGlassSurface), findsNWidgets(count));
        expect(find.byType(AppGlassRenderer), findsNWidgets(count));
        for (final surface in tester.widgetList<AppGlassSurface>(
          find.byType(AppGlassSurface),
        )) {
          expect(surface.role, AppGlassRole.control);
          expect(surface.borderRadius, AppRadius.full);
          expect(surface.color, kitColors.surface);
        }
        final action = find.byType(AppHeaderCircleButton);
        final bounds = tester.getRect(action);
        expect(bounds.size, const Size.square(AppControlSize.touchTarget));
        final visual = find.descendant(
          of: action,
          matching: find.byType(AppControlSurface),
        );
        expect(
          tester.getSize(visual),
          Size.square(
            inner
                ? AppControlSize.iconButton
                : AppControlSize.iconButtonCompact,
          ),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        if (inner) {
          expect(backs, 1);
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.sendKeyEvent(LogicalKeyboardKey.space);
        }
        expect(taps, 1);

        await tester.pumpWidget(view(glassEnabled: false));
        await tester.pumpAndSettle();
        expect(find.byType(AppGlassRenderer), findsNothing);
        expect(tester.getRect(action), bounds);
        expect(find.bySemanticsLabel('Настройки'), findsOneWidget);
        await tester.tap(action);
        expect(taps, 2);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
