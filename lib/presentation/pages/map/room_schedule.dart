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
    return Column(children: [
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
    ]);
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
    return ListView(
      children: [
        TextBlockWithLabel(
          label: 'Назначение',
          text: data['purpose'],
        ),
        TextBlockWithLabel(
          label: 'Загруженность',
          text: data['workload'] + '%',
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
                      .join(', ')),
      ],
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

  Widget _buildSchedule(Map<String, dynamic> data) {
    final schedule = data['schedule'];
    final now = DateTime.now();

    return ListView.builder(
      itemCount: schedule.length,
      itemBuilder: (context, index) {
        final item = schedule[index];

        final timeStart = item['calls']['time_start'].toString();
        final timeEnd = item['calls']['time_end'].toString();

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

        final isCurrentEvent =
            now.isAfter(timeStartDateTime) && now.isBefore(timeEndDateTime);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isCurrentEvent
                ? AppTheme.colors.colorful01
                : AppTheme.colors.background02,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${timeStart} - $timeEnd',
                style: AppTextStyle.bodyL.copyWith(
                  color: isCurrentEvent
                      ? AppTheme.colors.background02
                      : AppTheme.colors.white,
                ),
              ),
              Text(
                '${item['discipline']['name']}',
                style: AppTextStyle.bodyL.copyWith(
                  color: isCurrentEvent
                      ? AppTheme.colors.background02
                      : AppTheme.colors.white,
                ),
              ),
              Text(
                (item['teachers'] as List<Map<String, dynamic>>)
                    .map((e) => e['name'])
                    .join(', '),
                style: AppTextStyle.bodyL.copyWith(
                  color: isCurrentEvent
                      ? AppTheme.colors.background02
                      : AppTheme.colors.white,
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}
