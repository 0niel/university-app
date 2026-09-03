@Tags(['gallery'])
library;

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:rtu_mirea_app/article/article.dart';
import 'package:rtu_mirea_app/categories/categories.dart';
import 'package:rtu_mirea_app/communities/communities.dart';
import 'package:rtu_mirea_app/communities/cubit/community_catalog_status.dart';
import 'package:rtu_mirea_app/community/cubit/collab_notes/collab_notes.dart';
import 'package:rtu_mirea_app/community/cubit/events/events.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/view/collab_note_editor_view.dart';
import 'package:rtu_mirea_app/community/view/collab_notes_view.dart';
import 'package:rtu_mirea_app/community/view/events_view.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/create_collab_note_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/create_event_sheet.dart';
import 'package:rtu_mirea_app/feed/feed.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';
import 'package:rtu_mirea_app/polls/polls.dart';
import 'package:rtu_mirea_app/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gallery_fonts.dart';

class _Feed extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class _Categories extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class _Article extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class _Saved extends MockCubit<List<String>> implements SavedArticlesCubit {}

class _Catalog extends MockCubit<CommunityCatalogState>
    implements CommunityCatalogCubit {}

class _Joined extends MockCubit<List<String>>
    implements JoinedCommunitiesCubit {}

class _Polls extends MockCubit<PollsState> implements PollsCubit {}

class _Events extends MockCubit<EventsState> implements EventsCubit {}

class _Notes extends MockCubit<CollabNotesState> implements CollabNotesCubit {}

class _Editor extends MockCubit<NoteEditorState> implements NoteEditorCubit {}

class _Knowledge extends MockCubit<KnowledgeBankState>
    implements KnowledgeBankCubit {}

class _Lost extends MockCubit<LostFoundState> implements LostFoundCubit {}

class _Market extends MockCubit<MarketplaceState> implements MarketplaceCubit {}

class _ContactPrefs extends MockCubit<String>
    implements MarketContactPrefsCubit {}

class _Wallet extends MockCubit<WalletState> implements WalletCubit {}

class _Campus extends Mock implements CampusRepository {}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await loadGalleryFonts();
    registerFallbackValue(
      const FeedRequested(
        category: Category(id: 'science', name: 'Наука'),
      ),
    );
  });

  for (final dark in [false, true]) {
    for (final screen in [
      'news',
      'communities',
      'polls',
      'events',
      'notes',
      'knowledge',
      'lost',
      'market',
      'wallet',
    ]) {
      testWidgets('$screen loading empty failure ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        await _capture(tester, '${screen}_states', dark, [
          for (final status in ['loading', 'empty', 'failure'])
            _screen(screen, status),
        ]);
      });
    }
    testWidgets('article loading failure ${dark ? 'dark' : 'light'}', (
      tester,
    ) async {
      await _capture(tester, 'article_states', dark, [
        _article(ArticleStatus.loading),
        _article(ArticleStatus.failure),
      ]);
    });
    testWidgets(
      'note editor saved saving conflict ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _capture(tester, 'note_editor_states', dark, [
          for (final status in [
            NoteEditorStatus.saved,
            NoteEditorStatus.saving,
            NoteEditorStatus.conflict,
          ])
            _editor(status),
        ]);
      },
    );
    testWidgets(
      'note lost market submitting sheets ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _capture(tester, 'social_submitting_sheets', dark, [
          for (final form in ['note', 'lost', 'market'])
            _sheet(form, pending: true),
        ]);
      },
    );
    testWidgets(
      'story content loading empty failure ${dark ? 'dark' : 'light'}',
      (
        tester,
      ) async {
        await _capture(tester, 'story_states', dark, [
          _story(FeedStatus.populated),
          _story(FeedStatus.loading),
          _story(FeedStatus.populated, empty: true),
          _story(FeedStatus.failure),
        ]);
      },
    );
    for (final form in [
      'poll',
      'event',
      'note',
      'material',
      'lost',
      'market',
    ]) {
      testWidgets(
        '$form sheet at 320px and 200 percent ${dark ? 'dark' : 'light'}',
        (tester) async {
          await _capture(
            tester,
            form,
            dark,
            [_sheet(form)],
            panelSize: const Size(320, 700),
            textScale: 2,
            golden: false,
          );
        },
      );
      testWidgets('$form sheet ${dark ? 'dark' : 'light'}', (tester) async {
        await _capture(tester, '${form}_sheet', dark, [_sheet(form)]);
      });
    }
    testWidgets(
      'market contact private sold sheets ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _capture(tester, 'market_details', dark, [
          for (final state in ['contact', 'private', 'sold'])
            _SheetLauncher(
              title: 'Учебник физики',
              kind: 'marketDetail',
              child: MarketListingDetailsSheet(
                item: MarketListing(
                  id: state,
                  title: 'Учебник физики',
                  price: 500,
                  sellerName: 'Мария',
                  description: 'Учебник в хорошем состоянии.',
                  showContact: state != 'private',
                  telegramHandle: state == 'private' ? null : 'maria',
                  isSold: state == 'sold',
                ),
                onContact: () {},
                onShare: () {},
              ),
            ),
        ]);
      },
    );
    testWidgets(
      'lost owner pending private sheets ${dark ? 'dark' : 'light'}',
      (tester) async {
        await _capture(tester, 'lost_details', dark, [
          for (final state in ['owner', 'pending', 'private'])
            _lostDetails(state),
        ]);
      },
    );
  }
}

