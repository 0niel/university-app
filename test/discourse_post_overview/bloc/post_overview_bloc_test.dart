import 'package:bloc_test/bloc_test.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/discourse_post_overview/bloc/post_overview_bloc.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  group('PostOverviewBloc', () {
    late CommunityRepository communityRepository;

    final post = DiscoursePost(
      id: 40148,
      topicId: 15330,
      username: 'anya',
      avatarTemplate: '/user_avatar/{size}.png',
      cooked: '<p>Нужен ментор по Rust</p>',
      createdAt: DateTime(2026, 6, 12, 10),
    );
    final comments = [
      DiscoursePostComment(
        id: 1,
        username: 'misha',
        avatarTemplate: '/a/{size}.png',
        cooked: '<p>Могу помочь</p>',
        createdAt: DateTime(2026, 6, 12, 10, 8),
        likeCount: 2,
      ),
    ];

    setUp(() {
      communityRepository = MockCommunityRepository();
    });

    PostOverviewBloc buildBloc() =>
        PostOverviewBloc(communityRepository: communityRepository);

    test('initial state has no post and initial status', () {
      expect(buildBloc().state, equals(const PostOverviewState()));
    });

    group('PostRequested', () {
      blocTest<PostOverviewBloc, PostOverviewState>(
        'emits [loading, loaded] with the post and its comment thread',
        setUp: () {
          when(
            () => communityRepository.getPost(any()),
          ).thenAnswer((_) async => post);
          when(
            () => communityRepository.getPostComments(
              topicId: any(named: 'topicId'),
            ),
          ).thenAnswer((_) async => comments);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const PostRequested(postId: 40148)),
        verify: (_) {
          verify(() => communityRepository.getPost(40148)).called(1);
          verify(
            () => communityRepository.getPostComments(topicId: 15330),
          ).called(1);
        },
        expect: () => [
          const PostOverviewState(
            status: PostOverviewStatus.loading,
          ),
          PostOverviewState(
            post: post,
            comments: comments,
            status: PostOverviewStatus.loaded,
          ),
        ],
      );

      blocTest<PostOverviewBloc, PostOverviewState>(
        'still loads the post with empty comments when getPostComments throws',
        setUp: () {
          when(
            () => communityRepository.getPost(any()),
          ).thenAnswer((_) async => post);
          when(
            () => communityRepository.getPostComments(
              topicId: any(named: 'topicId'),
            ),
          ).thenThrow(Exception('topic fetch failed'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const PostRequested(postId: 40148)),
        expect: () => [
          const PostOverviewState(
            status: PostOverviewStatus.loading,
          ),
          PostOverviewState(
            post: post,
            status: PostOverviewStatus.loaded,
          ),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<PostOverviewBloc, PostOverviewState>(
        'emits [loading, failure] and reports the error when getPost throws',
        setUp: () => when(
          () => communityRepository.getPost(any()),
        ).thenThrow(Exception('post not found')),
        build: buildBloc,
        act: (bloc) => bloc.add(const PostRequested(postId: 999)),
        expect: () => [
          const PostOverviewState(
            status: PostOverviewStatus.loading,
          ),
          const PostOverviewState(
            status: PostOverviewStatus.failure,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
