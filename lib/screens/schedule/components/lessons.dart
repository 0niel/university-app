import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/models/lesson.dart';

class LessonsWidget extends StatelessWidget {
  final Lesson _lesson;

  const LessonsWidget(this._lesson);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(height: 30),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: _lesson.timeStart + "\n",
              style: TextStyle(
                color: Color(0xFF212525),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: _lesson.timeEnd,
              style: TextStyle(color: Color(0xFFBCC1CD), fontSize: 16),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 80,
        child: VerticalDivider(
          color: Color(0xFFFAF9F9),
          thickness: 2,
          width: 50,
        ),
      ),
      Flexible(
        child: RichText(
          maxLines: 10,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: _lesson.name + "\n",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: _lesson.type + " в " + _lesson.room,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
