import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_card.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_profile_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_request_card.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_request_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentorship_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

import '../../helpers/mocks/mock_mentorship_cubit.dart';

void main() {
  group('MentorshipView', () {
    late MentorshipCubit cubit;

    setUp(() => cubit = MockMentorshipCubit());

    Widget buildSubject(MentorshipState state) {
      when(() => cubit.state).thenReturn(state);
      return _app(
        BlocProvider<MentorshipCubit>.value(
          value: cubit,
          child: const MentorshipView(),
        ),
      );
    }

    testWidgets('uses a skeleton instead of a spinner during cold load', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(const MentorshipState(status: .loading)),
      );

      expect(find.byType(MentorshipSkeleton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('keeps a cold-load error retryable', (tester) async {
      when(() => cubit.load()).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(const MentorshipState(status: .failure)),
      );

      expect(find.text('Не удалось загрузить менторов'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });

    testWidgets('become-mentor card uses the single accent-tinted surface', (
      tester,
    ) async {
      const mentor = Mentor(
        userId: 'mentor-1',
        fullName: 'Мария',
        bio: 'Помогаю с алгоритмами',
      );
      await tester.pumpWidget(
        buildSubject(
          const MentorshipState(
            status: .ready,
            requestsStatus: .ready,
            mentors: [mentor],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final colors = tester.element(find.byType(MentorshipView)).colors;
      final pastel = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .where(
            (decoration) =>
                decoration.color == colors.tint &&
                decoration.shape == BoxShape.rectangle,
          )
          .toList();
      expect(pastel, hasLength(1));
      expect(
        pastel.single.borderRadius,
        BorderRadius.circular(AppRadius.card),
      );
    });

    testWidgets('empty mentors list offers the become-mentor action', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildSubject(
          const MentorshipState(status: .ready, requestsStatus: .ready),
        ),
      );
      await tester.pumpAndSettle();

      final emptyState = tester.widget<NinjaEmptyState>(
        find.byType(NinjaEmptyState),
      );
      expect(emptyState.actionLabel, isNotNull);
      expect(emptyState.onAction, isNotNull);
    });

    testWidgets('forwards incoming request lifecycle actions', (tester) async {
      const request = MentorRequest(
        id: 'request-1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        requesterName: 'Иван',
      );
      when(
        () => cubit.actOnRequest('request-1', .accept),
      ).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(
          const MentorshipState(
            status: .ready,
            requestsStatus: .ready,
            requests: [request],
          ),
        ),
      );

      await tester.tap(find.text('Принять'));
      await tester.pump();

      verify(
        () => cubit.actOnRequest('request-1', .accept),
      ).called(1);
    });

    testWidgets('confirms cancellation before releasing an escrow', (
      tester,
    ) async {
      const request = MentorRequest(
        id: 'request-1',
        mentorUserId: 'mentor-1',
        requesterId: 'requester-1',
        mentorName: 'Mentor',
        isIncoming: false,
        status: .accepted,
      );
      when(
        () => cubit.actOnRequest('request-1', .cancel),
      ).thenAnswer((_) async => true);
      await tester.pumpWidget(
        buildSubject(
          const MentorshipState(
            status: .ready,
            requestsStatus: .ready,
            requests: [request],
          ),
        ),
      );

      await tester.tap(find.text('Отменить заявку'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('зарезервированные сюрикены вернутся'),
        findsOneWidget,
      );
      verifyNever(() => cubit.actOnRequest('request-1', .cancel));

      await tester.tap(
        find.descendant(
          of: find.byType(NinjaDialog),
          matching: find.text('Отменить заявку'),
        ),
      );
      await tester.pumpAndSettle();

      verify(() => cubit.actOnRequest('request-1', .cancel)).called(1);
    });
  });

  testWidgets('a mentor without Telegram can still receive a request', (
    tester,
  ) async {
    var requested = false;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: MentorCard(
            mentor: const Mentor(
              userId: 'mentor-1',
              fullName: 'Mentor',
              topics: ['python'],
            ),
            onRequest: () => requested = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Отправить запрос'));

    expect(requested, isTrue);
  });

  testWidgets('Telegram reply is disabled when no handle exists', (
    tester,
  ) async {
    var replies = 0;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: MentorRequestCard(
            request: const MentorRequest(
              id: 'request-1',
              mentorUserId: 'mentor-1',
              requesterId: 'requester-1',
              requesterName: 'Иван',
              status: .accepted,
            ),
            onReply: () => replies++,
            onAction: (_) => fail('Disabled card action was invoked'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ответить в Telegram'), warnIfMissed: false);

    expect(replies, 0);
  });

  testWidgets('an accepted request can be cancelled by a participant', (
    tester,
  ) async {
    MentorRequestAction? action;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: MentorRequestCard(
            request: const MentorRequest(
              id: 'request-1',
              mentorUserId: 'mentor-1',
              requesterId: 'requester-1',
              requesterName: 'Иван',
              status: .accepted,
            ),
            onReply: () => fail('Reply was invoked instead of cancellation'),
            onAction: (value) => action = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Отменить заявку'));

    expect(action?.wireValue, 'cancel');
  });

  testWidgets('profile and request forms support 320px at 200% text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final cubit = MockMentorshipCubit();
    when(() => cubit.state).thenReturn(const MentorshipState());
    const mentor = Mentor(
      userId: 'mentor-1',
      fullName: 'Mentor',
      topics: ['python'],
    );

    for (final form in <Widget>[
      const MentorProfileSheet(),
      const MentorRequestSheet(mentor: mentor),
    ]) {
      await tester.pumpWidget(
        _app(
          MediaQuery.withClampedTextScaling(
            minScaleFactor: 2,
            maxScaleFactor: 2,
            child: BlocProvider<MentorshipCubit>.value(
              value: cubit,
              child: Scaffold(
                body: Padding(
                  padding: const .all(16),
                  child: form,
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    }
  });
}

Widget _app(Widget home) => MaterialApp(
  theme: AppTheme.darkTheme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('ru'),
  home: home,
);
