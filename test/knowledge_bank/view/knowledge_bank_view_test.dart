import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/knowledge_bank/knowledge_bank.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MockKnowledgeBankCubit extends MockCubit<KnowledgeBankState>
    implements KnowledgeBankCubit {}

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

    testWidgets('the page header keeps a 44px circular refresh action', (
      tester,
    ) async {
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

      final button = find.byKey(const ValueKey('knowledge-refresh-button'));
      expect(button, findsOneWidget);
      expect(
        tester.getSize(button),
        const Size(NinjaMetrics.minTouchTarget, NinjaMetrics.minTouchTarget),
      );

      final title = tester.widget<Text>(find.text('Банк знаний'));
      expect(title.style?.fontSize, NinjaText.display.fontSize);
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
      await tester.tap(find.text('Открываемый конспект'));
      await tester.pump();

      expect(openedUri, uri);
      verifyInOrder([
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
