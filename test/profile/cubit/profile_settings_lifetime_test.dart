import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:user_repository/user_repository.dart';

class _Gamification extends Mock implements GamificationRepository {}

void main() {
  setUpAll(() => registerFallbackValue(const UserSettings()));

  test('closing while saving never starts a queued settings write', () async {
    final repository = _Gamification();
    final pending = Completer<UserSettings>();
    when(
      () => repository.updateSettings(any(), previous: any(named: 'previous')),
    ).thenAnswer((_) => pending.future);
    final cubit = ProfileCubit(
      gamificationRepository: repository,
      organizationId: 'org',
      currentUser: const User(id: 'one'),
    );
    final first = cubit.updateSettings(const UserSettings(themeMode: 'dark'));
    await Future<void>.delayed(Duration.zero);
    final second = cubit.updateSettings(
      const UserSettings(themeMode: 'dark', anonymousReactions: false),
    );
    await cubit.close();
    pending.complete(const UserSettings(themeMode: 'dark'));
    await Future.wait([first, second]);
    verify(
      () => repository.updateSettings(any(), previous: any(named: 'previous')),
    ).called(1);
  });

  test('failed setting is visible until successful retry', () async {
    final repository = _Gamification();
    var fail = true;
    when(
      () => repository.updateSettings(any(), previous: any(named: 'previous')),
    ).thenAnswer((invocation) async {
      if (fail) throw Exception('offline');
      return invocation.positionalArguments.first as UserSettings;
    });
    final cubit = ProfileCubit(
      gamificationRepository: repository,
      organizationId: 'org',
      currentUser: const User(id: 'one'),
    );
    const updated = UserSettings(themeMode: 'dark');
    await cubit.updateSettings(updated);
    expect(cubit.state.hasFailed(ProfileSection.settings), isTrue);
    expect(cubit.state.settings, const UserSettings());
    fail = false;
    await cubit.updateSettings(updated);
    expect(cubit.state.hasFailed(ProfileSection.settings), isFalse);
    expect(cubit.state.settings, updated);
    await cubit.close();
  });
}
