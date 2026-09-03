import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/view/onboarding_page.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_schedule_repository.dart';

class _MockGamificationRepository extends Mock
    implements GamificationRepository {}

class _MockStorage extends Mock implements Storage {}

class _MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

const _config = UniversityConfig(
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

const _groups = [Group(name: 'ИКБО-01-24'), Group(name: 'ИКБО-02-24')];

Widget _app({
  required GamificationRepository gamification,
  required ScheduleRepository scheduleRepository,
  required ScheduleBloc scheduleBloc,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<UniversityConfig>.value(value: _config),
      RepositoryProvider<GamificationRepository>.value(value: gamification),
      RepositoryProvider<ScheduleRepository>.value(value: scheduleRepository),
    ],
    child: BlocProvider<ScheduleBloc>.value(
      value: scheduleBloc,
      child: MaterialApp(
        locale: const Locale('ru'),
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            accessibleNavigation: true,
            disableAnimations: true,
            textScaler: textScaler,
          ),
          child: child ?? const SizedBox.shrink(),
        ),
        home: const OnBoardingPage(),
      ),
    ),
  );
}

void main() {
  late _MockGamificationRepository gamification;
  late MockScheduleRepository scheduleRepository;
  late _MockScheduleBloc scheduleBloc;

  setUpAll(() {
    registerFallbackValue(const ScheduleRequested(group: Group(name: 'x')));
  });

  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;

    gamification = _MockGamificationRepository();
    when(
      () => gamification.ensureAcademicProfile(any()),
    ).thenAnswer((_) async {});
    when(
      () => gamification.getProfileOverview(_config.organizationId),
    ).thenAnswer((_) async => ProfileOverview.empty);

    scheduleRepository = MockScheduleRepository();
    when(
      () => scheduleRepository.searchGroups(query: any(named: 'query')),
    ).thenAnswer((invocation) async {
      final query = invocation.namedArguments[#query] as String;
      return SearchGroupsResponse(
        results: _groups.where((g) => g.name.contains(query)).toList(),
      );
    });
    when(
      () => scheduleRepository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer((_) async => const SearchTeachersResponse(results: []));
    when(
      () => scheduleRepository.searchClassrooms(query: any(named: 'query')),
    ).thenAnswer((_) async => const SearchClassroomsResponse(results: []));

    scheduleBloc = _MockScheduleBloc();
    when(() => scheduleBloc.state).thenReturn(const ScheduleState());
    when(() => scheduleBloc.add(any())).thenReturn(null);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await tester.pumpWidget(
      _app(
        gamification: gamification,
        scheduleRepository: scheduleRepository,
        scheduleBloc: scheduleBloc,
      ),
    );
    await tester.pump();
  }

  Future<void> openGroupStep(WidgetTester tester) async {
    await pumpPage(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_start')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('onboarding_start')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('onboarding_groupSearch')),
        matching: find.byType(EditableText),
      ),
      query,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
  }

  bool continueEnabled(WidgetTester tester) =>
      tester
          .widget<AppButton>(find.byKey(const Key('onboarding_groupContinue')))
          .onPressed !=
      null;

  testWidgets('welcome step renders the mock elements', (tester) async {
    await pumpPage(tester);

    expect(
      find.text('Университет\nв одном касании', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text(
        'Пары, дедлайны, свободные аудитории и пропуск — без лишних вкладок.',
      ),
      findsOneWidget,
    );
    expect(find.text('Расписание с изменениями'), findsOneWidget);
    expect(find.text('Свободные аудитории рядом'), findsOneWidget);
    expect(find.text('Друзья на кампусе'), findsOneWidget);
    expect(find.text('Начать'), findsOneWidget);
    expect(find.text('У меня есть аккаунт'), findsOneWidget);
    expect(find.bySemanticsLabel('Шаг 1 из 4'), findsOneWidget);
    expect(find.textContaining('MIREA'), findsNothing);
  });

  testWidgets('welcome accent word is italic accent serif', (tester) async {
    await pumpPage(tester);

    final rich = tester.widget<RichText>(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText() == 'Университет\nв одном касании',
      ),
    );
    final colors = tester.element(find.byType(OnBoardingPage)).colors;
    final spans = <TextSpan>[];
    rich.text.visitChildren((span) {
      if (span is TextSpan && span.text == 'касании') spans.add(span);
      return true;
    });
    expect(spans, hasLength(1));
    expect(spans.single.style?.color, colors.accent);
    expect(spans.single.style?.fontStyle, FontStyle.italic);
    expect(spans.single.style?.fontFamily, AppText.serifFamily);
  });

  testWidgets('start opens the group step with a disabled continue', (
    tester,
  ) async {
    await openGroupStep(tester);

    expect(find.text('Твоя группа'), findsOneWidget);
    expect(
      find.text(
        'Расписание подтянется автоматически. Изменить можно в настройках.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('onboarding_groupSearch')), findsOneWidget);
    expect(find.text('Продолжить'), findsOneWidget);
    expect(continueEnabled(tester), isFalse);
    expect(find.bySemanticsLabel('Шаг 2 из 4'), findsOneWidget);
  });

  testWidgets('back returns to the welcome step', (tester) async {
    await openGroupStep(tester);
    await tester.tap(find.byType(AppBackButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Начать'), findsOneWidget);
  });

  testWidgets('picking a group requests its schedule and enables continue', (
    tester,
  ) async {
    await openGroupStep(tester);
    await search(tester, 'ИКБО');

    expect(find.text('ИКБО-01-24'), findsNWidgets(2));
    expect(find.text('ИКБО-02-24'), findsOneWidget);

    await tester.tap(find.text('ИКБО-02-24'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    verify(
      () => scheduleBloc.add(
        any(
          that: isA<ScheduleRequested>().having(
            (event) => event.group.name,
            'group',
            'ИКБО-02-24',
          ),
        ),
      ),
    ).called(1);
    expect(continueEnabled(tester), isTrue);
    final field = tester.widget<AppInputField>(
      find.byKey(const Key('onboarding_groupSearch')),
    );
    final colors = tester.element(find.byType(OnBoardingPage)).colors;
    expect(field.fillColor, colors.lectureTint);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('unknown group shows the not found hint', (tester) async {
    await openGroupStep(tester);
    await search(tester, 'ZZZ');

    expect(
      find.textContaining('Группа не найдена', findRichText: true),
      findsOneWidget,
    );
    expect(continueEnabled(tester), isFalse);
  });

  testWidgets('welcome stays actionable at 320px and 200% text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _app(
        gamification: gamification,
        scheduleRepository: scheduleRepository,
        scheduleBloc: scheduleBloc,
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const Key('onboarding_haveAccount')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Начать'), findsOneWidget);
    expect(find.text('У меня есть аккаунт'), findsOneWidget);
  });
}
