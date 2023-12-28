import 'package:university_app_server_api/src/data/community/models/models.dart';

/// {@template community_data_source}
/// A data source for the community.
/// {@endtemplate}
abstract class CommunityDataSource {
  /// Returns a list of [Contributor]s.
  Future<List<Contributor>> getContributors();

  /// Returns a list of [Sponsor]s.
  Future<List<Sponsor>> getSponsors();
}
