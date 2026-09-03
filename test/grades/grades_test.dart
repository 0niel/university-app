import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/data/grades_repository.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Repository implements GradesRepository {
  GradesBook book = const GradesBook();
  bool failLoad = false;
  bool failSave = false;
  Completer<void>? gate;

  @override
  Future<GradesBook> load() async {
    if (failLoad) throw StateError('read failed');
    return book;
  }

  @override
  Future<void> save(GradesBook next) async {
    await gate?.future;
    if (failSave) throw StateError('write failed');
    book = next;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final now = DateTime(2026, 9, 14, 18);
  late _Repository repository;
  late GradesCubit cubit;

  setUp(() {
    repository = _Repository();
    cubit = GradesCubit(repository: repository, now: () => now);
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() async => cubit.close());

  test(
    'starts empty and derives subjects from the selected schedule',
    () async {
      await cubit.load();
      cubit.scheduleSubjectsChanged(const [SubjectGrades(subject: 'Physics')]);
      expect(cubit.state.status, GradesStatus.ready);
      expect(cubit.state.subjects.single.subject, 'Physics');
      expect(cubit.state.gpa, isNull);
    },
  );

  test('persists marks and computes the real arithmetic mean', () async {
    await cubit.load();
    expect(await cubit.addMark(subject: 'Physics', value: 5), isTrue);
    expect(await cubit.addMark(subject: 'Physics', value: 3), isTrue);
    expect(cubit.state.gpa, 4);
    expect(repository.book, cubit.state.book);
    expect(await cubit.removeLastMark('Physics'), isTrue);
    expect(cubit.state.gpa, 5);
  });

  test('keeps terms separate', () async {
    await cubit.load();
    await cubit.addMark(subject: 'Physics', value: 5);
    cubit.termChanged(cubit.state.terms[1].id);
    expect(cubit.state.gpa, isNull);
    await cubit.addMark(subject: 'Physics', value: 3);
    expect(cubit.state.gpa, 3);
    cubit.termChanged(cubit.state.terms.first.id);
    expect(cubit.state.gpa, 5);
  });

  test('does not report a failed write as a saved mark', () async {
    await cubit.load();
    repository.failSave = true;
    expect(await cubit.addMark(subject: 'Physics', value: 5), isFalse);
    expect(cubit.state.gpa, isNull);
    repository.failSave = false;
    expect(await cubit.addMark(subject: 'Physics', value: 4), isTrue);
    expect(cubit.state.subjects.single.marks.single.value, 4);
  });

  test('serializes writes without dropping concurrent marks', () async {
    await cubit.load();
    repository.gate = Completer<void>();
    final first = cubit.addMark(subject: 'Physics', value: 5);
    final second = cubit.addMark(subject: 'Physics', value: 3);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.gpa, isNull);
    repository.gate!.complete();
    expect(await first, isTrue);
    expect(await second, isTrue);
    expect(cubit.state.subjects.single.marks.length, 2);
    expect(cubit.state.gpa, 4);
  });

  test('rejects invalid values and blank subjects', () async {
    await cubit.load();
    expect(await cubit.addMark(subject: ' ', value: 5), isFalse);
    expect(await cubit.addMark(subject: 'Physics', value: 6), isFalse);
    expect(await cubit.addMark(subject: 'Physics', value: 1), isFalse);
    expect(cubit.state.book.terms, isEmpty);
  });

  test('refresh waits for accepted pending writes', () async {
    await cubit.load();
    repository.gate = Completer<void>();
    final write = cubit.addMark(subject: 'Physics', value: 5);
    final refresh = cubit.load();
    repository.gate!.complete();
    expect(await write, isTrue);
    await refresh;
    expect(cubit.state.gpa, 5);
    expect(cubit.state.status, GradesStatus.ready);
  });

  test('load errors expose retryable failure state', () async {
    repository.failLoad = true;
    await cubit.load();
    expect(cubit.state.status, GradesStatus.failure);
    repository.failLoad = false;
    await cubit.load();
    expect(cubit.state.status, GradesStatus.ready);
  });

  test('local repository survives reload and isolates accounts', () async {
    const first = LocalGradesRepository(userId: 'first');
    const second = LocalGradesRepository(userId: 'second');
    await cubit.load();
    await cubit.addMark(subject: 'Physics', value: 5);
    await first.save(cubit.state.book);
    expect(await first.load(), cubit.state.book);
    expect((await second.load()).terms, isEmpty);
  });

  test('corrupt local storage is not silently treated as empty', () async {
    SharedPreferences.setMockInitialValues({
      LocalGradesRepository.storageKey: '{invalid',
    });
    await expectLater(
      const LocalGradesRepository().load(),
      throwsA(isA<FormatException>()),
    );
  });
}
