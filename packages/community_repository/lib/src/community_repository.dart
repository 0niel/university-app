import 'package:equatable/equatable.dart';
import 'package:university_app_server_api/client.dart';

/// {@template schedule_failure}
/// Base failure class for the community repository failures.
/// {@endtemplate}
abstract class CommunityFailure with EquatableMixin implements Exception {
  /// {@macro schedule_failure}
  const CommunityFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetContributorsFailure extends CommunityFailure {
  const GetContributorsFailure(super.error);
}

class GetSpnsorsFailure extends CommunityFailure {
  const GetSpnsorsFailure(super.error);
}

/// {@template community_repository}
/// A repository that manages schedule data.
/// {@endtemplate}
class CommunityRepository {
  /// {@macro community_repository}
  const CommunityRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<SponsorsResponse> getSponsors() async {
    try {
      return await _apiClient.getSponsors();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetSpnsorsFailure(error), stackTrace);
    }
  }

  Future<ContributorsResponse> getContributors() async {
    try {
      return await _apiClient.getContributors();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetContributorsFailure(error), stackTrace);
    }
  }
}
