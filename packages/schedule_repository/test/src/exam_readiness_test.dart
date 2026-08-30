import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  test('normalizes canonical RPC values', () {
    final readiness = ExamReadiness.fromJson({
      'subject_name': 'Databases',
      'readiness': '125',
    });

    expect(readiness.subjectName, 'Databases');
    expect(readiness.readiness, 100);
    expect(readiness.toJson(), {
      'subject_name': 'Databases',
      'readiness': 100,
    });
  });

  test('has value equality', () {
    expect(
      const ExamReadiness(subjectName: 'Math', readiness: 50),
      const ExamReadiness(subjectName: 'Math', readiness: 50),
    );
  });
}
