import 'dart:async';

import 'package:community_catalog_repository/community_catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/communities/communities.dart';

final class CommunityCatalogCubitTest extends Mock
    implements CommunityCatalogRepository {}

void main() {
  const catalog = CommunityCatalog(
    organizationId: 'example-university',
    sections: [],
  );

  test('does not emit after it is closed while loading', () async {
    final repository = CommunityCatalogCubitTest();
    final response = Completer<CommunityCatalog>();
    final cubit = CommunityCatalogCubit(repository: repository);
    when(
      () => repository.getCatalog(locale: any(named: 'locale')),
    ).thenAnswer((_) => response.future);

    final load = cubit.load(locale: 'ru');
    await cubit.close();
    response.complete(catalog);

    await expectLater(load, completes);
  });
}
