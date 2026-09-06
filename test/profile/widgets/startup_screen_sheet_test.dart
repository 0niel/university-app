import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/startup_screen_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';

import '../../helpers/pump_app.dart';

class _Storage extends Mock implements Storage {}

void main() {
  testWidgets('choosing a startup screen saves and closes only its sheet', (
    tester,
  ) async {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    final cubit = StartupScreenCubit(userId: 'a');
    addTearDown(cubit.close);
    await tester.pumpApp(
      BlocProvider.value(
        value: cubit,
        child: Scaffold(
          body: Navigator(
            onGenerateInitialRoutes: (_, _) => [
              MaterialPageRoute<void>(
                builder: (_) => const Text('Profile'),
              ),
              MaterialPageRoute<void>(
                builder: (context) => Scaffold(
                  body: TextButton(
                    onPressed: () => showStartupScreenSheet(context),
                    child: const Text('Settings'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(AppRadio<StartupScreen>), findsNWidgets(5));
    await tester.tap(find.text('Расписание'));
    await tester.pumpAndSettle();
    expect(cubit.state, StartupScreen.schedule);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byType(AppRadio<StartupScreen>), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    final radios = tester.widgetList<AppRadio<StartupScreen>>(
      find.byType(AppRadio<StartupScreen>),
    );
    expect(
      radios.every((radio) => radio.groupValue == StartupScreen.schedule),
      isTrue,
    );
  });
}
