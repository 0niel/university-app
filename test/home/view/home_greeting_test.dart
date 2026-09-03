import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_greeting.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('resolved name renders in the accent serif span', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: HomeGreeting(
          greeting: 'Добрый день, ',
          name: 'Олег',
          subtitle: 'Сегодня 3 пары',
        ),
      ),
    );
    expect(find.byKey(const Key('homeGreeting_nameSkeleton')), findsNothing);
    expect(find.textContaining('Олег'), findsOneWidget);
    expect(find.text('Сегодня 3 пары'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading state shows a skeleton instead of a fallback name', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: HomeGreeting(
          greeting: 'Добрый день, ',
          name: 'Студент',
          nameLoading: true,
          subtitle: 'Сегодня 3 пары',
        ),
      ),
    );
    expect(find.byKey(const Key('homeGreeting_nameSkeleton')), findsOneWidget);
    expect(find.textContaining('Студент'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
