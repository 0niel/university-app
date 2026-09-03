import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';
import 'package:rtu_mirea_app/knowledge_bank/view/knowledge_bank_list.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

class MockKnowledgeBankCubit extends MockCubit<KnowledgeBankState>
    implements KnowledgeBankCubit {}

class _ViewPreferences extends InMemorySharedPreferencesStore {
  _ViewPreferences({this.failReads = false, this.failWrites = false})
    : super.empty();

  bool failReads;
  bool failWrites;
  int reads = 0;
  final writes = <(String, Object)>[];

  @override
  Future<Map<String, Object>> getAll() async {
    reads++;
    if (failReads) throw Exception('Preferences read unavailable');
    return super.getAll();
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    writes.add((key, value));
    if (failWrites) throw Exception('Preferences write unavailable');
    return super.setValue(valueType, key, value);
  }
}

Widget _wrap(
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
}) {
  return MaterialApp(
    theme: NinjaTheme.dark(),
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: reduceMotion,
        accessibleNavigation: reduceMotion,
      ),
      child: child!,
    ),
    home: child,
  );
}

void main() {
  group('KnowledgeBankView preference failures', () {
    late KnowledgeBankCubit cubit;
    late SharedPreferencesStorePlatform previousStore;

    setUp(() {
      previousStore = SharedPreferencesStorePlatform.instance;
      SharedPreferences.resetStatic();
      cubit = MockKnowledgeBankCubit();
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [
            StudyMaterial(id: 'note-1', title: 'Материал настроек вида'),
          ],
        ),
      );
    });

    tearDown(() async {
      SharedPreferences.resetStatic();
      SharedPreferencesStorePlatform.instance = previousStore;
      await cubit.close();
    });

    Future<void> showView(WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();
    }

    Future<void> selectView(WidgetTester tester, String tooltip) async {
      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is AppIconButton && widget.tooltip == tooltip,
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    bool gridView(WidgetTester tester) => tester
        .widget<KnowledgeBankList>(find.byType(KnowledgeBankList))
        .gridView;

    testWidgets('load exceptions keep materials and both view modes usable', (
      tester,
    ) async {
      final preferences = _ViewPreferences(failReads: true);
      SharedPreferencesStorePlatform.instance = preferences;
      await showView(tester);

      expect(preferences.reads, 1);
      expect(gridView(tester), isFalse);
      expect(find.text('Материал настроек вида'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await selectView(tester, 'Сетка');
      expect(gridView(tester), isTrue);
      expect(preferences.reads, 2);
      expect(find.text('Материал настроек вида'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await selectView(tester, 'Список');
      expect(gridView(tester), isFalse);
      expect(preferences.reads, 3);
      expect(preferences.writes, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('save exceptions preserve selection and allow a later retry', (
      tester,
    ) async {
      final preferences = _ViewPreferences(failWrites: true);
      SharedPreferencesStorePlatform.instance = preferences;
      await showView(tester);

      await selectView(tester, 'Сетка');
      expect(gridView(tester), isTrue);
      expect(preferences.writes, [('flutter.knowledge_bank_grid_view', true)]);
      expect(find.text('Материал настроек вида'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await selectView(tester, 'Список');
      expect(gridView(tester), isFalse);
      expect(preferences.writes.last, (
        'flutter.knowledge_bank_grid_view',
        false,
      ));
      expect(tester.takeException(), isNull);

      preferences.failWrites = false;
      await selectView(tester, 'Сетка');
      expect(gridView(tester), isTrue);
      expect(preferences.writes, hasLength(3));
      expect(
        await preferences.getAll(),
        containsPair('flutter.knowledge_bank_grid_view', true),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('KnowledgeBankView failure state', () {
    late KnowledgeBankCubit cubit;

    setUp(() {
      cubit = MockKnowledgeBankCubit();
    });

    testWidgets(
      'cold load does not expose fake zero totals',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const KnowledgeBankState(status: KnowledgeBankStatus.loading),
        );

        await tester.pumpWidget(
          _wrap(
            BlocProvider<KnowledgeBankCubit>.value(
              value: cubit,
              child: const KnowledgeBankView(),
            ),
          ),
        );
        await tester.pump();

        expect(find.bySemanticsLabel('Загрузка'), findsWidgets);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && (widget.properties.liveRegion ?? false),
          ),
          findsOneWidget,
        );
        expect(tester.binding.transientCallbackCount, 1);
        expect(find.text('0'), findsNothing);
      },
    );

    testWidgets(
      'shows a retryable error instead of the 📚 empty state',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const KnowledgeBankState(status: KnowledgeBankStatus.failure),
        );
        when(() => cubit.load()).thenAnswer((_) async {});

        await tester.pumpWidget(
          _wrap(
            BlocProvider<KnowledgeBankCubit>.value(
              value: cubit,
              child: const KnowledgeBankView(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Ошибка загрузки'), findsOneWidget);
        expect(find.text('Пока пусто'), findsNothing);
        expect(find.text('0'), findsNothing);
        await tester.tap(find.text('Повторить'));
        verify(() => cubit.load()).called(1);
      },
    );

    testWidgets('the empty state offers a real upload action', (tester) async {
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(status: KnowledgeBankStatus.populated),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaEmptyState), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NinjaEmptyState),
          matching: find.text('Залить'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('an empty filter offers a reset instead of "nothing here"', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          type: 'exam',
          materials: [
            StudyMaterial(id: 'note-1', title: 'Конспект'),
          ],
        ),
      );
      when(() => cubit.typeChanged(any())).thenReturn(null);

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Пока пусто'), findsNothing);
      expect(find.text('Ничего не нашлось'), findsOneWidget);
      await tester.tap(find.text('Сбросить фильтр'));
      verify(() => cubit.typeChanged('all')).called(1);
    });

    testWidgets('the header matches the design and pull refresh stays wired', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(status: KnowledgeBankStatus.populated),
      );
      when(() => cubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      final button = find.bySemanticsLabel('Назад');
      expect(button, findsOneWidget);
      expect(
        tester.getSize(button),
        const Size(44, 44),
      );

      final title = tester.widget<Text>(find.text('Банк знаний'));
      expect(title.style?.fontSize, 28);
      expect(find.bySemanticsLabel('Обновить данные'), findsNothing);
      await tester
          .widget<RefreshIndicator>(find.byType(RefreshIndicator))
          .onRefresh();
      verify(() => cubit.load()).called(1);
    });

    testWidgets('fits 320px at 200 percent with reduced motion', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [
            StudyMaterial(
              id: 'adaptive',
              title: 'Длинный конспект по архитектуре информационных систем',
              subjectName: 'Проектирование',
              authorName: 'Автор',
              pages: 128,
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          textScale: 2,
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.textContaining('Длинный конспект'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping the row opens the shared media viewer', (
      tester,
    ) async {
      const material = StudyMaterial(
        id: 'material-viewer',
        title: 'Материал для просмотра',
        fileName: 'notes.pdf',
        mimeType: 'application/pdf',
        hasFile: true,
      );
      final uri = Uri.parse('https://project.supabase.co/signed/notes.pdf');
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [material],
        ),
      );
      when(() => cubit.materialUrl(material)).thenAnswer((_) async => uri);
      when(() => cubit.materialAccess(material)).thenAnswer(
        (_) async => const MaterialAccess(canDownload: true, price: 0),
      );
      when(() => cubit.materialOpened(material)).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(MaterialRow));
      await tester.pump();
      await tester.pump();

      expect(find.byType(MediaViewerPage), findsOneWidget);
      verify(() => cubit.materialOpened(material)).called(1);
    });

    testWidgets('opens the signed material before incrementing downloads', (
      tester,
    ) async {
      const material = StudyMaterial(
        id: 'material-1',
        title: 'Открываемый конспект',
        fileName: 'notes.pdf',
        hasFile: true,
      );
      final uri = Uri.parse('https://project.supabase.co/signed/notes.pdf');
      Uri? openedUri;
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [material],
        ),
      );
      when(() => cubit.materialUrl(material)).thenAnswer((_) async => uri);
      when(() => cubit.materialAccess(material)).thenAnswer(
        (_) async => const MaterialAccess(canDownload: true, price: 0),
      );
      when(() => cubit.materialOpened(material)).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: KnowledgeBankView(
              onOpenMaterial: (uri) async {
                openedUri = uri;
                return true;
              },
            ),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Скачать'));
      await tester.pump();

      expect(openedUri, uri);
      verifyInOrder([
        () => cubit.materialAccess(material),
        () => cubit.materialUrl(material),
        () => cubit.materialOpened(material),
      ]);
    });

    testWidgets('shows fileless materials as a disabled separate state', (
      tester,
    ) async {
      const material = StudyMaterial(
        id: 'fileless',
        title: 'Описание без файла',
      );
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [material],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Без вложения'), findsOneWidget);
      await tester.tap(find.text('Описание без файла'));
      verifyNever(() => cubit.materialUrl(material));
      verifyNever(() => cubit.materialOpened(material));
    });

    for (final confirm in [false, true]) {
      testWidgets('paid download requires explicit confirmation: $confirm', (
        tester,
      ) async {
        const material = StudyMaterial(
          id: 'paid',
          title: 'Платный конспект',
          hasFile: true,
          price: 40,
        );
        final purchase = Completer<void>();
        final access = Completer<MaterialAccess>();
        var opened = 0;
        when(() => cubit.state).thenReturn(
          const KnowledgeBankState(
            status: KnowledgeBankStatus.populated,
            materials: [material],
          ),
        );
        when(
          () => cubit.materialAccess(material),
        ).thenAnswer((_) => access.future);
        when(
          () => cubit.purchaseMaterial(material, expectedPrice: 40),
        ).thenAnswer((_) => purchase.future);
        when(() => cubit.materialUrl(material)).thenAnswer(
          (_) async => Uri.parse('https://project.supabase.co/signed/paid.pdf'),
        );
        when(() => cubit.materialOpened(material)).thenAnswer((_) async {});
        await tester.pumpWidget(
          _wrap(
            BlocProvider<KnowledgeBankCubit>.value(
              value: cubit,
              child: KnowledgeBankView(
                onOpenMaterial: (_) async {
                  opened++;
                  return true;
                },
              ),
            ),
            reduceMotion: true,
          ),
        );
        await tester.tap(find.bySemanticsLabel('Скачать'));
        await tester.tap(find.bySemanticsLabel('Скачать'));
        access.complete(const MaterialAccess(canDownload: false, price: 40));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Открыть материал?'), findsOneWidget);
        expect(find.textContaining('40 сюрикенов'), findsWidgets);
        verifyNever(() => cubit.purchaseMaterial(material, expectedPrice: 40));
        final button = find.byWidgetPredicate(
          (widget) =>
              widget is AppButton &&
              widget.label == (confirm ? 'Купить и открыть' : 'Отмена'),
        );
        await tester.tap(button);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        if (confirm) {
          expect(opened, 0);
          verify(
            () => cubit.purchaseMaterial(material, expectedPrice: 40),
          ).called(1);
          purchase.complete();
          await tester.pump();
          expect(opened, 1);
          verify(() => cubit.materialOpened(material)).called(1);
        } else {
          verifyNever(
            () => cubit.purchaseMaterial(material, expectedPrice: 40),
          );
          verifyNever(() => cubit.materialUrl(material));
          expect(opened, 0);
        }
        verify(() => cubit.materialAccess(material)).called(1);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('an already purchased material opens without buying again', (
      tester,
    ) async {
      const material = StudyMaterial(
        id: 'owned-access',
        title: 'Купленный',
        hasFile: true,
        price: 40,
      );
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [material],
        ),
      );
      when(() => cubit.materialAccess(material)).thenAnswer(
        (_) async => const MaterialAccess(canDownload: true, price: 40),
      );
      when(() => cubit.materialUrl(material)).thenAnswer(
        (_) async => Uri.parse('https://project.supabase.co/signed/paid.pdf'),
      );
      when(() => cubit.materialOpened(material)).thenAnswer((_) async {});
      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: KnowledgeBankView(onOpenMaterial: (_) async => true),
          ),
          reduceMotion: true,
        ),
      );
      await tester.tap(find.bySemanticsLabel('Скачать'));
      await tester.pump();
      expect(find.text('Открыть материал?'), findsNothing);
      verifyNever(() => cubit.purchaseMaterial(material, expectedPrice: 40));
      verify(() => cubit.materialOpened(material)).called(1);
    });

    testWidgets('marks protected legacy anonymous files for republishing', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const KnowledgeBankState(
          status: KnowledgeBankStatus.populated,
          materials: [
            StudyMaterial(
              id: 'legacy-anonymous',
              title: 'Старый анонимный файл',
              requiresRepublish: true,
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<KnowledgeBankCubit>.value(
            value: cubit,
            child: const KnowledgeBankView(),
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.text('Нужно загрузить заново'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          RegExp('Нужно загрузить заново'),
        ),
        findsWidgets,
      );
    });
  });
}
