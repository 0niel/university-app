import 'package:github/github.dart';
import 'package:university_app_server_api/src/data/community/community_data_source.dart';
import 'package:university_app_server_api/src/data/community/models/sponsor.dart';

part 'static_sponsors_data.dart';

/// {@template community_github_data_source_with_static_data}
/// Implementation of a [CommunityDataSource] that returns static data and
/// github data.
/// {@endtemplate}
class CommunityGithubDataSourceWithStaticData extends CommunityDataSource {
  /// {@macro community_github_data_source_with_static_data}
  CommunityGithubDataSourceWithStaticData({GithubClient? githubClient})
      : _githubClient = githubClient ?? GithubClient();

  final GithubClient _githubClient;

  @override
  Future<List<Contributor>> getContributors() async {
    final contributors = await _githubClient.getContributors();

    return contributors;
  }

  @override
  Future<List<Sponsor>> getSponsors() {
    return Future.value(sponsors);
  }
}
