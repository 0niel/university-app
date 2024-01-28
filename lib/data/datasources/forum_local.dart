import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/forum_member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ForumLocalData {
  Future<List<ForumMemberModel>> getPatronsFromCache();
  Future<void> setPatronsToCache(List<ForumMemberModel> patrons);
}

class ForumLocalDataImpl implements ForumLocalData {
  final SharedPreferences sharedPreferences;

  ForumLocalDataImpl({required this.sharedPreferences});

  @override
  Future<List<ForumMemberModel>> getPatronsFromCache() {
    final jsonPatronsList = sharedPreferences.getStringList('forum_patrons');
    if (jsonPatronsList != null) {
      return Future.value(jsonPatronsList.map((jsonPatron) => ForumMemberModel.fromRawJson(jsonPatron)).toList());
    } else {
      throw CacheException('The list of patrons is not set');
    }
  }

  @override
  Future<void> setPatronsToCache(List<ForumMemberModel> patrons) {
    final List<String> jsonContributorsList = patrons.map((contributor) => contributor.toRawJson()).toList();
    return sharedPreferences.setStringList('forum_patrons', jsonContributorsList);
  }
}
