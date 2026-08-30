import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/locale/locale_cubit.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('LocaleCubit', () {
    test('defaults to Russian', () {
      expect(LocaleCubit().state, AppLanguage.ru);
    });

    blocTest<LocaleCubit, AppLanguage>(
      'setLanguage emits the chosen language',
      build: LocaleCubit.new,
      act: (cubit) => cubit.setLanguage(AppLanguage.en),
      expect: () => [AppLanguage.en],
    );

    test('AppLanguage.locale maps correctly', () {
      expect(AppLanguage.system.locale, isNull);
      expect(AppLanguage.ru.locale?.languageCode, 'ru');
      expect(AppLanguage.en.locale?.languageCode, 'en');
    });

    test('toJson/fromJson round-trips the language', () {
      final cubit = LocaleCubit()..setLanguage(AppLanguage.en);
      final json = cubit.toJson(cubit.state);
      expect(json, {'language': 'en'});
      expect(cubit.fromJson(json), AppLanguage.en);
    });

    test('fromJson falls back to Russian on an unknown value', () {
      expect(LocaleCubit().fromJson({'language': 'fr'}), AppLanguage.ru);
    });
  });
}
