import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/free_rooms.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MockFreeRoomsCubit extends MockCubit<FreeRoomsState>
    implements FreeRoomsCubit {}

class MockRoomBookingCubit extends MockCubit<RoomBookingState>
    implements RoomBookingCubit {}

void main() {
  group('FreeRoomsView', () {
    late FreeRoomsCubit cubit;
    late RoomBookingCubit saved;

    setUp(() {
      cubit = MockFreeRoomsCubit();
      saved = MockRoomBookingCubit();
      when(() => saved.state).thenReturn(const RoomBookingState());
      addTearDown(cubit.close);
      addTearDown(saved.close);
    });

    Widget buildSubject({double textScale = 1, bool reduceMotion = false}) {
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
        home: MultiBlocProvider(
          providers: [
            BlocProvider<FreeRoomsCubit>.value(value: cubit),
            BlocProvider<RoomBookingCubit>.value(value: saved),
          ],
          child: const FreeRoomsView(),
        ),
      );
    }

    testWidgets(
      'shows a Ninja skeleton mirroring the list and no spinner on cold load',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const FreeRoomsState(status: FreeRoomsStatus.loading),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(NinjaSkeleton), findsWidgets);
        expect(
          find.byKey(const ValueKey('free-rooms-loading')),
          findsOneWidget,
        );
        expect(find.bySemanticsLabel('Загрузка'), findsWidgets);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && (widget.properties.liveRegion ?? false),
          ),
          findsOneWidget,
        );
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(NinjaChip), findsNothing);
      },
    );

    testWidgets('renders the free room group and campus filters', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const FreeRoomsState(
          status: FreeRoomsStatus.populated,
          rooms: [FreeRoom(room: 'А-101', campus: 'mp1')],
        ),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.byType(AppListGroup), findsOneWidget);
      expect(find.text('Свободно сейчас'), findsOneWidget);
      expect(find.byType(AppChip), findsWidgets);
    });

    testWidgets(
      'keeps cached rows on refresh reloads (status loading, rooms present)',
      (tester) async {
        when(() => cubit.state).thenReturn(
          const FreeRoomsState(
            status: FreeRoomsStatus.loading,
            rooms: [FreeRoom(room: 'А-101', campus: 'mp1')],
          ),
        );

        await tester.pumpWidget(buildSubject());

        expect(find.byType(FreeRoomRow), findsWidgets);
      },
    );

    testWidgets(
      'shows a retryable error instead of "no free rooms" on failure',
      (tester) async {
        when(
          () => cubit.state,
        ).thenReturn(const FreeRoomsState(status: FreeRoomsStatus.failure));
        when(() => cubit.load()).thenAnswer((_) async {});

        await tester.pumpWidget(buildSubject());

        expect(find.byType(NinjaErrorState), findsOneWidget);
        expect(
          find.byKey(const ValueKey('free-rooms-failure')),
          findsOneWidget,
        );
        expect(find.text('Ошибка загрузки'), findsOneWidget);
        expect(find.text('Свободных нет'), findsNothing);
        expect(find.byType(FreeRoomRow), findsNothing);
        await tester.tap(find.text('Повторить'));
        verify(() => cubit.load()).called(1);
      },
    );

    testWidgets('offers a refresh pill on the empty state', (tester) async {
      when(() => cubit.state).thenReturn(
        const FreeRoomsState(status: FreeRoomsStatus.populated),
      );
      when(() => cubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(NinjaEmptyState), findsOneWidget);
      expect(find.byKey(const ValueKey('free-rooms-empty')), findsOneWidget);
      expect(find.text('Свободных нет'), findsOneWidget);

      await tester.tap(find.text('Обновить'));
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
        const FreeRoomsState(
          status: FreeRoomsStatus.populated,
          rooms: [
            FreeRoom(
              room: 'А - аудитория с очень длинным названием',
              campus: 'Проспект Вернадского',
            ),
          ],
        ),
      );

      await tester.pumpWidget(
        buildSubject(textScale: 2, reduceMotion: true),
      );
      await tester.pump();

      expect(find.textContaining('очень длинным'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
