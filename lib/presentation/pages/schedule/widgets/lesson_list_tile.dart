import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';

class LessonListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
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
      title: Text('Математическая логика и теория алгоритмов'),
      subtitle: Text('Зуева А. С..'),
      trailing: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DarkThemeColors.primary),
            height: 25,
            width: 10 * 7,
            child: Text("пр", style: Theme.of(context).textTheme.bodyText2),
          ),
          const SizedBox(width: 8),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: DarkThemeColors.primary),
            height: 25,
            width: 10 * 7,
            child:
                Text("ИВЦ-102", style: Theme.of(context).textTheme.bodyText2),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
