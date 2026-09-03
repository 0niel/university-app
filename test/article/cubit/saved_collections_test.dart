import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/article/cubit/followed_sources_cubit.dart';
import 'package:rtu_mirea_app/article/cubit/saved_articles_cubit.dart';
import 'package:rtu_mirea_app/communities/cubit/joined_communities_cubit.dart';
import 'package:rtu_mirea_app/marketplace/cubit/market_favorites_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  final collections =
      <String, (HydratedCubit<List<String>> Function(), String)>{
        'articles': (SavedArticlesCubit.new, 'ids'),
        'sources': (FollowedSourcesCubit.new, 'keys'),
        'communities': (JoinedCommunitiesCubit.new, 'ids'),
        'market favorites': (MarketFavoritesCubit.new, 'ids'),
      };

  for (final entry in collections.entries) {
    test('${entry.key} tolerates malformed stored values', () async {
      final (create, key) = entry.value;
      final cubit = create();
      expect(cubit.fromJson({key: 'invalid'}), isNull);
      expect(
        cubit.fromJson({
          key: [null, 8, '', 'a', 'a', 'b'],
        }),
        ['a', 'b'],
      );
      expect(cubit.toJson(['a']), {
        key: ['a'],
      });
      await cubit.close();
    });
  }

  test('market favorites toggle idempotently and persist', () async {
    final cubit = MarketFavoritesCubit()..toggle('listing');
    expect(cubit.state, ['listing']);
    cubit.toggle('listing');
    expect(cubit.state, isEmpty);
    await cubit.close();
  });
}
