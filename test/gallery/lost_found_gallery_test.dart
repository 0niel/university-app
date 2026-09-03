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

  LostFoundItem item(
    String name,
    String location,
    String author,
    Duration age, {
    LostFoundItemStatus status = LostFoundItemStatus.found,
  }) => LostFoundItem(
    id: name,
    authorId: 'u1',
    itemName: name,
    status: status,
    createdAt: DateTime.now().subtract(age),
    authorName: author,
    location: location,
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('packages/app_ui/Onest');
    for (final weight in const [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]) {
      loader.addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Onest/Onest-$weight.ttf',
        ),
      );
    }
    await loader.load();
    final serif = FontLoader('packages/app_ui/Literata')
      ..addFont(
        rootBundle.load(
          'packages/app_ui/assets/fonts/Literata/Literata-Variable.ttf',
        ),
      );
    await serif.load();
  });

  setUp(() => cubit = _MockCubit());

  for (final brightness in Brightness.values) {
    testWidgets('modern lost & found · ${brightness.name}', (tester) async {
      final state = LostFoundState(
        status: .ready,
        items: [
          item(
            'AirPods Pro в белом кейсе',
            'А-318 · 2-я парта',
            'Аня К.',
            const Duration(hours: 2),
          ),
          item(
            'Студенческий · Романов М.',
            'Столовая В-78',
            'Охрана · стойка 1 этаж',
            const Duration(hours: 4),
          ),
          item(
            'Чёрный зонт Xiaomi',
            'Библиотека, читальный зал',
            'Тимур Л.',
            const Duration(days: 1),
            status: .lost,
          ),
          item(
            'Ключ с брелоком-совой',
            'И-204',
            'Кузнецов А. П.',
            const Duration(days: 1),
          ),
          item(
            'Тетрадь по матанализу (зелёная)',
            'А-320',
            'Даша С.',
            const Duration(days: 2),
            status: .lost,
          ),
        ],
      );
      when(() => cubit.state).thenReturn(state);

      tester.view
        ..physicalSize = const Size(390, 844)
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
