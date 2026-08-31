import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_schedule_repository.dart';

class OnboardingPageTest extends Mock implements GamificationRepository {}

class _MockStorage extends Mock implements Storage {}

Widget _app(
  GamificationRepository repository, {
  required UniversityConfig config,
  bool reduceMotion = false,
  TextScaler textScaler = TextScaler.noScaling,
  ScheduleRepository? scheduleRepository,
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<UniversityConfig>.value(value: config),
      RepositoryProvider<GamificationRepository>.value(value: repository),
      if (scheduleRepository != null)
        RepositoryProvider<ScheduleRepository>.value(value: scheduleRepository),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          accessibleNavigation: reduceMotion,
          disableAnimations: reduceMotion,
          textScaler: textScaler,
        ),
        child: child ?? const SizedBox.shrink(),
      ),
      home: const OnBoardingPage(),
    ),
  );
}

NinjaColors _colorsOf(WidgetTester tester) =>
    tester.element(find.byType(OnBoardingPage)).ninja;

Iterable<BoxDecoration> _decorations(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(find.byType(DecoratedBox))
    .map((box) => box.decoration)
    .whereType<BoxDecoration>();

int _accentSoftCards(WidgetTester tester, NinjaColors colors) => _decorations(
  tester,
).where((decoration) => decoration.color == colors.accentSoft).length;

Finder _circleChrome(NinjaColors colors) => find.byWidgetPredicate((widget) {
  if (widget is! DecoratedBox) return false;
  final decoration = widget.decoration;
  return decoration is BoxDecoration &&
      decoration.shape == BoxShape.circle &&
      decoration.color == colors.surfaceAlt;
});

void main() {
  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  const config = UniversityConfig(
    organizationId: 'test-university',
    appName: 'Campus Hub',
    universityName: 'Test University',
    universityShortName: 'TU',
    websiteUrl: 'https://university.example.edu',
    supportEmail: 'support@example.edu',
    deepLinkScheme: 'campushub',
    webAppHost: 'campus.example.edu',
    webAppPathPrefix: '/app',
  );

  testWidgets('uses deployment branding instead of MIREA hardcodes', (
    tester,
  ) async {
    final repository = OnboardingPageTest();
    when(
      () => repository.getProfileOverview(config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    await tester.pumpWidget(_app(repository, config: config));
    await tester.pump();

    expect(find.text(config.appName), findsOneWidget);
    expect(find.text('open-source · ${config.webAppHost}'), findsOneWidget);
    expect(find.textContaining('MIREA'), findsNothing);
    expect(find.text('Next'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('welcome hero is the only pastel accent card', (tester) async {
    final repository = OnboardingPageTest();
    when(
      () => repository.getProfileOverview(config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    await tester.pumpWidget(_app(repository, config: config));
    await tester.pump();

    final colors = _colorsOf(tester);
    expect(_accentSoftCards(tester, colors), 1);

    final appName = tester.widget<Text>(find.text(config.appName));
    expect(appName.style?.fontSize, NinjaText.display.fontSize);
    expect(appName.style?.color, colors.onAccentSoft);

    final tagline = tester.widget<Text>(
      find.text('Schedule, map, grades and community — all in one pocket.'),
    );
    expect(tagline.style?.fontSize, NinjaText.body.fontSize);
    expect(tagline.style?.color, colors.onAccentSoftMuted);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('steps wear circular back chrome, brand pills and flat cards', (
    tester,
  ) async {
    final repository = OnboardingPageTest();
    when(
      () => repository.getProfileOverview(config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    await tester.pumpWidget(
      _app(
        repository,
        config: config,
        scheduleRepository: MockScheduleRepository(),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final colors = _colorsOf(tester);
    expect(_accentSoftCards(tester, colors), isZero);

    expect(
      find.descendant(
        of: find.bySemanticsLabel('Back'),
        matching: _circleChrome(colors),
      ),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.bySemanticsLabel('Back')),
      const Size(NinjaMetrics.minTouchTarget, NinjaMetrics.minTouchTarget),
    );

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.value == '1 / 3',
      ),
      findsOneWidget,
    );
  });

  testWidgets('does not schedule decorative frames with reduced motion', (
    tester,
  ) async {
    final repository = OnboardingPageTest();
    when(
      () => repository.getProfileOverview(config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    await tester.pumpWidget(
      _app(repository, config: config, reduceMotion: true),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 8));

    expect(tester.binding.hasScheduledFrame, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('welcome stays compact and actionable at 320px and 200% text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final repository = OnboardingPageTest();
    when(
      () => repository.getProfileOverview(config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    await tester.pumpWidget(
      _app(
        repository,
        config: config,
        reduceMotion: true,
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Continue as guest'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text(config.appName), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
  });
}
