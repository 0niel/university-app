import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:community_repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/top_discussions/bloc/discourse_bloc.dart';
import 'package:rtu_mirea_app/top_discussions/view/topic_news_card.dart';
import 'package:rtu_mirea_app/top_discussions/view/topic_news_card_skeleton.dart';

class TopTopicsContent extends StatelessWidget {
  const TopTopicsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscourseBloc, DiscourseState>(
      builder: (context, state) =>
          NinjaStateSwitcher(child: _content(context, state)),
    );
  }

  Widget _content(BuildContext context, DiscourseState state) {
    if (state.status == .failure) {
      final l10n = context.l10n;
      return Padding(
        key: const ValueKey('topics-failure'),
        padding: const EdgeInsets.symmetric(
          horizontal: NinjaMetrics.screenPadding,
        ),
        child: NinjaErrorCard(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          actionLabel: l10n.retry,
          onAction: () => context.read<DiscourseBloc>().add(
            const DiscourseTopTopicsRequested(),
          ),
        ).animateEmptyState(),
      );
    }
    if (!state.hasTrendingContent) {
      return const SizedBox.shrink(key: ValueKey('topics-empty'));
    }
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final railHeight = 200 + ((textScale - 1).clamp(0, 1).toDouble() * 72);

    final loading = state.status == .loading;
    final topics = loading
        ? const <DiscourseTopic>[]
        : (state.topTopics?.topics.take(15).toList() ??
              const <DiscourseTopic>[]);

    return SizedBox(
      key: ValueKey(loading ? 'topics-loading' : 'topics-list'),
      height: railHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: NinjaMetrics.screenPadding,
        ),
        itemCount: loading ? 3 : topics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (loading) return const TopicNewsCardSkeleton();
          final topic = topics.elementAtOrNull(index);
          if (topic == null) return const SizedBox.shrink();
          final author = state.topTopics?.users.firstWhereOrNull(
            (user) =>
                topic.posters.isNotEmpty &&
                topic.posters.first.userId == user.id,
          );
          return TopicNewsCard(topic: topic, author: author);
        },
      ),
    );
  }
}
