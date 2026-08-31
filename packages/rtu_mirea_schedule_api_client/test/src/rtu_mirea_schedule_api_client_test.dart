import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() => registerFallbackValue(Uri()));

  group('RtuMireaScheduleApiClient', () {
    late RtuMireaScheduleApiClient apiClient;
    late MockHttpClient httpClient;

    setUp(() {
      httpClient = MockHttpClient();
      apiClient = RtuMireaScheduleApiClient(httpClient: httpClient);
    });

    test('search returns SearchData', () async {
      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          '''
          {"data":[
            {
              "id":1,
              "targetTitle":"IU7-31B",
              "fullTitle":"IU7-31B group",
              "scheduleTarget":1,
              "iCalLink":"https://example.edu/schedule.ics"
            }
          ]}
          ''',
          200,
        ),
      );

      final searchData = await apiClient.search(query: 'test');
      expect(searchData, isA<SearchData>());
      expect(searchData.data.singleOrNull?.targetTitle, 'IU7-31B');
    });

    test('getIcalContent returns iCal content', () async {
      const itemId = 1;
      const scheduleTargetId = 1;
      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('BEGIN:VCALENDAR', 200));

      final icalContent = await apiClient.getIcalContent(
        itemId: itemId,
        scheduleTargetId: scheduleTargetId,
      );
      expect(icalContent, 'BEGIN:VCALENDAR');
    });
  });
}
