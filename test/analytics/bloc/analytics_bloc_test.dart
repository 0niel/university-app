import 'package:analytics_repository/analytics_repository.dart' as analytics;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/analytics/analytics.dart';

class MockAnalyticsRepository extends Mock
    implements analytics.AnalyticsRepository {}

class _FakeAnalyticsEvent extends Fake implements analytics.AnalyticsEvent {}

void main() {
  group('AnalyticsBloc', () {
    late analytics.AnalyticsRepository analyticsRepository;

    const event = analytics.AnalyticsEvent(
      'test_event',
      properties: <String, dynamic>{'key': 'value'},
    );

    setUpAll(() {
      registerFallbackValue(_FakeAnalyticsEvent());
    });

    setUp(() {
      analyticsRepository = MockAnalyticsRepository();
      when(
        () => analyticsRepository.track(any()),
      ).thenAnswer((_) async {});
    });

    AnalyticsBloc buildBloc() =>
        AnalyticsBloc(analyticsRepository: analyticsRepository);

    test('initial state is AnalyticsInitial', () {
      expect(buildBloc().state, isA<AnalyticsInitial>());
    });

    group('AnalyticsEventTracked', () {
      blocTest<AnalyticsBloc, AnalyticsState>(
        'tracks the event via the repository and emits no new state',
        build: buildBloc,
        act: (bloc) => bloc.add(AnalyticsEventTracked()..event = event),
        expect: () => const <AnalyticsState>[],
        verify: (_) {
          verify(() => analyticsRepository.track(event)).called(1);
        },
      );

      blocTest<AnalyticsBloc, AnalyticsState>(
        'adds error and emits no new state when track throws',
        setUp: () {
          when(() => analyticsRepository.track(any())).thenThrow(
            const analytics.TrackEventFailure('oops'),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(AnalyticsEventTracked()..event = event),
        expect: () => const <AnalyticsState>[],
        errors: () => [isA<analytics.TrackEventFailure>()],
        verify: (_) {
          verify(() => analyticsRepository.track(event)).called(1);
        },
      );
    });
  });
}
