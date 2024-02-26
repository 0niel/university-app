import 'package:discourse_api_client/discourse_api_client.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:equatable/equatable.dart';

/// {@template discourse_failure}
/// Base failure class for the Discourse repository failures.
/// {@endtemplate}
abstract class DiscourseFailure with EquatableMixin implements Exception {
  /// {@macro discourse_failure}
  const DiscourseFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

class GetTopFailure extends DiscourseFailure {
  const GetTopFailure(super.error);
}

/// {@template discourse_repository}
/// A repository that manages Discourse community data.
/// {@endtemplate}
class DiscourseRepository {
  /// {@macro discourse_repository}
  const DiscourseRepository({
    required DiscourseApiClient apiClient,
  }) : _apiClient = apiClient;

  final DiscourseApiClient _apiClient;

  Future<Top> getTop() async {
    try {
      return await _apiClient.getTop();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetTopFailure(error), stackTrace);
    }
  }
}
