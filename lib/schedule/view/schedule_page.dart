import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/stories/view/stories_view.dart';
import 'package:university_app_server_api/client.dart';

import '../widgets/widgets.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final PageController _schedulePageController;

  @override
  void initState() {
    super.initState();
    _schedulePageController = PageController(
      initialPage: Calendar.getPageIndex(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _schedulePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state.selectedSchedule == null &&
            state.status != ScheduleStatus.loading) {
          return NoSelectedScheduleMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.status == ScheduleStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == ScheduleStatus.failure) {
          return LoadingErrorMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.status == ScheduleStatus.loaded) {
          return Scaffold(
            backgroundColor: AppTheme.colors.background01,
            body: NestedScrollView(
              headerSliverBuilder: (_, __) => [
                SliverAppBar(
                  pinned: false,
                  title: const Text(
                    'Расписание',
                  ),
                  actions: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.ellipsis,
                          color: AppTheme.colors.active,
                        ),
                        onPressed: () {
                          BottomModalSheet.show(
                            context,
                            child: const SettingsMenu(),
                            title: 'Управление расписанием',
                            description:
                                'Редактирование сохраненных расписаний и добавление новых, а также настройки отображения расписания.',
                            backgroundColor: AppTheme.colors.background03,
                          );
                        },
                      ),
                    ),
                  ],
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(80),
                    child: StoriesView(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Calendar(
                    pageViewController: _schedulePageController,
                    schedule: state.selectedSchedule?.schedule ?? [],
                  ),
                ),
              ],
              body: EventsPageView(
                controller: _schedulePageController,
                itemBuilder: (context, index) {
                  final schedules = Calendar.getSchedulePartsByDay(
                    schedule: state.selectedSchedule?.schedule ?? [],
                    day: Calendar.firstCalendarDay.add(Duration(days: index)),
                  );

                  final holiday = schedules.firstWhereOrNull(
                    (element) => element is HolidaySchedulePart,
                  );

                  if (holiday != null) {
                    return HolidayPage(
                        title: (holiday as HolidaySchedulePart).title);
                  }

                  final lessons =
                      schedules.whereType<LessonSchedulePart>().toList();

                  if (state.showEmptyLessons) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final lesson = lessons.firstWhereOrNull(
                          (element) => element.lessonBells.number == index + 1,
                        );

                        if (lesson != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: LessonCard(lesson: lesson),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: EmptyLessonCard(lessonNumber: index + 1),
                        );
                      },
                    );
                  }

                  return ListView(
                    children: schedules
                        .whereType<LessonSchedulePart>()
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: LessonCard(lesson: e),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          );
        }

        return Container();
      },
    );
  }
}
