import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wear/nfc_pass/nfc_pass.dart';
import 'package:wearable_rotary/wearable_rotary.dart';

import '../../helpers/helpers.dart';

class _MockCounterCubit extends MockCubit<int> implements CounterCubit {}

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const CounterPage());
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = _MockCounterCubit();
    });

    testWidgets('renders current count', (tester) async {
      const state = 42;
      when(() => counterCubit.state).thenReturn(state);
      await tester.pumpApp(
        BlocProvider.value(
          value: counterCubit,
          child: CounterView(),
        ),
      );
      expect(find.text('$state'), findsOneWidget);
    });

    group('button taps', () {
      testWidgets('calls increment when increment button is tapped', (tester) async {
        when(() => counterCubit.state).thenReturn(0);
        when(() => counterCubit.increment()).thenReturn(null);
        await tester.pumpApp(
          BlocProvider.value(
            value: counterCubit,
            child: CounterView(),
          ),
        );
        await tester.tap(find.byIcon(Icons.add));
        verify(() => counterCubit.increment()).called(1);
      });

      testWidgets('calls decrement when decrement button is tapped', (tester) async {
        when(() => counterCubit.state).thenReturn(0);
        when(() => counterCubit.decrement()).thenReturn(null);
        await tester.pumpApp(
          BlocProvider.value(
            value: counterCubit,
            child: CounterView(),
          ),
        );
        await tester.tap(find.byIcon(Icons.remove));
        verify(() => counterCubit.decrement()).called(1);
      });
    });

    group('rotary events', () {
      late StreamController<RotaryEvent> controller;

      setUp(() {
        controller = StreamController<RotaryEvent>();
      });

      tearDown(() {
        controller.close();
      });

      testWidgets('calls increment when increment button is tapped', (tester) async {
        when(() => counterCubit.state).thenReturn(0);
        when(() => counterCubit.increment()).thenReturn(null);
        await tester.pumpApp(
          BlocProvider.value(
            value: counterCubit,
            child: CounterView(
              rotaryEvents: controller.stream,
            ),
          ),
        );
        controller.add(const RotaryEvent(direction: RotaryDirection.clockwise));
        await tester.pump();
        verify(() => counterCubit.increment()).called(1);
      });

      testWidgets('calls decrement when decrement button is tapped', (tester) async {
        when(() => counterCubit.state).thenReturn(0);
        when(() => counterCubit.decrement()).thenReturn(null);
        await tester.pumpApp(
          BlocProvider.value(
            value: counterCubit,
            child: CounterView(
              rotaryEvents: controller.stream,
            ),
          ),
        );
        controller.add(
          const RotaryEvent(direction: RotaryDirection.counterClockwise),
        );
        await tester.pump();
        verify(() => counterCubit.decrement()).called(1);
      });
    });
  });
}
