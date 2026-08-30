import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_client/permission_client.dart';
import 'package:preferences_repository/preferences_repository.dart';

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

class MockPermissionClient extends Mock implements PermissionClient {}
