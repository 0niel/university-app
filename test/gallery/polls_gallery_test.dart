@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/polls.dart';

import 'gallery_fonts.dart';

class _Polls extends MockCubit<PollsState> implements PollsCubit {}

const _polls = [
  Poll(
    id: 'campus',
    title: 'Чего не хватает в кампусе?',
    description: 'Выберем, что улучшить в первую очередь.',
    category: 'feedback',
    authorName: 'Студенческий совет',
    isAnonymous: true,
    participantsCount: 128,
    questions: [
      PollQuestion(
        id: 'space',
        text: 'Где хотелось бы проводить время между парами?',
        kind: PollQuestionKind.single,
      ),
      PollQuestion(id: 'idea', text: 'Твоя идея', kind: PollQuestionKind.text),
    ],
  ),
  Poll(
    id: 'workshop',
    title: 'Когда провести воркшоп?',
    category: 'events',
    participantsCount: 40,
    iParticipated: true,
    canSeeResults: true,
    allowChange: true,
    questions: [
      PollQuestion(
        id: 'time',
        text: 'Когда провести воркшоп?',
        kind: PollQuestionKind.single,
        myOptionIds: ['fri'],
        options: [
          PollOption(id: 'wed', text: 'Среда, после пар', votes: 8),
          PollOption(
            id: 'fri',
            text: 'Пятница, в 18:00',
            votes: 24,
            position: 1,
          ),
          PollOption(id: 'sat', text: 'Суббота, днём', votes: 8, position: 2),
        ],
      ),
    ],
  ),
];

void main() {
  setUpAll(loadGalleryFonts);
  for (final dark in [false, true]) {
    testWidgets('polls phone dark=$dark', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final cubit = _Polls();
      when(() => cubit.state).thenReturn(
        const PollsState(status: PollsStatus.populated, polls: _polls),
      );
      when(() => cubit.hasMore).thenReturn(false);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<PollsCubit>.value(
            value: cubit,
            child: const PollsView(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/polls_catalog_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
