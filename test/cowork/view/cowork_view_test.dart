import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';
import 'package:rtu_mirea_app/cowork/view/cowork_view.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_book_button.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_details_card.dart';
import 'package:rtu_mirea_app/cowork/widgets/cowork_seat_map.dart';

import '../../helpers/pump_app.dart';

class _Cubit extends MockCubit<CoworkState> implements CoworkCubit {}

void main() {
  late _Cubit cubit;
  setUp(() => cubit = _Cubit());
  tearDown(() => cubit.close());

  Future<void> pump(
    WidgetTester tester,
    CoworkState state, {
    double scale = 1,
  }) async {
    when(() => cubit.state).thenReturn(state);
    await tester.pumpApp(
      BlocProvider<CoworkCubit>.value(value: cubit, child: const CoworkView()),
      size: const Size(320, 900),
      textScaler: TextScaler.linear(scale),
    );
    await tester.pump();
  }

  testWidgets('ready state discloses local planning and unknown availability', (
    tester,
  ) async {
    await pump(
      tester,
      CoworkState(status: CoworkStatus.ready, now: DateTime(2026, 9, 2, 12)),
    );
    expect(find.textContaining('Личный план, не бронь'), findsOneWidget);
    expect(find.text('не проверено'), findsOneWidget);
    expect(find.textContaining('свободно'), findsNothing);
    expect(find.byType(CoworkSeatCell), findsNWidgets(24));
    await tester.tap(find.byType(CoworkSeatCell).first);
    verify(() => cubit.seatTapped('Т1')).called(1);
  });

  testWidgets('failure provides retry without fake seats', (tester) async {
    when(() => cubit.load()).thenAnswer((_) async {});
    await pump(tester, const CoworkState(status: CoworkStatus.failure));
    expect(find.byType(NinjaErrorState), findsOneWidget);
    expect(find.byType(CoworkSeatCell), findsNothing);
    await tester.tap(find.text('Повторить'));
    verify(() => cubit.load()).called(1);
  });

  testWidgets('initial state shows the shared skeleton', (tester) async {
    await pump(tester, const CoworkState());
    expect(find.byKey(const ValueKey('cowork-skeleton')), findsOneWidget);
    expect(find.byType(CoworkSeatCell), findsNothing);
  });

  testWidgets('save failure remains visible and keeps retry selection', (
    tester,
  ) async {
    await pump(
      tester,
      CoworkState(
        status: CoworkStatus.ready,
        selectedSeatId: 'Т1',
        saveFailed: true,
        now: DateTime(2026, 9, 2, 12),
      ),
    );
    expect(
      find.text('Не удалось сохранить. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    expect(find.text('Сохранить Т1 · до 14:00'), findsOneWidget);
  });

  testWidgets('small screen supports 200 percent text and scrolling', (
    tester,
  ) async {
    await pump(
      tester,
      CoworkState(status: CoworkStatus.ready, now: DateTime(2026, 9, 2, 12)),
      scale: 2,
    );
    expect(tester.takeException(), isNull);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -800),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('closed state keeps the 52px action without offering a save', (
    tester,
  ) async {
    await pump(
      tester,
      CoworkState(status: CoworkStatus.ready, now: DateTime(2026, 9, 2, 23)),
    );
    final action = find.descendant(
      of: find.byType(CoworkBookButton),
      matching: find.byType(AppButton),
    );
    expect(tester.getSize(action).height, 52);
    expect(tester.widget<AppButton>(action).onPressed, isNull);
  });

  testWidgets('saving has visible progress and prevents repeating the action', (
    tester,
  ) async {
    await pump(
      tester,
      CoworkState(
        status: CoworkStatus.ready,
        selectedSeatId: 'Т1',
        saving: true,
        now: DateTime(2026, 9, 2, 12),
      ),
    );
    final action = tester.widget<AppButton>(
      find.descendant(
        of: find.byType(CoworkBookButton),
        matching: find.byType(AppButton),
      ),
    );
    expect(action.loading, isTrue);
    expect(action.onPressed, isNull);
  });

  testWidgets(
    'saved plan extension text is centered inside a target of at least44px',
    (tester) async {
      when(() => cubit.extend()).thenAnswer((_) async {});
      await pump(
        tester,
        CoworkState(
          status: CoworkStatus.ready,
          now: DateTime(2026, 9, 2, 12),
          booking: CoworkBooking(
            seatId: 'Т1',
            zone: CoworkZone.quiet,
            from: DateTime(2026, 9, 2, 11),
            until: DateTime(2026, 9, 2, 13),
          ),
        ),
      );
      final target = find.descendant(
        of: find.byType(CoworkDetailsCard),
        matching: find.byType(AppPressable),
      );
      final label = find.descendant(of: target, matching: find.byType(Text));
      final bounds = tester.getRect(target);
      expect(bounds.height, greaterThanOrEqualTo(44));
      expect(tester.getRect(label).center.dy, closeTo(bounds.center.dy, .01));
      await tester.tapAt(Offset(bounds.center.dx, bounds.top + 1));
      verify(() => cubit.extend()).called(1);
    },
  );
}
