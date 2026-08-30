@Tags(['gallery'])
library;

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/view/lost_found_view.dart';

class _MockCubit extends MockCubit<LostFoundState> implements LostFoundCubit {}

void main() {
  late LostFoundCubit cubit;

  LostFoundItem item(String name, String location, String category, int day) =>
      LostFoundItem(
        id: name,
        authorId: 'u1',
        itemName: name,
        status: LostFoundItemStatus.found,
        createdAt: DateTime.utc(2026, 8, day),
        category: category,
        location: location,
      );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('Inter');
    for (final weight in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
    ]) {
      loader.addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Inter/Inter-$weight.ttf',
        ),
      );
    }
    await loader.load();
  });

  setUp(() => cubit = _MockCubit());

  for (final brightness in Brightness.values) {
    testWidgets('modern lost & found · ${brightness.name}', (tester) async {
      final state = LostFoundState(
        items: [
          item('Наушники, чёрные', 'ауд. 314 Б', 'electronics', 13),
          item('Студенческий билет', 'столовая Б', 'documents', 13),
          item('Термокружка', 'библиотека', 'other', 12),
          item('Зонт, синий', 'корп. А, гардероб', 'clothes', 11),
        ],
      );
      when(() => cubit.state).thenReturn(state);

      tester.view
        ..physicalSize = const Size(390, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: brightness == Brightness.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<LostFoundCubit>.value(
            value: cubit,
            child: const LostFoundView(),
          ),
        ),
      );
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/lost_found_modern_${brightness.name}.png',
        ),
      );
    });
  }
}
