import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/domain/entities/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson _lesson;

  const LessonCard(this._lesson);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: LightThemeColors.grey100.withOpacity(0.3)),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "9:00",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 7),
                ),
                Text(
                  "10:30",
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
          Container(
            height: 100,
            alignment: Alignment.center,
            child: VerticalDivider(),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        child: Text(
                          "Структуры и алгоритмы обработки данных",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            'А-419',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.face),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Text(
                            'Зуев А. С.',
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: LightThemeColors.primary201),
                  height: 25,
                  width: 40,
                  child:
                      Text("пр", style: Theme.of(context).textTheme.bodyText2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