Widget _screen(String screen, String status) {
  switch (screen) {
    case 'news':
      final feed = _Feed();
      when(() => feed.state).thenReturn(
        FeedState(
          status: status == 'empty'
              ? .populated
              : FeedStatus.values.byName(status),
          feed: status == 'empty' ? {'all': []} : {},
        ),
      );
      return MultiBlocProvider(
        providers: [
          BlocProvider<FeedBloc>.value(value: feed),
          BlocProvider<CategoriesBloc>.value(value: _categories()),
        ],
        child: const Scaffold(body: NewsFeedView()),
      );
    case 'communities':
      final catalog = _Catalog();
      final saved = _Joined();
      when(() => catalog.state).thenReturn(
        CommunityCatalogState(
          catalog: status == 'empty'
              ? const CommunityCatalog(organizationId: 'mirea', sections: [])
              : null,
          status: status == 'empty'
              ? .success
              : CommunityCatalogStatus.values.byName(status),
        ),
      );
      when(() => saved.state).thenReturn([]);
      return MultiBlocProvider(
        providers: [
          BlocProvider<CommunityCatalogCubit>.value(value: catalog),
          BlocProvider<JoinedCommunitiesCubit>.value(value: saved),
        ],
        child: const AllCommunitiesView(),
      );
    case 'polls':
      final cubit = _Polls();
      when(() => cubit.hasMore).thenReturn(false);
      when(() => cubit.state).thenReturn(
        PollsState(
          status: status == 'empty'
              ? .populated
              : PollsStatus.values.byName(status),
        ),
      );
      return BlocProvider<PollsCubit>.value(
        value: cubit,
        child: const PollsView(),
      );
    case 'events':
      final cubit = _Events();
      when(() => cubit.state).thenReturn(
        EventsState(
          status: status == 'empty'
              ? .ready
              : EventsStatus.values.byName(status),
        ),
      );
      return BlocProvider<EventsCubit>.value(
        value: cubit,
        child: const EventsView(),
      );
    case 'notes':
      final cubit = _Notes();
      when(() => cubit.state).thenReturn(
        CollabNotesState(
          status: status == 'empty'
              ? .ready
              : CollabNotesStatus.values.byName(status),
        ),
      );
      return BlocProvider<CollabNotesCubit>.value(
        value: cubit,
        child: const CollabNotesView(),
      );
    case 'knowledge':
      final cubit = _Knowledge();
      when(() => cubit.state).thenReturn(
        KnowledgeBankState(
          status: status == 'empty'
              ? .populated
              : KnowledgeBankStatus.values.byName(status),
        ),
      );
      return BlocProvider<KnowledgeBankCubit>.value(
        value: cubit,
        child: const KnowledgeBankView(),
      );
    case 'lost':
      final cubit = _Lost();
      when(() => cubit.state).thenReturn(
        LostFoundState(
          status: status == 'empty'
              ? .ready
              : LostFoundStatus.values.byName(status),
        ),
      );
      return BlocProvider<LostFoundCubit>.value(
        value: cubit,
        child: const LostFoundView(),
      );
    case 'market':
      final cubit = _Market();
      when(() => cubit.state).thenReturn(
        MarketplaceState(
          status: status == 'empty'
              ? .ready
              : MarketplaceStatus.values.byName(status),
        ),
      );
      return BlocProvider<MarketplaceCubit>.value(
        value: cubit,
        child: const MarketplaceView(),
      );
    case 'wallet':
      final cubit = _Wallet();
      when(() => cubit.state).thenReturn(
        WalletState(
          status: status == 'empty'
              ? .populated
              : WalletStatus.values.byName(status),
          tab: WalletTab.history,
        ),
      );
      return BlocProvider<WalletCubit>.value(
        value: cubit,
        child: const WalletView(),
      );
    default:
      throw ArgumentError.value(screen);
  }
}

