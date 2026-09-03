import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/view/session/exam_topics_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  late ExamTopicsCubit cubit;

  setUp(() {
    final storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
    cubit = ExamTopicsCubit();
  });

  tearDown(() => cubit.close());

  test('has no fabricated topics and validates additions', () {
    expect(cubit.state.readiness('exam'), isNull);
    expect(cubit.addTopic('exam', '  '), isFalse);
    expect(cubit.addTopic('exam', '  Topic A '), isTrue);
    expect(cubit.addTopic('exam', 'topic a'), isFalse);
    expect(cubit.state.forExam('exam').single.title, 'Topic A');
  });

  test('completion updates readiness and removes covered topics from plan', () {
    cubit
      ..addTopic('exam', 'A')
      ..addTopic('exam', 'B')
      ..toggle('exam', 0);
    expect(cubit.state.readiness('exam'), .5);
    expect(cubit.state.plan('exam').single.title, 'B');
    cubit.toggle('exam', 1);
    expect(cubit.state.readiness('exam'), 1);
    expect(cubit.state.plan('exam'), isEmpty);
    cubit.remove('exam', 0);
    expect(cubit.state.forExam('exam'), hasLength(1));
  });

  test('rebuild reorders remaining topics and survives hydration', () async {
    cubit
      ..addTopic('exam', 'A')
      ..addTopic('exam', 'B')
      ..rebuild('exam');
    expect(cubit.state.plan('exam').map((topic) => topic.title), ['B', 'A']);
    expect(cubit.fromJson(cubit.toJson(cubit.state)), cubit.state);
    when(
      () => HydratedBloc.storage.read(cubit.storageToken),
    ).thenReturn(jsonDecode(jsonEncode(cubit.toJson(cubit.state))));
    final restored = ExamTopicsCubit();
    expect(restored.state, cubit.state);
    await restored.close();
  });
}
