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
  });
}
