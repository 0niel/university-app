import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';
import 'package:test/test.dart';

void main() {
  test('search models preserve the schedule API JSON contract', () {
    const item = SearchItem(
      id: 1,
      targetTitle: 'IU7-31B',
      fullTitle: 'IU7-31B group',
      scheduleTarget: 1,
      iCalLink: 'https://example.edu/schedule.ics',
    );
    const data = SearchData(data: [item]);

    expect(SearchData.fromJson(data.toJson()), data);
    expect(data.toJson()['data'], [item.toJson()]);
    expect(item.copyWith(targetTitle: 'IU7-32B').targetTitle, 'IU7-32B');
  });
}
