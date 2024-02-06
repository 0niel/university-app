import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
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
      initialPage: Calendar.getPageIndex(Calendar.getNowWithoutTime()),
    );
  }

  @override
  void dispose() {
    _schedulePageController.dispose();
    super.dispose();
  }

  String get _getAppBarTitle {
    final schedule = context.read<ScheduleBloc>().state.selectedSchedule;

    if (schedule is SelectedGroupSchedule) {
      return 'Расписание ${schedule.group.name}';
    } else if (schedule is SelectedTeacherSchedule) {
      var splittedName = schedule.teacher.name.split(' ');
      if (splittedName.length == 3) {
        return 'Расписание ${splittedName[0]} ${splittedName[1][0]}. ${splittedName[2][0]}.';
      } else if (splittedName.length == 2) {
        return 'Расписание ${splittedName[0]} ${splittedName[1][0]}.';
      } else {
        return 'Расписание ${schedule.teacher.name}';
      }
    } else if (schedule is SelectedClassroomSchedule) {
      return 'Расписание ${schedule.classroom.name}';
    } else {
      return 'Расписание';
    }
  }

  Future<String> getScheduleImage(String groupName, String type) async {
    final dio = Dio();
    final response = await dio.get(
        'https://schedule-of.mirea.ru/schedule/api/search?limit=15&match=$groupName');

    if (response.statusCode == 200) {
      final data = response.data;
      final groupList = data['data'];

      if (groupList.isNotEmpty) {
        final groupId = groupList[0]['id'];

        return 'https://schedule-of.mirea.ru/Schedule/GenericSchedule?type=$type&id=$groupId&asImage=True';
      } else {
        throw Exception('Group not found');
      }
    } else {
      throw Exception('Failed to load group list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state.status == ScheduleStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка при загрузке расписания'),
            ),
          );
        }
      },
      buildWhen: (previous, current) =>
          current.status != ScheduleStatus.failure &&
          current.selectedSchedule != null,
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
        } else if (state.status == ScheduleStatus.failure &&
            state.selectedSchedule == null) {
          return LoadingErrorMessage(onTap: () {
            context.go('/schedule/search');
          });
        } else if (state.selectedSchedule != null) {
          final appBar = SliverAppBar(
            pinned: false,
            title: Text(
              _getAppBarTitle,
            ),
            actions: [
              SizedBox(
                width: 60,
                height: 60,
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.ellipsis,
                    color: AppTheme.colorsOf(context).active,
                  ),
                  onPressed: () {
                    BottomModalSheet.show(
                      context,
                      child: const SettingsMenu(),
                      title: 'Управление расписанием',
                      description:
                          'Редактирование сохраненных расписаний и добавление новых, а также настройки отображения расписания.',
                      backgroundColor: AppTheme.colorsOf(context).background03,
                    );
                  },
                ),
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: StoriesView(),
            ),
          );
          final body = NestedScrollView(
            headerSliverBuilder: (_, __) => [
              appBar,
              SliverToBoxAdapter(
                child: Calendar(
                  pageViewController: _schedulePageController,
                  schedule: state.selectedSchedule?.schedule ?? [],
                  comments: state.comments,
                  showCommentsIndicators: state.showCommentsIndicators,
                ),
              ),
            ],
            body: EventsPageView(
              controller: _schedulePageController,
              itemBuilder: (context, index) {
                final day =
                    Calendar.firstCalendarDay.add(Duration(days: index));
                final schedules = Calendar.getSchedulePartsByDay(
                  schedule: state.selectedSchedule?.schedule ?? [],
                  day: day,
                );

                final holiday = schedules.firstWhereOrNull(
                  (element) => element is HolidaySchedulePart,
                );

                if (holiday != null) {
                  return HolidayPage(
                      title: (holiday as HolidaySchedulePart).title);
                }

                if (day.weekday == DateTime.sunday) {
                  return const HolidayPage(title: 'Выходной');
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
                          child: LessonCard(
                            lesson: lesson,
                            onTap: (lesson) {
                              context.go(
                                '/schedule/details',
                                extra: (lesson, day),
                              );
                            },
                          ),
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
                          child: LessonCard(
                            lesson: e,
                            onTap: (lesson) {
                              context.go(
                                '/schedule/details',
                                extra: (lesson, day),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          );

          final selectedSchedule = state.selectedSchedule;

          String name;
          String type;
          switch (selectedSchedule.runtimeType) {
            case SelectedGroupSchedule:
              name = (selectedSchedule as SelectedGroupSchedule).group.name;
              type = '1';
              break;
            case SelectedTeacherSchedule:
              name = (selectedSchedule as SelectedTeacherSchedule).teacher.name;
              type = '2';
              break;
            case SelectedClassroomSchedule:
              name = (selectedSchedule as SelectedClassroomSchedule)
                  .classroom
                  .name;
              type = '3';
              break;
            default:
              name = '';
              type = '';
          }

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (_, __) => [
                appBar,
              ],
              body: FutureBuilder(
                future: getScheduleImage(name, type),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return PhotoViewGallery(
                        backgroundDecoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        pageOptions: [
                          PhotoViewGalleryPageOptions(
                            imageProvider: ExtendedImage.network(
                              snapshot.data as String,
                              fit: BoxFit.cover,
                              cache: true,
                            ).image,
                            initialScale:
                                PhotoViewComputedScale.contained * 1.0,
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: PhotoViewComputedScale.covered * 1.8,
                          ),
                        ],
                      );
                    }
                    return Container();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Упс!',
                            style: AppTextStyle.h1.copyWith(
                              color: AppTheme.colorsOf(context).primary,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Не удалось загрузить расписание',
                            style: AppTextStyle.body.copyWith(
                              color: AppTheme.colorsOf(context).primary,
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppTheme.colors.primary,
                        strokeWidth: 5,
                      ),
                    );
                  }
                },
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
