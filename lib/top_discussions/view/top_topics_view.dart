import 'package:collection/collection.dart';
import 'package:discourse_repository/discourse_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/bloc/discourse_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/widgets/widgets.dart';

class TopTopicsView extends StatelessWidget {
  const TopTopicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiscourseBloc>(
      create: (context) => DiscourseBloc(
        discourseRepository: context.read<DiscourseRepository>(),
      )..add(const DiscourseTopTopicsLoadRequest()),
      child: const _TopTopicsView(),
    );
  }
}

class _TopTopicsView extends StatelessWidget {
  const _TopTopicsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscourseBloc, DiscourseState>(
      builder: (context, state) {
        if (state.status == DiscourseStatus.loaded) {
          final top = state.topTopics?.topicList.topics.take(15).toList() ?? [];

          return top.isNotEmpty
              ? SizedBox(
                  height: 332,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: top.length,
                    itemBuilder: (context, index) {
                      final topic = top[index];
                      final author = state.topTopics?.users.firstWhereOrNull(
                        (user) => topic.posters.first['user_id'] == user.id,
                      );

                      return TopicCard(
                        topic: topic,
                        author: author,
                      );
                    },
                  ),
                )
              : const SizedBox.shrink();
        } else if (state.status == DiscourseStatus.loading) {
          return SizedBox(
            height: 220,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const TopicsSkeletonCard();
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
