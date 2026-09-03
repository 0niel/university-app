@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/cubit/events/events_cubit.dart';
import 'package:rtu_mirea_app/community/view/collab_notes_view.dart';
import 'package:rtu_mirea_app/community/view/events_view.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';
import 'package:rtu_mirea_app/polls/polls.dart';
import 'package:rtu_mirea_app/wallet/wallet.dart';

import 'gallery_fonts.dart';

class _Feed extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class _Categories extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class _Article extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class _Saved extends MockCubit<List<String>> implements SavedArticlesCubit {}

class _Followed extends MockCubit<List<String>>
    implements FollowedSourcesCubit {}

class _Catalog extends MockCubit<CommunityCatalogState>
    implements CommunityCatalogCubit {}

class _Joined extends MockCubit<List<String>>
    implements JoinedCommunitiesCubit {}

class _Market extends MockCubit<MarketplaceState> implements MarketplaceCubit {}

class _Polls extends MockCubit<PollsState> implements PollsCubit {}

class _Events extends MockCubit<EventsState> implements EventsCubit {}

class _Notes extends MockCubit<CollabNotesState> implements CollabNotesCubit {}

class _Knowledge extends MockCubit<KnowledgeBankState>
    implements KnowledgeBankCubit {}

class _Wallet extends MockCubit<WalletState> implements WalletCubit {}

const _title = 'Новый коворкинг на 3 этаже В-78 открывается с понедельника';
const _lead =
    '120 мест, розетки у каждого стола и тихая зона. '
    'Бронь через приложение — за час до прихода.';

