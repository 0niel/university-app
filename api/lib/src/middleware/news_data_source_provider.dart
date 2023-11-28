import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

final _newsDataSource = RtuMireNewsDataSource();

Middleware newsDataSourceProvider() {
  return (handler) {
    return handler.use(provider<NewsDataSource>((_) => _newsDataSource));
  };
}