CategoriesBloc _categories() {
  final categories = _Categories();
  when(() => categories.state).thenReturn(
    const CategoriesState(
      status: .populated,
      selectedCategory: Category(id: 'all', name: 'Все'),
      categories: [
        Category(id: 'all', name: 'Все'),
        Category(id: 'science', name: 'Наука'),
      ],
    ),
  );
  return categories;
}

Widget _article(ArticleStatus status) {
  final article = _Article();
  final saved = _Saved();
  when(() => article.id).thenReturn('article');
  when(() => article.state).thenReturn(ArticleState(status: status));
  when(() => saved.state).thenReturn([]);
  when(() => saved.isSaved(any())).thenReturn(false);
  return MultiBlocProvider(
    providers: [
      BlocProvider<ArticleBloc>.value(value: article),
      BlocProvider<SavedArticlesCubit>.value(value: saved),
    ],
    child: const ArticleView(isVideoArticle: false),
  );
}

Widget _story(FeedStatus status, {bool empty = false}) {
  final feed = _Feed();
  when(() => feed.state).thenReturn(
    FeedState(
      status: status,
      feed: {
        'science': [
          if (status == .populated && !empty)
            PostMediumBlock(
              id: 'grant',
              categoryId: 'science',
              author: 'Наука',
              title: 'Конкурс студенческих грантов: до 300 тыс. на проект',
              description:
                  'Заявки от команд 2–5 человек с научным руководителем.',
              publishedAt: DateTime(2026, 8, 31),
              imageUrl: '',
            ),
        ],
      },
    ),
  );
  return MultiBlocProvider(
    providers: [
      BlocProvider<FeedBloc>.value(value: feed),
      BlocProvider<CategoriesBloc>.value(value: _categories()),
    ],
    child: const StoryViewerPage(sourceId: 'science'),
  );
}

Widget _sheet(String form, {bool pending = false}) {
  final notes = _Notes();
  final lost = _Lost();
  final market = _Market();
  when(() => notes.state).thenReturn(CollabNotesState(isCreating: pending));
  when(() => lost.state).thenReturn(LostFoundState(isCreating: pending));
  when(() => market.state).thenReturn(MarketplaceState(isSaving: pending));
  final contactPrefs = _ContactPrefs();
  when(() => contactPrefs.state).thenReturn('');
  final (title, child) = switch (form) {
    'poll' => ('Создать опрос', PollCreatorSheet(cubit: _Polls())),
    'event' => (
      'Новое событие',
      CreateEventSheet(
        onSubmit: (_) async => true,
        initialStartsAt: DateTime(2026, 9, 3, 18),
      ),
    ),
    'note' => (
      'Создать конспект',
      BlocProvider<CollabNotesCubit>.value(
        value: notes,
        child: const CreateCollabNoteSheet(),
      ),
    ),
    'material' => (
      'Загрузить материал',
      MaterialUploadSheet(repository: _Campus()),
    ),
    'lost' => (
      'Потерял / нашёл',
      BlocProvider<LostFoundCubit>.value(
        value: lost,
        child: const LostFoundReportSheet(),
      ),
    ),
    'market' => (
      'Продать вещь',
      MultiBlocProvider(
        providers: [
          BlocProvider<MarketplaceCubit>.value(value: market),
          BlocProvider<MarketContactPrefsCubit>.value(value: contactPrefs),
        ],
        child: const MarketSellSheet(),
      ),
    ),
    _ => throw ArgumentError.value(form),
  };
  return _SheetLauncher(title: title, kind: form, child: child);
}

