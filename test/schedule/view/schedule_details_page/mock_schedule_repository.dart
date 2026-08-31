import 'package:campus_repository/campus_repository.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

class MockFriendsRepository extends Mock implements FriendsRepository {}

class MockCampusRepository extends Mock implements CampusRepository {}
