import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('RtuMireaScheduleApiClient', () {
    late RtuMireaScheduleApiClient apiClient;

    setUp(() {
      apiClient = RtuMireaScheduleApiClient();
    });

    test('can be instantiated', () {
      expect(apiClient, isNotNull);
    });

    test('search returns SearchData', () async {
      final searchData = await apiClient.search(query: 'test');
      expect(searchData, isA<SearchData>());
    });

    test('getIcalContent returns iCal content', () async {
      const itemId = 1;
      const scheduleTargetId = 1;
      final icalContent = await apiClient.getIcalContent(
        itemId: itemId,
        scheduleTargetId: scheduleTargetId,
      );
      expect(icalContent, isNotEmpty);
    });
  });
}
