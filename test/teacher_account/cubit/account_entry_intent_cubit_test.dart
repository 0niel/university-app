import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_entry_intent_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  late Map<String, dynamic> values;

  setUp(() {
    values = {};
    final storage = _Storage();
    when(
      () => storage.read(any()),
    ).thenAnswer((call) => values[call.positionalArguments.first]);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((call) async {
      values[call.positionalArguments.first as String] =
          call.positionalArguments[1];
    });
    HydratedBloc.storage = storage;
  });

  test(
    'teacher entry survives email confirmation and is consumed once',
    () async {
      final initial = AccountEntryIntentCubit()..select(AccountRole.teacher);
      final restored = AccountEntryIntentCubit();
      expect(restored.state, AccountRole.teacher);
      expect(restored.consume(), AccountRole.teacher);
      expect(restored.consume(), isNull);
      expect(AccountEntryIntentCubit().state, isNull);
      await initial.close();
      await restored.close();
    },
  );

  test('student intent replaces teacher mode and is consumed once', () async {
    final cubit = AccountEntryIntentCubit()
      ..select(AccountRole.teacher)
      ..select(AccountRole.student);
    expect(cubit.consume(), AccountRole.student);
    expect(cubit.consume(), isNull);
    expect(cubit.fromJson({'role': 'admin'}), isNull);
    await cubit.close();
  });
}
