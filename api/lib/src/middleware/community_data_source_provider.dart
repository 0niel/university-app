import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/api.dart';

final _communityDataSource = CommunityGithubDataSourceWithStaticData();

Middleware communityDataSourceProvider() {
  return (handler) {
    return handler.use(provider<CommunityDataSource>((_) => _communityDataSource));
  };
}
