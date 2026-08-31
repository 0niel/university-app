import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/schedule_comment.dart';

void main() {
  test('ScheduleComment preserves the legacy JSON contract', () {
    const comment = ScheduleComment(
      scheduleName: 'ИКБО-09-22',
      text: 'Контрольная перенесена',
    );
    const json = {
      'scheduleName': 'ИКБО-09-22',
      'text': 'Контрольная перенесена',
    };

    expect(comment.toJson(), json);
    expect(ScheduleComment.fromJson(json), comment);
  });
}
