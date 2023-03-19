import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/pages/map/cubit/rooms_cubit.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/app_settings_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_tab_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/container_label.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TextBlockWithLabel extends StatelessWidget {
  const TextBlockWithLabel({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(children: [
          ContainerLabel(label: label),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyle.titleM,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
        ]));
  }
}

class RoomDataPage extends StatefulWidget {
  const RoomDataPage({Key? key, required this.roomName}) : super(key: key);

  final String roomName;

  @override
  State<RoomDataPage> createState() => _RoomDataPageState();
}

class _RoomDataPageState extends State<RoomDataPage> {
  final ValueNotifier<int> _tabValueNotifier = ValueNotifier(0);

  Widget _buildTabButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PrimaryTabButton(
            text: 'Информация',
            itemIndex: 0,
            notifier: _tabValueNotifier,
            onClick: () {
              context.read<NewsBloc>().add(NewsLoadEvent(
                  refresh: true, isImportant: _tabValueNotifier.value == 1));
            },
          ),
          PrimaryTabButton(
            text: 'Расписание',
            itemIndex: 1,
            notifier: _tabValueNotifier,
            onClick: () {
              context.read<NewsBloc>().add(
                    NewsLoadEvent(
                      refresh: true,
                      isImportant: _tabValueNotifier.value == 1,
                      tag: "все",
                    ),
                  );
            },
          )
        ],
      ),
    );
  }

  Map<String, dynamic>? getCurrentEvent(List<Map<String, dynamic>> schedule) {
    final now = DateTime.now();

    final currentEvent = schedule.firstWhere(
      (element) {
        final timeStart = element['calls']['time_start'].toString();
        final timeEnd = element['calls']['time_end'].toString();

        final timeStartHour = int.parse(timeStart.split(":")[0]);
        final timeStartMinute = int.parse(timeStart.split(":")[1]);

        final timeEndHour = int.parse(timeEnd.split(":")[0]);
        final timeEndMinute = int.parse(timeEnd.split(":")[1]);

        final timeStartDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          timeStartHour,
          timeStartMinute,
        );

        final timeEndDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          timeEndHour,
          timeEndMinute,
        );

        return now.isAfter(timeStartDateTime) && now.isBefore(timeEndDateTime);
      },
      orElse: () => {},
    );

    return currentEvent == {} ? null : currentEvent;
  }

  Widget _buildInfo(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: ListView(
        children: [
          TextBlockWithLabel(
            label: 'Назначение',
            text: data['purpose'],
          ),
          TextBlockWithLabel(
            label: 'Загруженность',
            text: '${data['workload']}%',
          ),
          TextBlockWithLabel(
            label: 'Статус',
            text: data['status'],
          ),
          if (data['status'] == 'Занята')
            TextBlockWithLabel(
                label: 'Мероприятие',
                text: getCurrentEvent(data['schedule']) == null
                    ? 'Нет'
                    : getCurrentEvent(data['schedule'])!['discipline']['name']),
          if (data['status'] == 'Занята')
            TextBlockWithLabel(
              label: 'Ответственный',
              text: getCurrentEvent(data['schedule']) == null
                  ? 'Нет'
                  : (getCurrentEvent(data['schedule'])!['teachers']
                          as List<Map<String, dynamic>>)
                      .map((e) => e['name'])
                      .join(', '),
            ),
        ],
      ),
    );
  }

