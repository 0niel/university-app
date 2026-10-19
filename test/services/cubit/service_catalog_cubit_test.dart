import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/services/cubit/service_catalog_cubit.dart';
import 'package:service_catalog_repository/service_catalog_repository.dart';

class _Repository extends Mock implements ServiceCatalogRepository {}

void main() {
  const catalog = ServiceCatalog(organizationId: 'test', sections: []);
  late _Repository repository;
  late ServiceCatalogCubit cubit;

  setUp(() {
    repository = _Repository();
    cubit = ServiceCatalogCubit(repository);
  });
  tearDown(() async => cubit.close());

  test(
    'cold failure is explicit and retry fetches the catalog again',
    () async {
      var attempts = 0;
      when(() => repository.getCatalog(locale: 'ru')).thenAnswer((_) async {
        if (++attempts == 1) throw Exception('Offline');
        return catalog;
      });
      await cubit.load(locale: 'ru');
      expect(cubit.state.hasError, isTrue);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.catalog, isNull);
      final retry = cubit.load(locale: 'ru');
      expect(cubit.state.hasError, isFalse);
      expect(cubit.state.isLoading, isTrue);
      await retry;
      expect(cubit.state.catalog, catalog);
      expect(cubit.state.hasError, isFalse);
      verify(() => repository.getCatalog(locale: 'ru')).called(2);
    },
  );

  test('failed refresh keeps the cached directory and can recover', () async {
    when(
      () => repository.getCatalog(locale: 'ru'),
    ).thenAnswer((_) async => catalog);
    await cubit.load(locale: 'ru');
    when(
      () => repository.getCatalog(locale: 'ru'),
    ).thenThrow(Exception('Offline'));
    await cubit.load(locale: 'ru');
    expect(cubit.state.hasError, isTrue);
    expect(cubit.state.catalog, catalog);
    expect(cubit.state.isRefreshing, isFalse);
    when(
      () => repository.getCatalog(locale: 'ru'),
    ).thenAnswer((_) async => catalog);
    await cubit.load(locale: 'ru');
    expect(cubit.state.hasError, isFalse);
    expect(cubit.state.catalog, catalog);
  });

  test('late failure cannot replace a newer successful catalog', () async {
    final previous = Completer<ServiceCatalog>();
    var requests = 0;
    when(() => repository.getCatalog(locale: 'ru')).thenAnswer((_) {
      if (++requests == 1) return previous.future;
      return Future.value(catalog);
    });
    final oldRequest = cubit.load(locale: 'ru');
    await cubit.load(locale: 'ru');
    previous.completeError(Exception('Late failure'), StackTrace.current);
    await oldRequest;
    expect(cubit.state.catalog, catalog);
    expect(cubit.state.hasError, isFalse);
  });
}
