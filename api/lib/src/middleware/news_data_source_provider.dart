import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';
import 'package:university_app_server_api/api.dart';
import 'package:university_app_server_api/src/data/news/redis_cached_news_data_source.dart';
import 'package:university_app_server_api/src/redis.dart';

/// Provides a [NewsDataSource] to the current [RequestContext].
Middleware newsDataSourceProvider() {
  return provider<NewsDataSource>((context) {
    final supabaseClient = context.read<SupabaseClient>();
    final base = CombinedNewsDataSource(supabaseClient: supabaseClient);
    final redis = context.read<RedisClient>();
    return RedisCachedNewsDataSource(delegate: base, redisClient: redis);
  });
}
