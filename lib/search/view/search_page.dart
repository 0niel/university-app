import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/search/widgets/search_history_item.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../bloc/search_bloc.dart';
import '../widgets/widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.query});

  final String? query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        scheduleRepository: context.read<ScheduleRepository>(),
      )..add(SearchQueryChanged(searchQuery: query ?? '')),
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<AppColors>()!.background01,
        appBar: AppBar(
          backgroundColor: Theme.of(context).extension<AppColors>()!.background01,
          elevation: 0,
          title: const Text(
            "Поиск",
          ),
        ),
        body: SafeArea(
          child: SearchView(
            query: query,
          ),
        ),
      ),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key, this.query});

  final String? query;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController _controller = TextEditingController(text: widget.query);

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => context.read<SearchBloc>().add(SearchQueryChanged(searchQuery: _controller.text)),
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessengerHelper.showMessage(
              context: context,
              title: 'Ошибка',
              subtitle: 'Не удалось выполнить поиск',
              isSuccess: false,
            );
          });
        }
      },
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchTextField(
                      key: const Key('searchPage_searchTextField'),
                      controller: _controller,
                    ),
                  ),
                  const SearchModeSelect(),
                  if (_controller.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._controller.text.isNotEmpty || state.searchHisoty.isEmpty
                              ? []
                              : [
                                  const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SearchHeadlineText(
                                        headerText: "История",
                                      ),
                                      ClearSearchHistoryButton(),
                                    ],
                                  ),
                                  ...state.searchHisoty.map(
                                    (e) => SearchHistoryItem(
                                      query: e,
                                      onPressed: (value) {
                                        _controller.text = value;
                                      },
                                      onClear: () {
                                        context.read<SearchBloc>().add(RemoveQueryFromSearchHistory(query: e));
                                      },
                                    ),
                                  ),
                                ],
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
                                        context.read<ScheduleBloc>().add(ScheduleRequested(group: group)),
                                        context.go(
                                          '/schedule',
                                        ),
                                        context.read<SearchBloc>().add(
                                              AddQueryToSearchHistory(query: group.name),
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
                                        context.read<ScheduleBloc>().add(TeacherScheduleRequested(teacher: teacher)),
                                        context.go(
                                          '/schedule',
                                        ),
                                        context.read<SearchBloc>().add(
                                              AddQueryToSearchHistory(query: teacher.name),
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
                                        context
                                            .read<ScheduleBloc>()
                                            .add(ClassroomScheduleRequested(classroom: classroom)),
                                        context.go(
                                          '/schedule',
                                        ),
                                        context.read<SearchBloc>().add(
                                              AddQueryToSearchHistory(query: classroom.name),
                                            ),
                                      },
                                    ),
                                  ),
                                ],
                          if (state.status == SearchStatus.loading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.hugeicons.search.svg(
                              color: Theme.of(context).extension<AppColors>()!.active,
                              width: 64,
                              height: 64,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Введите запрос для поиска", style: AppTextStyle.body),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
