import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Storage extends Mock implements Storage {}

class _Friends extends Mock implements FriendsRepository {}

class _Schedule extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class ProfileTestEnvironment {
  ProfileTestEnvironment() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Campus App',
      packageName: 'test.campus',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    when(friends.getFriends).thenAnswer((_) async => []);
    when(() => schedule.state).thenReturn(const ScheduleState());
  }

  final FriendsRepository friends = _Friends();
  final ScheduleBloc schedule = _Schedule();

  Widget wrap({required Widget child}) =>
      RepositoryProvider<FriendsRepository>.value(
        value: friends,
        child: BlocProvider<ScheduleBloc>.value(value: schedule, child: child),
      );
}
