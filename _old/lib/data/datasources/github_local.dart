import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/contributor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GithubLocalData {
  Future<List<ContributorModel>> getContributorsFromCache();
  Future<void> setContributorsToCache(List<ContributorModel> contributors);
}

class GithubLocalDataImpl implements GithubLocalData {
  final SharedPreferences sharedPreferences;

  GithubLocalDataImpl({required this.sharedPreferences});

  @override
  Future<List<ContributorModel>> getContributorsFromCache() {
    final jsonContributorsList =
        sharedPreferences.getStringList('github_contributors');
    if (jsonContributorsList != null) {
      return Future.value(jsonContributorsList
          .map((jsonContributor) =>
              ContributorModel.fromRawJson(jsonContributor))
          .toList());
    } else {
      throw CacheException('The list of contributors is not set');
    }
  }

  @override
  Future<void> setContributorsToCache(List<ContributorModel> contributors) {
    final List<String> jsonContributorsList =
        contributors.map((contributor) => contributor.toRawJson()).toList();
    return sharedPreferences.setStringList(
        'github_contributors', jsonContributorsList);
  }
}
