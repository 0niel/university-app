import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../bloc/search_bloc.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        scheduleRepository: context.read<ScheduleRepository>(),
      )..add(const SearchQueryChanged()),
      child: Scaffold(
        backgroundColor: AppTheme.colors.background01,
        appBar: AppBar(
          backgroundColor: AppTheme.colors.background01,
          elevation: 0,
          title: const Text(
            "Поиск",
          ),
        ),
        body: const SafeArea(
          child: Padding(padding: EdgeInsets.all(16), child: SearchView()),
        ),
      ),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => context
          .read<SearchBloc>()
          .add(SearchQueryChanged(searchQuery: _controller.text)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Произошла ошибка")),
            );
        }
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SearchTextField(
                    key: const Key('searchPage_searchTextField'),
                    controller: _controller,
                  ),
                  ...state.groups.results.isEmpty
                      ? []
                      : [
                          const SearchHeadlineText(
                            headerText: "Группы",
                          ),
                          ...state.groups.results.map<Widget>(
                            (group) => SearchResultItem(
                              name: group.name,
                              type: ItemType.group,
                              onPressed: () => {
                                context
                                    .read<ScheduleBloc>()
                                    .add(ScheduleRequested(group: group)),
                                context.go(
                                  '/schedule',
                                ),
                              },
                            ),
                          ),
                        ],
                  ...state.teachers.results.isEmpty
                      ? []
                      : [
                          const SearchHeadlineText(
                            headerText: "Преподаватели",
                          ),
                          ...state.teachers.results.map<Widget>(
                            (teacher) => SearchResultItem(
                              name: teacher.name,
                              type: ItemType.teacher,
                              onPressed: () => {
                                context.read<ScheduleBloc>().add(
                                    TeacherScheduleRequested(teacher: teacher)),
                                context.go(
                                  '/schedule',
                                ),
                              },
                            ),
                          ),
                        ],
                  ...state.classrooms.results.isEmpty
                      ? []
                      : [
                          const SearchHeadlineText(
                            headerText: "Аудитории",
                          ),
                          ...state.classrooms.results.map<Widget>(
                            (classroom) => SearchResultItem(
                              name:
                                  '${classroom.name}${classroom.campus != null ? ' (${classroom.campus?.shortName ?? classroom.campus?.name})' : ''}',
                              type: ItemType.classroom,
                              onPressed: () => {
                                context.read<ScheduleBloc>().add(
                                    ClassroomScheduleRequested(
                                        classroom: classroom)),
                                context.go(
                                  '/schedule',
                                ),
                              },
                            ),
                          ),
                        ],
                  if (state.status == SearchStatus.loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
