import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_empty_state.dart';
import 'package:rtu_mirea_app/search/view/search_failure_state.dart';
import 'package:rtu_mirea_app/search/view/search_hit.dart';
import 'package:rtu_mirea_app/search/view/search_results_skeleton.dart';
import 'package:rtu_mirea_app/search/widgets/widgets.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    required this.state,
    required this.query,
    required this.onQuerySelected,
    super.key,
  });

  final SearchState state;
  final String query;
  final void Function(String) onQuerySelected;

  List<SearchHit> _hits(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<SearchBloc>();
    final scheduleBloc = context.read<ScheduleBloc>();

    void commitQuery(String value) =>
        bloc.add(SearchHistoryQueryAdded(query: value));

    return [
      for (final group in state.groups.results)
        SearchHit(
          name: group.name,
          type: .group,
          tagLabel: l10n.searchTagGroup,
          onPressed: () {
            scheduleBloc.add(ScheduleRequested(group: group));
            commitQuery(group.name);
            context.go('/schedule');
          },
        ),
      for (final teacher in state.teachers.results)
        SearchHit(
          name: teacher.name,
          type: .teacher,
          tagLabel: l10n.searchTagTeacher,
          onPressed: () {
            scheduleBloc.add(TeacherScheduleRequested(teacher: teacher));
            commitQuery(teacher.name);
            context.go('/schedule');
          },
        ),
      for (final classroom in state.classrooms.results)
        SearchHit(
          name: classroom.name,
          subtitle: classroom.campus?.shortName ?? classroom.campus?.name,
          type: .classroom,
          tagLabel: l10n.searchTagClassroom,
          onPressed: () {
            scheduleBloc.add(ClassroomScheduleRequested(classroom: classroom));
            commitQuery(classroom.name);
            context.go('/schedule');
          },
        ),
      for (final person in state.people)
        SearchHit(
          name: person.fullName,
          subtitle: [
            if (person.handle case final handle? when handle.isNotEmpty)
              '@$handle',
            if (person.group case final group? when group.isNotEmpty) group,
          ].join(' · '),
          type: .person,
          tagLabel: l10n.searchTagPerson,
          onPressed: () {
            commitQuery(person.fullName);
            unawaited(
              Navigator.of(context, rootNavigator: true).push(
                FindFriendsPage.route(
                  initialQuery: person.fullName,
                  initialUserId: person.userId,
                ),
              ),
            );
          },
        ),
      for (final post in state.posts)
        SearchHit(
          name: post.title,
          subtitle: post.authorName,
          type: .post,
          tagLabel: l10n.searchTagPost,
          onPressed: () {
            commitQuery(post.title);
            context.go(
              Uri(
                path: '/services/people/group-space',
                queryParameters: {'post': post.id},
              ).toString(),
            );
          },
        ),
    ];
  }

  int _bestIndex(List<SearchHit> hits) {
    final queryLowercase = query.toLowerCase();
    final starts = hits.indexWhere(
      (hit) => hit.name.toLowerCase().startsWith(queryLowercase),
    );
    if (starts >= 0) return starts;
    final contains = hits.indexWhere(
      (hit) => hit.name.toLowerCase().contains(queryLowercase),
    );
    return contains >= 0 ? contains : 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hits = _hits(context);

    if (hits.isEmpty) {
      return NinjaStateSwitcher(
        child: switch (state.status) {
          .loading => const SearchResultsSkeleton(
            key: ValueKey('search-loading'),
          ),
          .failure => SearchFailureState(
            key: const ValueKey('search-failure'),
            query: query,
          ),
          .initial || .populated => SearchEmptyState(
            key: const ValueKey('search-empty'),
            state: state,
            onQuerySelected: onQuerySelected,
          ),
        },
      );
    }

    final bestIndex = _bestIndex(hits);
    final best = hits.elementAtOrNull(bestIndex);
    if (best == null) return const SizedBox.shrink();
    final rest = [
      for (final (index, hit) in hits.indexed)
        if (index != bestIndex) hit,
    ];

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: AppSpacing.xxlg),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: SearchHeadlineText(headerText: l10n.searchBestMatch),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
          ),
          child: SearchBestMatchCard(
            name: best.name,
            query: query,
            tagLabel: best.tagLabel,
            subtitle: best.subtitle,
            onPressed: best.onPressed,
          ),
        ),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: SearchHeadlineText(
              headerText: l10n.searchMoreResults(rest.length),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: [
                for (final hit in rest)
                  SearchResultItem(
                    name: hit.name,
                    subtitle: hit.subtitle,
                    type: hit.type,
                    tagLabel: hit.tagLabel,
                    onPressed: hit.onPressed,
                  ),
              ],
            ),
          ),
        ],
        if (state.searchHisoty.isNotEmpty) ...[
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: SearchHeadlineText(headerText: l10n.searchRecent),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
            ),
            child: Column(
              spacing: AppSpacing.gap,
              children: [
                for (final recent in state.searchHisoty)
                  SearchHistoryItem(
                    query: recent,
                    onPressed: onQuerySelected,
                    onClear: () => context.read<SearchBloc>().add(
                      SearchHistoryQueryRemoved(query: recent),
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (state.status == .loading) ...[
          const SizedBox(height: AppSpacing.xl),
          const Center(child: NinjaSpinner()),
        ],
      ],
    );
  }
}
