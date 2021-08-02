import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class LessonCard extends StatelessWidget {
  final String name;
  final String teacher;
  final String room;
  final String type;
  final String timeStart;
  final String timeEnd;

  const LessonCard({
    Key? key,
    required this.name,
    required this.teacher,
    required this.room,
    required this.type,
    required this.timeStart,
    required this.timeEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      color: DarkThemeColors.background03,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: 75),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeStart,
                    style: DarkTextTheme.bodyBold.copyWith(
                        color: DarkThemeColors.deactive, fontSize: 12),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    timeEnd,
                    style: DarkTextTheme.bodyBold.copyWith(
                        color: DarkThemeColors.deactive, fontSize: 12),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name, $room',
                    style: DarkTextTheme.titleM,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    teacher,
                    style: DarkTextTheme.body
                        .copyWith(color: DarkThemeColors.deactive),
                  ),
                ],
              ),
            ),
            Container(),
            Container(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: DarkThemeColors.colorful01),
                height: 24,
                // width: 10 * 7,
                child: Text(type, style: DarkTextTheme.chip),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
