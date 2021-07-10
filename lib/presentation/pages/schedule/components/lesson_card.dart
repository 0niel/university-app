import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson _lesson;

  const LessonCard(this._lesson);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 18,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "11:35\n",
                  style: TextStyle(
                    color: Color(0xFF212525),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "13:00",
                  style: TextStyle(color: Color(0xFFBCC1CD), fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 1,
              height: 165,
              color: LightThemeColors.grey100,
            ),
          ),
        ),
        Expanded(
          flex: 76,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: LightThemeColors.grey800),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                      16.0), //                 <--- border radius here
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Практика".toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Математический анализ",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 15)),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Text('в аудитории А-419')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.face),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Text('преподаватель Зуев А. С.')
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
