import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final dark in [false, true]) {
    for (final width in [320.0, 430.0, 1024.0]) {
      testWidgets('entry actions remain reachable at $width, dark=$dark', (
        tester,
      ) async {
        tester.view
          ..physicalSize = Size(width, 568)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        var continued = false;
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                viewInsets: const EdgeInsets.only(bottom: 240),
                disableAnimations: true,
              ),
              child: child!,
            ),
            home: Scaffold(
              body: AppEntryLayout(
                title: 'Everything for your university day',
                subtitle: 'Choose your account and continue at your own pace.',
                header: const AppBackButton(),
                actions: AppButton.primary(
                  key: const Key('continue'),
                  label: 'Continue',
                  expanded: true,
                  onPressed: () => continued = true,
                ),
                child: const Column(
                  children: [
                    AppInputField(
                      label: 'Email',
                      placeholder: 'student@example.com',
                    ),
                    SizedBox(height: 16),
                    AppInputField(label: 'Password', obscureText: true),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.byKey(const Key('continue')),
          150,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('continue')));
        expect(continued, isTrue);
        expect(
          tester.getSize(find.byKey(const Key('continue'))).width,
          lessThanOrEqualTo(AppEntryLayout.maxWidth),
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('entry layout inherits the AMOLED canvas and lesson palette', (
    tester,
  ) async {
    final amoled = AppColors.dark.copyWith(
      canvas: AppColors.amoledCanvas,
      surface: AppColors.amoledSurface,
      surface2: AppColors.amoledSurface2,
    );
    AppColors? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme.copyWith(extensions: [amoled]),
        home: Scaffold(
          body: AppEntryLayout(
            title: 'Welcome',
            presentation: AppEntryPresentation.staged,
            child: Builder(
              builder: (context) {
                result = context.colors;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(result?.canvas, Colors.black);
    expect(result?.surface, AppColors.amoledSurface);
    expect(result?.lecture, amoled.lecture);
    expect(result?.practice, amoled.practice);
    expect(result?.accent, amoled.accent);
    expect(result?.onAccent, amoled.onAccent);
  });

  for (final width in [320.0, 430.0, 1024.0]) {
    testWidgets('preview fits at $width and blocks decorative controls', (
      tester,
    ) async {
      tester.view
        ..physicalSize = Size(width, 568)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var tapped = false;
      late BuildContext previewContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 568),
              textScaler: const TextScaler.linear(2),
            ),
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(24),
                child: AppEntryPreview(
                  child: Builder(
                    builder: (context) {
                      previewContext = context;
                      return Column(
                        children: [
                          const TextField(),
                          AppButton.primary(
                            key: const Key('preview-button'),
                            label: 'Open class',
                            onPressed: () => tapped = true,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(AppPreviewScope.of(previewContext), isTrue);
      expect(MediaQuery.textScalerOf(previewContext), TextScaler.noScaling);
      await tester.tap(
        find.byKey(const Key('preview-button')),
        warnIfMissed: false,
      );
      await tester.tap(find.byType(TextField), warnIfMissed: false);
      await tester.pump();
      expect(tapped, isFalse);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode
            .hasFocus,
        isFalse,
      );
    });
  }
}