//  {
//     "id": 74663,
//     "lesson_type": {
//       "name": "пр",
//       "id": 2
//     },
//     "discipline": {
//       "name": "Моделирование сред и разработка приложений виртуальной и дополненной реальности",
//       "id": 762
//     },
//     "teachers": [
//       {
//         "id": 549,
//         "name": "Ермаков С.Р."
//       }
//     ],
//     "room": {
//       "name": "А-422",
//       "campus_id": 3,
//       "id": 150,
//       "campus": {
//         "name": "Проспект Вернадского, д.78",
//         "short_name": "В-78",
//         "id": 3
//       }
//     },
//     "calls": {
//       "num": 5,
//       "time_start": "16:20:00",
//       "time_end": "17:50:00",
//       "id": 5
//     },
//     "weekday": 6,
//     "subgroup": null,
//     "weeks": [
//       1,
//       3,
//       5,
//       7,
//       9,
//       11,
//       13,
//       15
//     ]
//   },
//   {
//     "id": 74664,
//     "lesson_type": {
//       "name": "пр",
//       "id": 2
//     },
//     "discipline": {
//       "name": "Моделирование сред и разработка приложений виртуальной и дополненной реальности",
//       "id": 762
//     },
//     "teachers": [
//       {
//         "id": 549,
//         "name": "Ермаков С.Р."
//       }
//     ],
//     "room": {
//       "name": "А-422",
//       "campus_id": 3,
//       "id": 150,
//       "campus": {
//         "name": "Проспект Вернадского, д.78",
//         "short_name": "В-78",
//         "id": 3
//       }
//     },
//     "calls": {
//       "num": 5,
//       "time_start": "16:20:00",
//       "time_end": "17:50:00",
//       "id": 5
//     },
//     "weekday": 6,
//     "subgroup": null,
//     "weeks": [
//       2,
//       4,
//       6,
//       8,
//       10,
//       12,
//       14,
//       16,
//       18
//     ]
//   },

  String _getWeekdayByNum(int weekday) {
    final weekdays = {
      1: 'Понедельник',
      2: 'Вторник',
      3: 'Среда',
      4: 'Четверг',
      5: 'Пятница',
      6: 'Суббота',
    };
    return weekdays[weekday] ?? 'Ошибка';
  }

  static Color getColorByType(String lessonType) {
    if (lessonType.contains('лк') || lessonType.contains('лек')) {
      return AppTheme.colors.colorful01;
    } else if (lessonType.contains('лб') || lessonType.contains('лаб')) {
      return AppTheme.colors.colorful07;
    } else if (lessonType.contains('с/р')) {
      return AppTheme.colors.colorful02;
    } else {
      return AppTheme.colors.colorful03;
    }
  }

  Widget _buildSchedule(Map<String, dynamic> data) {
    final schedule = data['schedule'];
    final now = DateTime.now();

    return ListView.separated(
      itemCount: schedule.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = schedule[index];

        final timeStart = item['calls']['time_start'].toString();
        final timeEnd = item['calls']['time_end'].toString();

        final disciplineName = item['discipline']['name'];
        final teachers = List<Map<String, dynamic>>.from(item['teachers'])
            .map((e) => e['name'])
            .join(', ');
        final lessonType = item['lesson_type']['name'];
        final weeks = item['weeks'].toString();
        final weekday = _getWeekdayByNum(item['weekday']);

        return Card(
          shadowColor: Colors.transparent,
          color: AppTheme.colors.background03,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$weekday, $timeStart - $timeEnd',
                        style: AppTextStyle.titleS,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: getColorByType(lessonType)),
                        height: 24,
                        // width: 10 * 7,
                        child: Text(lessonType, style: AppTextStyle.chip),
                      ),
                    ]),
                const SizedBox(height: 12),
                Text(disciplineName, style: AppTextStyle.titleM),
                const SizedBox(height: 12),
                Text(teachers,
                    style: AppTextStyle.titleS.copyWith(
                      color: AppTheme.colors.deactive,
                    )),
                const SizedBox(height: 8),
                Text(weeks,
                    style: AppTextStyle.titleS.copyWith(
                      color: AppTheme.colors.deactive,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        title: Text(widget.roomName),
      ),
      body: Column(
        children: [
          _buildTabButtons(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<RoomsCubit, RoomsState>(
                builder: (context, state) {
                  return state.maybeMap(
                    loading: (value) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    notFound: (value) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Данные аудитории не найдены",
                            style: AppTextStyle.titleM,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Попробуйте изменить название аудитории",
                            style: AppTextStyle.bodyL,
                          ),
                        ],
                      ),
                    ),
                    error: (value) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Произошла ошибка при загрузке данных",
                            style: AppTextStyle.titleM,
                          ),
                          const SizedBox(height: 12),
                          PrimaryButton(
                            onClick: () {
                              context
                                  .read<RoomsCubit>()
                                  .loadRoomData(widget.roomName);
                            },
                            text: 'Повторить',
                          ),
                        ],
                      ),
                    ),
                    loaded: (roomStateValue) {
                      if (roomStateValue.data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Данные аудитории не найдены",
                                style: AppTextStyle.titleM,
                              ),
                              const SizedBox(height: 12),
                              PrimaryButton(
                                onClick: () {
                                  context
                                      .read<RoomsCubit>()
                                      .loadRoomData(widget.roomName);
                                },
                                text: 'Повторить',
                              ),
                            ],
                          ),
                        );
                      }
                      return ValueListenableBuilder(
                        valueListenable: _tabValueNotifier,
                        builder: (context, value, child) {
                          if (value == 0) {
                            return _buildInfo(roomStateValue.data);
                          } else {
                            return _buildSchedule(roomStateValue.data);
                          }
                        },
                      );
                    },
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