void main() {
  setUpAll(loadGalleryFonts);

  for (final dark in [false, true]) {
    testWidgets('community actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final saved = _Joined();
      when(() => saved.state).thenReturn([]);
      when(() => saved.isJoined(any())).thenReturn(false);
      await _capture(
        tester,
        'community',
        dark,
        BlocProvider<JoinedCommunitiesCubit>.value(
          value: saved,
          child: CommunityDetailPage(
            entry: _community(
              'ml',
              'ML Club MIREA',
              312,
              'Разбираем статьи, готовимся к соревнованиям, '
                  'пилим совместные проекты. Встречи по четвергам.',
            ),
            categoryTitle: 'IT',
          ),
        ),
      );
    });

    testWidgets('polls actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final polls = _Polls();
      when(() => polls.hasMore).thenReturn(false);
      when(() => polls.state).thenReturn(
        PollsState(
          status: .populated,
          polls: [
            const Poll(
              id: 'consultation',
              title: 'Когда удобнее консультация по матанализу?',
              resultsVisibility: .afterVote,
              participantsCount: 24,
              questions: [
                PollQuestion(
                  id: 'consultation-time',
                  text: 'Выберите время консультации',
                  kind: .single,
                  options: [
                    PollOption(id: 'mon', text: 'Пн 16:20', votes: 8),
                    PollOption(id: 'wed', text: 'Ср 16:20', votes: 11),
                    PollOption(id: 'sat', text: 'Сб 10:40', votes: 5),
                  ],
                ),
              ],
            ),
            const Poll(
              id: 'trip',
              title: 'Едем на выезд группы 12–13 сентября?',
              resultsVisibility: .afterVote,
              participantsCount: 21,
              questions: [
                PollQuestion(
                  id: 'trip-participation',
                  text: 'Планируете участвовать?',
                  kind: .single,
                  options: [
                    PollOption(id: 'yes', text: 'Да, еду', votes: 14),
                    PollOption(id: 'day', text: 'Только на день', votes: 4),
                    PollOption(id: 'no', text: 'Нет', votes: 3),
                  ],
                ),
              ],
            ),
            Poll(
              id: 'canteen',
              title: 'Оцените столовую В-78 в августе',
              expiresAt: DateTime(2026, 8, 31),
              participantsCount: 556,
              iParticipated: true,
              canSeeResults: true,
              questions: const [
                PollQuestion(
                  id: 'canteen-feedback',
                  text: 'Как вам столовая?',
                  kind: .single,
                  myOptionIds: ['ok'],
                  options: [
                    PollOption(id: 'great', text: 'Отлично', votes: 120),
                    PollOption(
                      id: 'ok',
                      text: 'Нормально',
                      votes: 340,
                      votedByMe: true,
                    ),
                    PollOption(id: 'bad', text: 'Плохо', votes: 96),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
      await _capture(
        tester,
        'polls',
        dark,
        BlocProvider<PollsCubit>.value(value: polls, child: const PollsView()),
      );
    });

    testWidgets('events actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final events = _Events();
      when(() => events.state).thenReturn(
        EventsState(
          status: .ready,
          events: [
            CampusEvent(
              id: 'welcome',
              title: 'Посвящение первокурсников',
              startsAt: DateTime(2026, 9, 12, 16),
              place: 'Площадь у В-78',
              category: 'art',
              goingCount: 412,
            ),
            CampusEvent(
              id: 'search',
              title: 'Лекция: как устроен поиск в Яндексе',
              startsAt: DateTime(2026, 9, 3, 18),
              place: 'А-16',
              category: 'sci',
              goingCount: 86,
            ),
            CampusEvent(
              id: 'hackathon',
              title: 'Хакатон ИИТ · открытие',
              startsAt: DateTime(2026, 9, 4, 10),
              place: 'Коворкинг В-78',
              category: 'sci',
              goingCount: 64,
            ),
          ],
        ),
      );
      await _capture(
        tester,
        'events',
        dark,
        BlocProvider<EventsCubit>.value(
          value: events,
          child: const EventsView(),
        ),
      );
    });

    testWidgets('notes actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final notes = _Notes();
      when(() => notes.state).thenReturn(
        CollabNotesState(
          status: .ready,
          notes: [
            for (final (index, fixture) in [
              ('Лекция 1 сент · пределы и непрерывность', 'Аня К.'),
              ('Практика · генераторы, itertools', 'Миша Р.'),
              ('Лаба 2 · шаблон отчёта + формулы', 'Катя В.'),
              ('Семинар · античность, конспект', 'Олег К.'),
              ('Unit 1 · vocabulary list', 'Даша С.'),
            ].indexed)
              CollabNote(
                id: 'note-$index',
                title: fixture.$1,
                updatedByName: fixture.$2,
                createdAt: DateTime.now().subtract(Duration(days: index)),
                updatedAt: DateTime.now().subtract(Duration(hours: index + 2)),
              ),
          ],
        ),
      );
      await _capture(
        tester,
        'notes',
        dark,
        BlocProvider<CollabNotesCubit>.value(
          value: notes,
          child: const CollabNotesView(),
        ),
      );
    });

    testWidgets('knowledge actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final knowledge = _Knowledge();
      when(() => knowledge.state).thenReturn(
        KnowledgeBankState(
          status: .populated,
          materials: [
            for (final (index, fixture) in [
              ('Базы данных', 'Билеты к КР · 2025', 'exam'),
              ('Математический анализ', 'Коллоквиум · решения задач', 'task'),
              ('Физика', 'Все лабы · отчёты-образцы', 'note'),
              ('Дискретная математика', 'Шпаргалка по графам', 'cheat'),
              ('Английский язык', 'Тесты Units 1–6 с ответами', 'exam'),
            ].indexed)
              StudyMaterial(
                id: 'material-$index',
                title: fixture.$2,
                subjectName: fixture.$1,
                materialType: fixture.$3,
                fileName: 'material-$index.pdf',
                hasFile: true,
              ),
          ],
        ),
      );
      await _capture(
        tester,
        'knowledge',
        dark,
        BlocProvider<KnowledgeBankCubit>.value(
          value: knowledge,
          child: const KnowledgeBankView(),
        ),
      );
    });

    testWidgets('wallet actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final wallet = _Wallet();
      when(() => wallet.state).thenReturn(
        const WalletState(
          status: .populated,
          profile: UserGamificationProfile(
            userId: 'student',
            shurikens: 3850,
            xp: 340,
            level: 3,
            streakDays: 4,
          ),
        ),
      );
      await _capture(
        tester,
        'wallet',
        dark,
        BlocProvider<WalletCubit>.value(
          value: wallet,
          child: const WalletView(),
        ),
      );
    });

    testWidgets('news actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final categories = _categories();
      final feed = _Feed();
      when(() => feed.state).thenReturn(
        FeedState(
          status: .populated,
          hasMoreNews: const {'all': false},
          feed: {
            'all': [
              PostMediumBlock(
                id: 'first',
                categoryId: 'source:telegram:МИРЭА',
                author: 'МИРЭА',
                publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
                imageUrl: '',
                title: _title,
                description: _lead,
              ),
              PostMediumBlock(
                id: 'second',
                categoryId: 'source:telegram:ИИТ',
                author: 'ИИТ',
                publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
                imageUrl: '',
                title: 'Открыта запись на хакатон по ML: команды до 4 человек',
              ),
              PostMediumBlock(
                id: 'third',
                categoryId: 'source:telegram:Профком',
                author: 'Профком',
                publishedAt: DateTime.now().subtract(const Duration(days: 1)),
                imageUrl: '',
                title: 'Материальная помощь: приём заявлений до 15 сентября',
              ),
            ],
          },
        ),
      );
      await _capture(
        tester,
        'news',
        dark,
        MultiBlocProvider(
          providers: [
            BlocProvider<CategoriesBloc>.value(value: categories),
            BlocProvider<FeedBloc>.value(value: feed),
          ],
          child: const Scaffold(body: NewsFeedView()),
        ),
      );
    });

    testWidgets('article actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final article = _Article();
      final saved = _Saved();
      final followed = _Followed();
      when(() => article.id).thenReturn('first');
      when(() => saved.state).thenReturn([]);
      when(() => saved.isSaved(any())).thenReturn(false);
      when(() => followed.state).thenReturn([]);
      when(() => followed.isFollowed(any())).thenReturn(false);
      when(() => article.state).thenReturn(
        ArticleState(
          status: .populated,
          title: _title,
          uri: Uri.https('example.com', '/news/1'),
          content: [
            ArticleIntroductionBlock(
              categoryId: 'source:telegram:МИРЭА',
              author: 'МИРЭА',
              publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
              title: _title,
            ),
            const TextLeadParagraphBlock(text: _lead),
            const TextParagraphBlock(
              text:
                  'Коворкинг займёт бывшую читальную зону библиотеки. '
                  'Работать он будет с 8:00 до 22:00, включая субботу.',
            ),
            const TextParagraphBlock(
              text:
                  'Места бронируются в разделе «Сервисы → Коворкинг» '
                  'на 2 часа с возможностью продления, если нет очереди.',
            ),
          ],
        ),
      );
      await _capture(
        tester,
        'article',
        dark,
        MultiBlocProvider(
          providers: [
            BlocProvider<ArticleBloc>.value(value: article),
            BlocProvider<SavedArticlesCubit>.value(value: saved),
            BlocProvider<FollowedSourcesCubit>.value(value: followed),
            BlocProvider<CategoriesBloc>.value(value: _categories()),
          ],
          child: const ArticleView(isVideoArticle: false),
        ),
      );
    });

    testWidgets('communities actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final catalog = _Catalog();
      final saved = _Joined();
      when(() => saved.state).thenReturn(['group', 'institute']);
      when(() => saved.isJoined(any())).thenAnswer(
        (call) =>
            ['group', 'institute'].contains(call.positionalArguments.first),
      );
      when(() => catalog.state).thenReturn(
        CommunityCatalogState(
          status: .success,
          catalog: CommunityCatalog(
            organizationId: 'mirea',
            suggestionUrl: 'https://example.com/suggest',
            sections: [
              CommunityCatalogSection(
                key: 'study',
                title: 'Учёба',
                emoji: '',
                items: [
                  _community('group', 'ИКБО-01-24', 27, ''),
                  _community('institute', 'Институт ИТ', 4200, ''),
                ],
              ),
              for (final category in [
                'Спорт',
                'Творчество',
                'IT',
                'Волонтёрство',
              ])
                CommunityCatalogSection(
                  key: category,
                  title: category,
                  emoji: '',
                  items: category == 'IT'
                      ? [
                          _community(
                            'ml',
                            'ML Club MIREA',
                            312,
                            'Разбираем статьи, готовимся к соревнованиям, '
                                'пилим совместные проекты. '
                                'Встречи по четвергам.',
                          ),
                        ]
                      : [],
                ),
            ],
          ),
        ),
      );
      await _capture(
        tester,
        'communities',
        dark,
        MultiBlocProvider(
          providers: [
            BlocProvider<CommunityCatalogCubit>.value(value: catalog),
            BlocProvider<JoinedCommunitiesCubit>.value(value: saved),
          ],
          child: const AllCommunitiesView(),
        ),
      );
    });

    testWidgets('market actual screen ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      final market = _Market();
      when(() => market.state).thenReturn(
        const MarketplaceState(
          status: .ready,
          items: [
            MarketListing(
              id: '1',
              title: 'Фихтенгольц, 3 тома',
              price: 900,
              sellerName: 'Тимур Л.',
              category: 'books',
            ),
            MarketListing(
              id: '2',
              title: 'Калькулятор Casio fx-991',
              price: 1200,
              sellerName: 'Даша С.',
              category: 'electronics',
            ),
            MarketListing(
              id: '3',
              title: 'Репетитор по матанализу · 1 курс',
              price: 800,
              sellerName: 'Аня К.',
              category: 'services',
            ),
            MarketListing(
              id: '4',
              title: 'Халат для лабораторных, M',
              price: 0,
              sellerName: 'Миша Р.',
            ),
          ],
        ),
      );
      await _capture(
        tester,
        'market',
        dark,
        BlocProvider<MarketplaceCubit>.value(
          value: market,
          child: MarketplaceView(onToggleFavorite: (_) {}),
        ),
      );
    });
  }
}

CategoriesBloc _categories() {
  final categories = _Categories();
  when(() => categories.state).thenReturn(
    CategoriesState(
      status: .populated,
      selectedCategory: const Category(id: 'all', name: 'Все'),
      categories: [
        const Category(id: 'all', name: 'Все'),
        for (final source in ['МИРЭА', 'ИИТ', 'Профком', 'Спорт', 'Наука'])
          Category(id: 'source:telegram:$source', name: source),
      ],
      sources: [
        for (final source in ['МИРЭА', 'ИИТ', 'Профком', 'Спорт', 'Наука'])
          NewsSourceItem(
            sourceType: 'telegram',
            sourceId: source,
            sourceName: source,
          ),
      ],
    ),
  );
  return categories;
}

CommunityCatalogEntry _community(
  String id,
  String title,
  int members,
  String description,
) => CommunityCatalogEntry(
  id: id,
  slug: id,
  title: title,
  description: description,
  url: 'https://example.com/$id',
  platform: 'telegram',
  membersCount: members,
);

Future<void> _capture(
  WidgetTester tester,
  String name,
  bool dark,
  Widget child,
) async {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  expect(tester.takeException(), isNull);
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/${name}_screen_${dark ? 'dark' : 'light'}.png'),
  );
}
