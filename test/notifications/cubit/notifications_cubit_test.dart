import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:rtu_mirea_app/notifications/cubit/notifications_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    HydratedBloc.storage = CustomHydratedStorage(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });

  test('keeps only the latest copy of a delivered push', () async {
    final cubit = NotificationsCubit(userId: 'student-a');
    addTearDown(cubit.close);

    cubit
      ..recordPush(id: 'notice', title: 'First')
      ..recordPush(id: 'notice', title: 'Updated');

    expect(cubit.state.pushes.single.title, 'Updated');
    expect(cubit.state.hasUnread(['notice']), isTrue);
    cubit.markRead('notice');
    expect(cubit.state.hasUnread(['notice']), isFalse);
  });

  test('bounds stored pushes and read markers', () async {
    final cubit = NotificationsCubit(userId: 'student-a');
    addTearDown(cubit.close);
    for (var index = 0; index < 60; index++) {
      cubit.recordPush(id: '$index', title: 'Notice $index');
    }
    cubit.markAllRead(List.generate(450, (index) => '$index'));

    expect(cubit.state.pushes, hasLength(NotificationsCubit.maxPushes));
    expect(cubit.state.pushes.first.id, '59');
    expect(cubit.state.readIds, hasLength(NotificationsCubit.maxReadIds));
    expect(cubit.state.readIds, isNot(contains('0')));
    expect(cubit.state.readIds, contains('449'));
  });

  test('switching accounts clears private messages and read state', () async {
    final cubit = NotificationsCubit(userId: 'student-a');
    addTearDown(cubit.close);
    cubit
      ..recordPush(id: 'private', title: 'Private message')
      ..markRead('private')
      ..selectUser('student-b');

    expect(cubit.state.userId, 'student-b');
    expect(cubit.state.pushes, isEmpty);
    expect(cubit.state.readIds, isEmpty);
  });

  test('signed-out delivery is not retained', () async {
    final cubit = NotificationsCubit(userId: 'student-a');
    addTearDown(cubit.close);
    cubit
      ..recordPush(title: 'Private')
      ..selectUser('')
      ..recordPush(title: 'After logout');

    expect(cubit.state.userId, isNull);
    expect(cubit.state.pushes, isEmpty);
  });

  test('restores only the current account history', () async {
    await HydratedBloc.storage.write('NotificationsCubit', {
      'userId': 'student-a',
      'pushes': [
        {
          'id': 'private',
          'kind': 'accent',
          'title': 'Private',
          'createdAt': '2026-09-02T10:00:00Z',
        },
      ],
      'readIds': ['private'],
    });
    final sameUser = NotificationsCubit(userId: 'student-a');
    expect(sameUser.state.pushes.single.id, 'private');
    await sameUser.close();

    final otherUser = NotificationsCubit(userId: 'student-b');
    addTearDown(otherUser.close);
    expect(otherUser.state.pushes, isEmpty);
    expect(otherUser.state.readIds, isEmpty);
  });

  test('drops unscoped legacy history and invalid stored values', () async {
    final cubit = NotificationsCubit(userId: 'student-a');
    addTearDown(cubit.close);
    expect(cubit.fromJson({'userId': 42}), isNull);
    expect(
      cubit.fromJson({'pushes': 'invalid', 'readIds': null})?.pushes,
      isEmpty,
    );
  });
}