Widget _lostDetails(String state) {
  final cubit = _Lost();
  when(() => cubit.state).thenReturn(
    LostFoundState(
      pendingStatusIds: state == 'pending' ? {'keys'} : {},
    ),
  );
  return _SheetLauncher(
    child: BlocProvider<LostFoundCubit>.value(
      value: cubit,
      child: LostFoundItemSheet(
        item: LostFoundItem(
          id: 'keys',
          authorId: 'student',
          itemName: 'Ключи с синим брелоком',
          status: .found,
          createdAt: DateTime(2026, 9),
          category: 'keys',
          location: 'Холл корпуса В-78',
          description: 'Найдены у гардероба.',
          isMine: state != 'private',
        ),
      ),
    ),
  );
}

Widget _editor(NoteEditorStatus status) {
  final cubit = _Editor();
  final controller = QuillController.basic();
  controller.document.insert(
    0,
    'Производная описывает скорость изменения функции.\n\n'
    'Правила дифференцирования суммы и произведения.\n\n'
    'Вопросы к следующему семинару.',
  );
  when(() => cubit.controller).thenReturn(controller);
  when(() => cubit.state).thenReturn(
    NoteEditorState(
      title: 'Лекция 4. Производные и дифференциалы',
      status: status,
      canDelete: true,
    ),
  );
  return RepositoryProvider<CampusRepository>.value(
    value: _Campus(),
    child: BlocProvider<NoteEditorCubit>.value(
      value: cubit,
      child: const Scaffold(body: SafeArea(child: CollabNoteEditorView())),
    ),
  );
}

class _SheetLauncher extends StatefulWidget {
  const _SheetLauncher({required this.child, this.title, this.kind});
  final Widget child;
  final String? title;
  final String? kind;

  @override
  State<_SheetLauncher> createState() => _SheetLauncherState();
}

class _SheetLauncherState extends State<_SheetLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final l10n = context.l10n;
      final (title, subtitle) = switch (widget.kind) {
        'poll' => (l10n.pollsCreateTitle, null),
        'event' => (
          l10n.eventsCreateSheetTitle,
          l10n.eventsCreateSheetSubtitle,
        ),
        'note' => (l10n.collabNotesCreateTitle, l10n.collabNotesCreateSubtitle),
        'material' => (l10n.knowledgeUploadTitle, l10n.knowledgeUploadSubtitle),
        'lost' => (l10n.lostFoundReportTitle, l10n.lostFoundReportSub),
        'market' => (l10n.marketSellTitle, l10n.marketSellSubtitle),
        'marketDetail' => (l10n.marketDetailsTitle, widget.title),
        _ => (widget.title, null),
      };
      unawaited(
        showAppSheet<void>(
          context,
          title: title,
          subtitle: subtitle,
          useRootNavigator: false,
          child: widget.child,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

Future<void> _capture(
  WidgetTester tester,
  String name,
  bool dark,
  List<Widget> panels, {
  Size panelSize = const Size(390, 844),
  double textScale = 1,
  bool golden = true,
}) async {
  tester.view
    ..physicalSize = Size(panelSize.width * panels.length, panelSize.height)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Row(
        children: [
          for (final panel in panels)
            Expanded(
              child: MediaQuery(
                data: MediaQueryData(
                  size: panelSize,
                  textScaler: TextScaler.linear(textScale),
                  disableAnimations: true,
                ),
                child: Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute<void>(
                    builder: (_) => panel,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
  expect(tester.takeException(), isNull);
  if (golden) {
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/${name}_${dark ? 'dark' : 'light'}.png'),
    );
  }
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}
