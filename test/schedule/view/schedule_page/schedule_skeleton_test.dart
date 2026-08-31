import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_header_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_lesson_card_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_skeleton.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_week_strip_skeleton.dart';

import '../../../helpers/pump_app.dart';

BorderRadius? _radiusOf(Widget widget) {
  final decoration = switch (widget) {
    Container(:final decoration) => decoration,
    DecoratedBox(:final decoration) => decoration,
    _ => null,
  };
  if (decoration is! BoxDecoration) return null;
  return decoration.borderRadius as BorderRadius?;
}

void main() {
  testWidgets('loading shell keeps real navigation chrome at 200 percent', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: SafeArea(bottom: false, child: ScheduleSkeleton()),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(find.text('День'), findsOneWidget);
    expect(find.text('Неделя'), findsOneWidget);
    expect(find.text('Месяц'), findsOneWidget);
  });

  testWidgets('loading shell mirrors the day-page geometry', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: SafeArea(bottom: false, child: ScheduleSkeleton()),
      ),
      size: const Size(390, 844),
    );
    await tester.pump();

    expect(find.byType(SliverAppBar), findsNothing);
    expect(find.byType(ScheduleWeekStripSkeleton), findsOneWidget);
    expect(find.byType(ScheduleHeaderSkeleton), findsOneWidget);
    expect(find.byType(ScheduleLessonCardSkeleton), findsWidgets);

    final cardRadii = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(ScheduleLessonCardSkeleton).first,
            matching: find.byType(Container),
          ),
        )
        .map(_radiusOf)
        .whereType<BorderRadius>();
    expect(
      cardRadii,
      contains(BorderRadius.circular(NinjaRadius.card)),
    );

    final circleButtons = tester.widgetList<NinjaSkeleton>(
      find.byType(NinjaSkeleton),
    );
    expect(
      circleButtons.any(
        (skeleton) =>
            skeleton.width == NinjaMetrics.minTouchTarget &&
            skeleton.height == NinjaMetrics.minTouchTarget,
      ),
      isTrue,
    );
  });
}
