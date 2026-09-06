import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/startup_screen_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  setUp(() {
    final values = <String, dynamic>{};
    final storage = _Storage();
    when(() => storage.read(any())).thenAnswer(
      (call) => values[call.positionalArguments.first],
    );
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((call) async {
      values[call.positionalArguments.first as String] =
          call.positionalArguments[1];
    });
    HydratedBloc.storage = storage;
  });

  test('defaults to home and rejects unknown persisted destinations', () async {
    final cubit = StartupScreenCubit(userId: 'a');
    expect(cubit.state, StartupScreen.home);
    expect(cubit.fromJson({}), StartupScreen.home);
    expect(cubit.fromJson({'screen': '/admin'}), StartupScreen.home);
    expect(cubit.fromJson({'screen': 42}), StartupScreen.home);
    await cubit.close();
  });

  test('restores every supported choice after restart', () async {
    for (final screen in StartupScreen.values) {
      final first = StartupScreenCubit(userId: 'a')..select(screen);
      await first.close();
      final restored = StartupScreenCubit(userId: 'a');
      expect(restored.state, screen);
      await restored.close();
    }
  });

  test('switching accounts and signing out keep choices separate', () async {
    final first = StartupScreenCubit(userId: 'a')
      ..select(StartupScreen.schedule);
    final other = StartupScreenCubit(userId: 'b');
    final signedOut = StartupScreenCubit(userId: '');
    expect(other.state, StartupScreen.home);
    expect(signedOut.state, StartupScreen.home);
    other.select(StartupScreen.map);
    await first.close();
    await other.close();
    await signedOut.close();
    final restored = StartupScreenCubit(userId: 'a');
    expect(restored.state, StartupScreen.schedule);
    await restored.close();
  });
}
