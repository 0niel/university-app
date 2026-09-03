import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/login/widgets/widgets.dart';

Widget _app({
  required Widget child,
  Widget? actions,
  bool showBack = true,
  int? step,
  int? totalSteps,
  String? titleAccent,
  VoidCallback? onBack,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, inner) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: textScaler,
        disableAnimations: true,
        accessibleNavigation: true,
      ),
      child: inner!,
    ),
    home: Scaffold(
      body: AuthPageLayout(
        title: 'Welcome back',
        titleAccent: titleAccent,
        subtitle: 'Use your university account to continue',
        showBack: showBack,
        onBack: onBack,
        step: step,
        totalSteps: totalSteps,
        actions: actions,
        child: child,
      ),
    ),
  );
}

void main() {
  testWidgets('renders serif title, lead, back circle and progress', (
    tester,
  ) async {
    var backs = 0;
    await tester.pumpWidget(
      _app(
        step: 2,
        totalSteps: 3,
        onBack: () => backs++,
        child: const SizedBox.shrink(),
      ),
    );
    await tester.pump();

    final colors = tester.element(find.byType(AuthPageLayout)).colors;
    final title = tester.widget<Text>(find.text('Welcome back'));
    expect(title.style?.fontFamily, AppText.serifFamily);
    expect(title.style?.fontSize, AppText.displayHero.fontSize);
    final lead = tester.widget<Text>(
      find.text('Use your university account to continue'),
    );
    expect(lead.style?.color, colors.muted);
    expect(lead.style?.fontSize, AppText.bodyLarge.fontSize);

    expect(find.bySemanticsLabel('Шаг 2 из 3'), findsOneWidget);
    final bars = tester
        .widgetList<AnimatedContainer>(
          find.descendant(
            of: find.byType(AuthProgress),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .toList();
    expect(bars, hasLength(3));
    Color? barColor(AnimatedContainer bar) =>
        (bar.decoration as BoxDecoration?)?.color;
    expect(barColor(bars[0]), colors.accent);
    expect(barColor(bars[1]), colors.accent);
    expect(barColor(bars[2]), colors.surface2);

    expect(
      tester.getSize(find.byType(AppBackButton)).shortestSide,
      AppControlSize.iconButton,
    );
    await tester.tap(find.byType(AppBackButton));
    expect(backs, 1);
  });

  testWidgets('hides back and progress when not requested', (tester) async {
    await tester.pumpWidget(
      _app(showBack: false, child: const SizedBox.shrink()),
    );
    await tester.pump();

    expect(find.byType(AppBackButton), findsNothing);
    expect(find.byType(AuthProgress), findsNothing);
  });

  testWidgets('accent word renders italic in accent colour', (tester) async {
    await tester.pumpWidget(
      _app(titleAccent: 'back', child: const SizedBox.shrink()),
    );
    await tester.pump();

    final colors = tester.element(find.byType(AuthPageLayout)).colors;
    final rich = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText() == 'Welcome back',
      ),
    );
    TextSpan? accent;
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text == 'back') accent = span;
      return true;
    });
    expect(accent, isNotNull);
    expect(accent?.style?.color, colors.accent);
    expect(accent?.style?.fontStyle, FontStyle.italic);
  });

  testWidgets('pins actions at the bottom and stays scrollable when large', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _app(
        textScaler: const TextScaler.linear(2),
        actions: AppButton.primary(
          key: const Key('continue'),
          label: 'Continue',
          size: AppButtonSize.hero,
          expanded: true,
          onPressed: () {},
        ),
        child: const Column(
          children: [
            AppInputField(placeholder: 'Email'),
            SizedBox(height: 12),
            AppInputField(placeholder: 'Password'),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.byKey(const Key('continue')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.byKey(const Key('continue')), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('continue'))).height,
      AppControlSize.buttonHero,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout-aware feedback and actions retain bottom placement', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _app(
        actions: LayoutBuilder(
          builder: (context, constraints) => AppButton.primary(
            key: const Key('layout-aware-action'),
            label: 'Continue',
            expanded: true,
            onPressed: () {},
          ),
        ),
        child: AppBanner(
          message: 'The code was rejected. Try again.',
          actionLabel: 'Retry',
          tone: AppBannerTone.danger,
          onAction: () {},
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('The code was rejected. Try again.'), findsOneWidget);
    expect(
      tester.getBottomRight(find.byKey(const Key('layout-aware-action'))).dy,
      844 - AuthPageLayout.bottomPadding,
    );
  });
}
