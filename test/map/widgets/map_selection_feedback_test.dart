import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/widgets/map_selection_feedback.dart';

class _MapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

void main() {
  for (final locale in ['ru', 'en']) {
    testWidgets(
      'recoverable error is localized once and preserves input $locale',
      (
        tester,
      ) async {
        final states = await _pump(tester, locale: locale);
        final controller = tester
            .widget<TextField>(find.byType(TextField))
            .controller!;
        final element = tester.element(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'Draft');
        states.add(const MapState(status: MapStatus.loading));
        await tester.pump();
        const recovered = MapState(
          status: MapStatus.loaded,
          errorMessage: 'Internal floor reference failed',
        );
        states.add(recovered);
        await tester.pump();
        final host = tester.state<NinjaToastHostState>(
          find.byType(NinjaToastHost),
        );
        final message = tester
            .element(find.byType(MapSelectionFeedback))
            .l10n
            .mapPlanLoadFailed;
        expect(host.current?.message, message);
        expect(host.current?.showCheck, isFalse);
        expect(find.text(recovered.errorMessage!), findsNothing);
        expect(tester.element(find.byType(TextField)), same(element));
        expect(controller.text, 'Draft');
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .focusNode
              .hasFocus,
          isTrue,
        );
        states.add(recovered.copyWith(roomFloors: {'room': 2}));
        await tester.pump();
        await tester.pump(const Duration(seconds: 3));
        await tester.pump(const Duration(milliseconds: 300));
        expect(host.current, isNull);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final active in [false, true]) {
    testWidgets(
      'initial failures and inactive recoveries stay silent active=$active',
      (
        tester,
      ) async {
        final states = await _pump(tester, active: active);
        states.add(
          const MapState(status: MapStatus.failure, errorMessage: 'Failure'),
        );
        await tester.pump();
        final host = tester.state<NinjaToastHostState>(
          find.byType(NinjaToastHost),
        );
        expect(host.current, isNull);
        if (!active) {
          states.add(
            const MapState(status: MapStatus.loaded, errorMessage: 'Recovered'),
          );
          await tester.pump();
          expect(host.current, isNull);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<StreamController<MapState>> _pump(
  WidgetTester tester, {
  String locale = 'ru',
  bool active = true,
}) async {
  final states = StreamController<MapState>();
  final bloc = _MapBloc();
  final controller = TextEditingController();
  addTearDown(states.close);
  addTearDown(controller.dispose);
  whenListen(
    bloc,
    states.stream,
    initialState: const MapState(status: MapStatus.loaded),
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NinjaToastHost(
        child: BlocProvider<MapBloc>.value(
          value: bloc,
          child: TickerMode(
            enabled: active,
            child: Scaffold(
              body: MapSelectionFeedback(
                child: TextField(controller: controller),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return states;
}
