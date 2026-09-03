import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_page.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/bloc/search_bloc.dart';
import 'package:rtu_mirea_app/search/view/search_sheet_row.dart';
import 'package:rtu_mirea_app/search/view/search_subjects.dart';
import 'package:rtu_mirea_app/services/cubit/service_catalog_cubit.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';
import 'package:rtu_mirea_app/services/models/service_entry.dart';

export 'search_subjects.dart';

Future<void> showSearchSheet(BuildContext context, {String? query}) async {
  final scheduleBloc = context.read<ScheduleBloc>();
  final bloc = SearchBloc(
    scheduleRepository: context.read(),
    friendsRepository: context.read(),
    campusRepository: context.read(),
  );
  final subjects = scheduleSubjects(scheduleBloc.state.selectedSchedule);
  final seen = <String>{};
  final services = [
    for (final section in ServicesDirectory.sections(
      context,
      config: context.read(),
      catalog: context.read<ServiceCatalogCubit>().state.catalog,
    ))
      for (final entry in section.entries)
        if (seen.add(entry.id)) entry,
  ];
  try {
    await showAppSheet<void>(
      context,
      heightFraction: 0.86,
      child: SearchSheet(
        bloc: bloc,
        scheduleBloc: scheduleBloc,
        subjects: subjects,
        services: services,
        initialQuery: query,
      ),
    );
  } finally {
    unawaited(bloc.close());
  }
}

class SearchSheet extends StatefulWidget {
  const SearchSheet({
    required this.bloc,
    required this.scheduleBloc,
    required this.subjects,
    required this.services,
    super.key,
    this.initialQuery,
  });

  final SearchBloc bloc;
  final ScheduleBloc scheduleBloc;
  final List<String> subjects;
  final List<ServiceEntry> services;
  final String? initialQuery;

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialQuery,
  );
  late String _query = _controller.text.trim();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    if (_query.isNotEmpty) {
      widget.bloc.add(SearchQueryChanged(searchQuery: _query));
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    final next = _controller.text.trim();
    widget.bloc.add(SearchQueryChanged(searchQuery: _controller.text));
    if (next == _query) return;
    setState(() => _query = next);
  }

  void _setQuery(String value) {
    _controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: value.length);
  }

  void _commit(String value) =>
      widget.bloc.add(SearchHistoryQueryAdded(query: value));

  void _close() => Navigator.of(context).pop();

  List<SearchSheetHit> _hits(BuildContext context) {
    final l10n = context.l10n;
    final query = _query.toLowerCase();
    if (query.isEmpty) return const [];
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final state = widget.bloc.state;
    return [
      for (final subject in widget.subjects)
        if (subject.toLowerCase().contains(query))
          SearchSheetHit(
            kind: l10n.searchTagSubject,
            title: subject,
            subtitle: l10n.searchSubjectInSchedule,
            onTap: () {
              _commit(subject);
              _close();
              router.go('/schedule');
            },
          ),
      for (final classroom in state.classrooms.results)
        SearchSheetHit(
          kind: l10n.searchTagClassroom,
          title: classroom.name,
          subtitle: classroom.campus?.shortName ?? classroom.campus?.name,
          onTap: () {
            widget.scheduleBloc.add(
              ClassroomScheduleRequested(classroom: classroom),
            );
            _commit(classroom.name);
            _close();
            router.go('/schedule');
          },
        ),
      for (final entry in widget.services)
        if (entry.title.toLowerCase().contains(query))
          SearchSheetHit(
            kind: l10n.searchTagService,
            title: entry.title,
            subtitle: entry.subtitle,
            onTap: () {
              _commit(entry.title);
              _close();
              final path = entry.model.routePath;
              if (path != null) {
                router.go(path);
              } else {
                entry.open(context);
              }
            },
          ),
      for (final person in state.people)
        SearchSheetHit(
          kind: l10n.searchTagPerson,
          title: person.fullName,
          subtitle: [
            if (person.handle case final handle? when handle.isNotEmpty)
              '@$handle',
            if (person.group case final group? when group.isNotEmpty) group,
          ].join(' · '),
          onTap: () {
            _commit(person.fullName);
            _close();
            unawaited(
              navigator.push(
                FindFriendsPage.route(
                  initialQuery: person.fullName,
                  initialUserId: person.userId,
                ),
              ),
            );
          },
        ),
      for (final teacher in state.teachers.results)
        SearchSheetHit(
          kind: l10n.searchTagTeacher,
          title: teacher.name,
          onTap: () {
            widget.scheduleBloc.add(TeacherScheduleRequested(teacher: teacher));
            _commit(teacher.name);
            _close();
            router.go('/schedule');
          },
        ),
      for (final group in state.groups.results)
        SearchSheetHit(
          kind: l10n.searchTagGroup,
          title: group.name,
          onTap: () {
            widget.scheduleBloc.add(ScheduleRequested(group: group));
            _commit(group.name);
            _close();
            router.go('/schedule');
          },
        ),
      for (final post in state.posts)
        SearchSheetHit(
          kind: l10n.searchTagPost,
          title: post.title,
          subtitle: post.authorName,
          onTap: () {
            _commit(post.title);
            _close();
            router.go(
              Uri(
                path: '/services/people/group-space',
                queryParameters: {'post': post.id},
              ).toString(),
            );
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: widget.bloc,
      builder: (context, state) {
        final hits = _hits(context);
        final loading = state.status == SearchStatus.loading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchField(
              key: const ValueKey('search-sheet-field'),
              controller: _controller,
              autofocus: true,
              height: 52,
              onCanvas: true,
              hintText: l10n.searchSheetPlaceholder,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) _commit(value.trim());
              },
            ),
            if (_query.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sectionGap),
              AppListGroup(
                key: const ValueKey('search-sheet-results'),
                children: [
                  for (final hit in hits) SearchSheetRow(hit: hit),
                  if (hits.isEmpty && loading)
                    const AppSkeletonGroup(
                      child: Column(
                        children: [
                          AppSkeletonRow(showTrailing: false),
                          AppSkeletonRow(showTrailing: false),
                        ],
                      ),
                    ),
                  if (hits.isEmpty && !loading)
                    state.status == SearchStatus.failure
                        ? AppErrorState(
                            title: l10n.searchFailed,
                            message: l10n.tryAgain,
                            primaryLabel: l10n.retry,
                            footnote: null,
                            onPrimary: () => widget.bloc.add(
                              SearchQueryChanged(searchQuery: _query),
                            ),
                          )
                        : Padding(
                            key: const ValueKey('search-sheet-empty'),
                            padding: const EdgeInsets.all(AppSpacing.xlg),
                            child: Text(
                              l10n.searchSheetNoResults,
                              textAlign: TextAlign.center,
                              style: AppText.body.copyWith(color: colors.muted),
                            ),
                          ),
                ],
              ),
            ],
            if (state.searchHisoty.isNotEmpty) ...[
              AppOverline(l10n.searchRecent, topPadding: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final recent in state.searchHisoty)
                    SearchRecentPill(
                      label: recent,
                      onTap: () => _setQuery(recent),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 200),
          ],
        );
      },
    );
  }
}
