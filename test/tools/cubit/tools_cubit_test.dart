import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/tools/cubit/tools_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  late ToolsCubit cubit;

  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    cubit = ToolsCubit();
  });

  tearDown(() => cubit.close());

  test('starts without fabricated grades, grants or earned credits', () {
    expect(cubit.state.marks, isEmpty);
    expect(cubit.state.grants, isEmpty);
    expect(cubit.state.credits, isEmpty);
  });

  test('cycles only entered subject through three four five', () {
    cubit.cycleMark('Math');
    expect(cubit.state.marks, {'Math': 3});
    cubit.cycleMark('Math');
    expect(cubit.state.marks['Math'], 4);
    cubit.cycleMark('Math');
    expect(cubit.state.marks['Math'], 5);
    cubit.cycleMark('Math');
    expect(cubit.state.marks['Math'], 3);
  });

  test('validates persisted and edited numeric data', () {
    cubit
      ..setGrant('base', 1234)
      ..setGrant('base', -1)
      ..setCredits('Math', 8)
      ..setCredits('Math', 121)
      ..setCreditTarget(0);
    expect(cubit.state.grants['base'], 1234);
    expect(cubit.state.credits['Math'], 8);
    expect(cubit.state.creditTarget, 60);
    expect(cubit.fromJson(cubit.toJson(cubit.state)), cubit.state);
    final invalid = cubit.fromJson({
      'marks': {'bad': 8},
      'credits': {'bad': -1},
      'creditTarget': -1,
    })!;
    expect(invalid.marks, isEmpty);
    expect(invalid.credits, isEmpty);
    expect(invalid.creditTarget, 60);
  });
}
