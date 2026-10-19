import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../gallery/gallery_fonts.dart';
import '../../../helpers/pump_app.dart';

void main() {
  setUpAll(loadGalleryFonts);

  testWidgets(
    'long regular lesson limits visual lines without losing accessible text',
    (tester) async {
      const title = 'Государственная система обеспечения единства измерений';
      const teacher = 'Фазылова Ксения Наильевна';
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: AppLessonCard(
              title: title,
              time: '14:20',
              endTime: '15:50',
              typeLabel: 'ЛЕК',
              location: 'В-421-4',
              meta: teacher,
              color: AppColors.light.lecture,
              onTap: () {},
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.text(title)).maxLines, 2);
      expect(tester.widget<Text>(find.text(teacher)).maxLines, 1);
      expect(
        find.bySemanticsLabel(RegExp(RegExp.escape(title))),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(RegExp.escape(teacher))),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byType(AppLessonCard)).height,
        lessThanOrEqualTo(132),
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  for (final width in [320.0, 390.0]) {
    for (final current in [false, true]) {
      testWidgets('regular lesson remains compact at $width, live=$current', (
        tester,
      ) async {
        var opens = 0;
        var actions = 0;
        await tester.pumpApp(
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: AppLessonCard(
                title: 'Математический анализ',
                time: '09:00',
                endTime: '10:30',
                location: 'А-204',
                meta: 'Матвеев М. М.',
                typeLabel: 'ЛЕК',
                chipLabel: current ? 'Сейчас · 45 мин' : null,
                progress: current ? .5 : null,
                state: current ? LessonRowState.current : LessonRowState.plain,
                color: AppColors.light.lecture,
                onTap: () => opens++,
                onLongPress: () => actions++,
              ),
            ),
          ),
          size: Size(width, 844),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(AppLessonCard)).height,
          lessThanOrEqualTo(current ? 154 : 126),
        );
        for (final text in [
          'Математический анализ',
          'А-204',
          'Матвеев М. М.',
          '09:00',
          '10:30',
        ]) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.text(text),
          );
          expect(paragraph.didExceedMaxLines, isFalse);
        }
        await tester.tap(find.text('Математический анализ'));
        await tester.longPress(find.text('Математический анализ'));
        expect(opens, 1);
        expect(actions, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final scale in [1.0, 1.2, 1.4]) {
    testWidgets('time column stays on one line without clipping at $scale', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: AppLessonCard(
              title: 'Математика',
              time: '09:00',
              endTime: '10:30',
              color: AppColors.light.lecture,
            ),
          ),
        ),
        size: const Size(390, 844),
        textScaler: TextScaler.linear(scale),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.text('09:00')).dy,
        tester.getTopLeft(find.text('Математика')).dy,
      );
      for (final value in ['09:00', '10:30']) {
        final finder = find.text(value);
        final paragraph = tester.renderObject<RenderParagraph>(finder);
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(baseOffset: 0, extentOffset: value.length),
        );
        expect(paragraph.didExceedMaxLines, isFalse);
        final painter = TextPainter(
          text: paragraph.text,
          textDirection: Directionality.of(tester.element(finder)),
          textScaler: TextScaler.linear(scale),
        )..layout();
        expect(boxes.map((box) => box.top).toSet(), hasLength(1));
        expect(paragraph.size.width, greaterThanOrEqualTo(painter.width - .1));
        expect(
          boxes.every(
            (box) => box.left >= -.1 && box.right <= paragraph.size.width + .1,
          ),
          isTrue,
        );
        painter.dispose();
      }
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('lesson hierarchy fits $size at $scale text', (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: AppLessonCard(
                title: 'Проектирование и архитектура программных систем',
                time: '09:00',
                endTime: '10:30',
                location: 'А-415-6 · В-78',
                meta: 'Преподаватель с длинным именем и фамилией',
                typeLabel: 'Лекция',
                chipLabel: 'Сейчас · 45 мин',
                state: LessonRowState.current,
                progress: .5,
                color: AppColors.light.lecture,
                onTap: () {},
              ),
            ),
          ),
          size: size,
          textScaler: TextScaler.linear(scale),
        );
        await tester.pumpAndSettle();
        expect(find.text('09:00'), findsOneWidget);
        expect(find.text('10:30'), findsOneWidget);
        await tester.ensureVisible(find.text('А-415-6 · В-78'));
        expect(find.text('А-415-6 · В-78'), findsOneWidget);
        expect(find.byType(AppProgressBar), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('lesson annotations retain their own action', (tester) async {
    var opened = 0;
    var notes = 0;
    await tester.pumpApp(
      Scaffold(
        body: AppLessonCard(
          title: 'Математика',
          time: '09:00',
          color: AppColors.light.lecture,
          onTap: () => opened++,
          annotations: [
            AppPressable(
              onTap: () => notes++,
              child: const SizedBox(
                width: 60,
                height: 44,
                child: Center(child: Text('Заметка')),
              ),
            ),
          ],
        ),
      ),
      size: const Size(390, 844),
    );
    await tester.tap(find.text('Заметка'));
    await tester.pumpAndSettle();
    expect(notes, 1);
    expect(opened, 0);
    await tester.tap(find.text('Математика'));
    await tester.pumpAndSettle();
    expect(opened, 1);
    expect(tester.takeException(), isNull);
  });
}
