import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDeepLinkClient extends Mock implements DeepLinkClient {}

void main() {
  late DeepLinkClient deepLinkClient;
  late StreamController<Uri> onDeepLinkStreamController;
  late List<DeepLinkService> services;

  setUp(() {
    deepLinkClient = MockDeepLinkClient();
    onDeepLinkStreamController = StreamController<Uri>.broadcast();
    when(
      () => deepLinkClient.deepLinkStream,
    ).thenAnswer((_) => onDeepLinkStreamController.stream);
    services = [];
  });

  tearDown(() async {
    await Future.wait(services.map((service) => service.close()));
    await onDeepLinkStreamController.close();
  });

  DeepLinkService buildService() {
    final service = DeepLinkService(deepLinkClient: deepLinkClient);
    services.add(service);
    return service;
  }

  group('DeepLinkService', () {
    test('retrieves and publishes latest link if present', () async {
      final expectedUri = Uri.https('ham.app.test', '/test/path');
      when(
        deepLinkClient.getInitialLink,
      ).thenAnswer((_) => Future.value(expectedUri));

      final service = buildService();
      await expectLater(
        service.deepLinkStream.take(1),
        emits(expectedUri),
      );
    });

    test(
      'publishes DeepLinkClientFailure to stream if upstream throws',
      () async {
        final expectedError = Error();
        final expectedStackTrace = StackTrace.current;

        when(deepLinkClient.getInitialLink).thenAnswer((_) {
          return Future.error(expectedError, expectedStackTrace);
        });

        final deepLinkService = buildService();
        await expectLater(
          deepLinkService.deepLinkStream.take(1),
          emitsError(
            isA<DeepLinkClientFailure>().having(
              (failure) => failure.error,
              'error',
              expectedError,
            ),
          ),
        );
      },
    );

    test('publishes values received through onAppLink callback', () async {
      final expectedUri1 = Uri.https('ham.app.test', '/test/1');
      final expectedUri2 = Uri.https('ham.app.test', '/test/2');

      when(deepLinkClient.getInitialLink).thenAnswer((_) async => null);

      final deepLinkService = buildService();

      final expectation = expectLater(
        deepLinkService.deepLinkStream.take(4),
        emitsInOrder(<Uri>[
          expectedUri1,
          expectedUri1,
          expectedUri2,
          expectedUri1,
        ]),
      );

      [expectedUri1, expectedUri1, expectedUri2, expectedUri1].forEach(
        onDeepLinkStreamController.add,
      );

      await expectation;
    });
  });

  test('DeepLinkClientFailure preserves its original error', () {
    final error = Exception('errorMessage');

    expect(DeepLinkClientFailure(error).error, same(error));
  });
}
