import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';
import 'package:rtu_mirea_app/domain/entities/lesson_app_info.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/widgets/keyboard_positioned.dart';

class LessonCardInfoModal extends StatelessWidget {
  LessonCardInfoModal({required this.lesson, required this.lessonAppInfo});

  final Lesson lesson;
  final LessonAppInfo lessonAppInfo;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = lessonAppInfo.note;

    return GestureDetector(
      onTap: () {
        lessonAppInfo.note = controller.text;
        BlocProvider.of<ScheduleBloc>(context).add(
            ScheduleUpdateLessonsInfoEvent(lessonAppInfo: LessonAppInfo(
              id: lessonAppInfo.id,
              note: controller.text,
              lessonCode: lessonAppInfo.lessonCode
            )));
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: KeyboardPositioned(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      lesson.name + ", " + '${lesson.rooms.join(', ')}',
                      style: DarkTextTheme.h5,
                    )
                  ),
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                  "Заметки к паре",
                  style: DarkTextTheme.captionL
                      .copyWith(color: DarkThemeColors.deactive),
                  textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Введите ваши заметки к паре",
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onEditingComplete: () => print("on editing complete"),
                      onChanged: (changed) => print("on changed: $changed"),
                      onSubmitted: (complete) => print("on submitted $complete"),
                      controller: controller,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: DarkThemeColors.background01,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DarkThemeColors.secondary,
                DarkThemeColors.deactive,
                DarkThemeColors.background01
              ],
              begin: Alignment(-1, -1),
              end: Alignment(-1, 1),
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}