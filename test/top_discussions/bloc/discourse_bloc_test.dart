import 'package:bloc_test/bloc_test.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/top_discussions/top_discussions.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  group('DiscourseBloc', () {
    late CommunityRepository communityRepository;

    const topic = DiscourseTopic(
      id: 1,
      title: 'Top topic',
      postsCount: 12,
      replyCount: 8,
      likeCount: 5,
      views: 100,
      posters: [],
    );
    const user = DiscourseUser(
      id: 7,
      username: 'mirea',
      avatarTemplate: '/avatar/{size}.png',
    );
    const response = TopTopicsResponse(topics: [topic], users: [user]);

    setUp(() {
      communityRepository = MockCommunityRepository();
      when(
        () => communityRepository.getTopTopics(),
      ).thenAnswer((_) async => response);
    });

    DiscourseBloc buildBloc() => DiscourseBloc(communityRepository);

    test('initial state is DiscourseState()', () {
      expect(buildBloc().state, equals(const DiscourseState()));
    });

    group('DiscourseTopTopicsRequested', () {
      blocTest<DiscourseBloc, DiscourseState>(
        'emits [loading, loaded] with topics when getTopTopics succeeds',
        build: buildBloc,
        act: (bloc) => bloc.add(const DiscourseTopTopicsRequested()),
        expect: () => const <DiscourseState>[
          DiscourseState(
            status: DiscourseStatus.loading,
          ),
          DiscourseState(
            topTopics: response,
            status: DiscourseStatus.loaded,
          ),
        ],
        verify: (_) {
          verify(() => communityRepository.getTopTopics()).called(1);
        },
      );

      blocTest<DiscourseBloc, DiscourseState>(
        'emits [loading, failure] and reports the error when getTopTopics '
        'throws',
        setUp: () => when(
          () => communityRepository.getTopTopics(),
        ).thenThrow(GetTopTopicsFailure(Exception('network'))),
        build: buildBloc,
        act: (bloc) => bloc.add(const DiscourseTopTopicsRequested()),
        expect: () => const <DiscourseState>[
          DiscourseState(
            status: DiscourseStatus.loading,
          ),
          DiscourseState(
            status: DiscourseStatus.failure,
          ),
        ],
        errors: () => [isA<GetTopTopicsFailure>()],
      );
    });

    group('hasTrendingContent', () {
      test('is true while loading (shows the skeleton)', () {
        expect(
          const DiscourseState(
            status: DiscourseStatus.loading,
          ).hasTrendingContent,
          isTrue,
        );
      });

      test('is true when loaded with topics', () {
        expect(
          const DiscourseState(
            topTopics: response,
            status: DiscourseStatus.loaded,
          ).hasTrendingContent,
          isTrue,
        );
      });

      test('is false when loaded with no topics', () {
        expect(
          const DiscourseState(
            topTopics: TopTopicsResponse(topics: [], users: []),
            status: DiscourseStatus.loaded,
          ).hasTrendingContent,
          isFalse,
        );
      });

      test('is false on failure', () {
        expect(
          const DiscourseState(
            status: DiscourseStatus.failure,
          ).hasTrendingContent,
          isFalse,
        );
      });

      test('is false on the initial state', () {
        expect(const DiscourseState().hasTrendingContent, isFalse);
      });
    });

    group('showTrendingSection', () {
      test('is true on failure so the error card can render', () {
        expect(
          const DiscourseState(
            status: DiscourseStatus.failure,
          ).showTrendingSection,
          isTrue,
        );
      });

      test('is false on the initial state', () {
        expect(const DiscourseState().showTrendingSection, isFalse);
      });

      test('mirrors hasTrendingContent while loading', () {
        expect(
          const DiscourseState(
            status: DiscourseStatus.loading,
          ).showTrendingSection,
          isTrue,
        );
      });
    });
  });
}
