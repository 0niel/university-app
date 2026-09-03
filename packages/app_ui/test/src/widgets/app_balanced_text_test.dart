import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('balances wrapped text without changing its content',
      (tester) async {
    const text = 'Alpha beta gamma delta';
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 260,
          child: AppBalancedText(text, style: TextStyle(fontSize: 20)),
        ),
      ),
    );
    expect(find.text(text), findsOneWidget);
    expect(tester.getSize(find.text(text)).width, lessThan(260));
    expect(tester.takeException(), isNull);
  });

  testWidgets('single line and rich text stay intact', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 300,
          child: AppBalancedText.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Hello '),
                TextSpan(
                  text: 'world',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Hello world'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('balancing does not introduce an emergency word break',
      (tester) async {
    const text = 'abcdefghij abcd';
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 210,
          child: AppBalancedText(
            text,
            style: TextStyle(fontFamily: 'Ahem', fontSize: 20),
          ),
        ),
      ),
    );
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byType(AppBalancedText),
        matching: find.byType(RichText),
      ),
    );
    final word = paragraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: 10),
    );
    expect(word.map((box) => box.top).toSet(), hasLength(1));
    expect(paragraph.size.width, greaterThanOrEqualTo(200));
    expect(find.text(text), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mixed style words retain their measured width at text scale',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 250,
          child: AppBalancedText.rich(
            TextSpan(
              children: [
                TextSpan(text: 'abcde'),
                TextSpan(text: 'fghij', style: TextStyle(fontSize: 20)),
                TextSpan(text: ' abcd'),
              ],
            ),
            style: TextStyle(fontFamily: 'Ahem', fontSize: 10),
          ),
        ),
        textScale: 1.5,
      ),
    );
    final paragraph = tester.renderObject<RenderParagraph>(
      find.descendant(
        of: find.byType(AppBalancedText),
        matching: find.byType(RichText),
      ),
    );
    final word = paragraph.getBoxesForSelection(
      const TextSelection(baseOffset: 0, extentOffset: 10),
    );
    expect(
      word.every(
        (box) => box.top < word.first.bottom && box.bottom > word.first.top,
      ),
      isTrue,
    );
    expect(paragraph.size.width, greaterThanOrEqualTo(225));
    expect(find.text('abcdefghij abcd'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CJK may balance at its valid character boundaries',
      (tester) async {
    const text = '大学课程安排信息';
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 110,
          child: AppBalancedText(
            text,
            style: TextStyle(fontFamily: 'Ahem', fontSize: 20),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.text(text)).width, lessThan(100));
    expect(find.text(text), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an unavoidable long word keeps the available width',
      (tester) async {
    const text = 'abcdefghijklmnop';
    await tester.pumpWidget(
      wrapKit(
        const SizedBox(
          width: 210,
          child: AppBalancedText(
            text,
            style: TextStyle(fontFamily: 'Ahem', fontSize: 20),
          ),
        ),
      ),
    );
    expect(tester.getSize(find.text(text)).width, 210);
    expect(find.text(text), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('serif optical size follows the requested size', () {
    expect(AppText.serif(32).fontVariations, [const FontVariation('opsz', 32)]);
    expect(
      AppText.serif(120).fontVariations,
      [const FontVariation('opsz', 72)],
    );
  });
}
