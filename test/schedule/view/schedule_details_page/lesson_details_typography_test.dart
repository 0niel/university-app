import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_details_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';
import 'mock_schedule_repository.dart';

void main() {
  setUpAll(loadGalleryFonts);

  const subject =
      'Коммуникативные технологии в профессиональной сфере '
      'на иностранном языке';

  for (final width in [320.0, 390.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'long lesson title stays complete in sans at $width/$scale',
        (tester) async {
          final schedule = MockScheduleRepository();
          final friends = MockFriendsRepository();
          when(
            () => schedule.getLessonDetails(
              subjectName: any(named: 'subjectName'),
              lessonDate: any(named: 'lessonDate'),
              lessonBellsNumber: any(named: 'lessonBellsNumber'),
            ),
          ).thenAnswer(
            (_) async => const LessonDetailsResponse(
              reactions: LessonReactionResponse(counts: {}),
              materials: [],
              reviews: [],
            ),
          );
          when(
            friends.getGroupMembers,
          ).thenAnswer((_) async => GroupRoster.empty);
          final day = DateTime.now().add(const Duration(days: 1));
          final lesson = LessonSchedulePart(
            subject: subject,
            lessonType: .practice,
            teachers: const [],
            classrooms: const [Classroom(name: 'А-203')],
            lessonBells: LessonBells(
              number: 1,
              startTime: const TimeOfDay(hour: 9, minute: 0),
              endTime: const TimeOfDay(hour: 10, minute: 30),
            ),
            dates: [day],
          );

          await tester.pumpApp(
            MultiRepositoryProvider(
              providers: [
                RepositoryProvider<ScheduleRepository>.value(value: schedule),
                RepositoryProvider<FriendsRepository>.value(value: friends),
              ],
              child: ScheduleDetailsPage(lesson: lesson, selectedDate: day),
            ),
            size: Size(width, 844),
            textScaler: TextScaler.linear(scale),
          );
          await tester.pumpAndSettle();

          final heading = find.byWidgetPredicate(
            (widget) => widget is AppBalancedText && widget.data == subject,
          );
          expect(heading, findsOneWidget);
          final style = tester.widget<AppBalancedText>(heading).style!;
          expect(style.fontFamily, AppText.sansFamily);
          expect(style.fontStyle ?? FontStyle.normal, FontStyle.normal);
          expect(style.fontSize, lessThanOrEqualTo(28));
          final paragraph = tester.renderObject<RenderParagraph>(
            find.descendant(of: heading, matching: find.byType(RichText)),
          );
          expect(paragraph.text.toPlainText(), subject);
          expect(paragraph.maxLines, isNull);
          expect(paragraph.didExceedMaxLines, isFalse);
          for (var index = 0; index < subject.length; index++) {
            if (subject[index].trim().isEmpty) continue;
            final boxes = paragraph.getBoxesForSelection(
              TextSelection(baseOffset: index, extentOffset: index + 1),
            );
            expect(boxes, isNotEmpty);
            for (final box in boxes) {
              expect(box.left, greaterThanOrEqualTo(-1));
              expect(box.right, lessThanOrEqualTo(paragraph.size.width + 1));
            }
          }
          final painter = TextPainter(
            text: paragraph.text,
            textDirection: TextDirection.ltr,
            textScaler: TextScaler.linear(scale),
          )..layout(maxWidth: paragraph.size.width);
          expect(paragraph.size.height, closeTo(painter.height, .1));
          painter.dispose();
          await tester.scrollUntilVisible(
            find.text('Напомнить'),
            200,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
          expect(find.text('Напомнить').hitTestable(), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
