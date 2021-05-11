import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../constants.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text('Расписание'),
      actions: <Widget>[
        ButtonTheme(
          padding: new EdgeInsets.all(0.0),
          child: new ButtonBar(children: <Widget>[
            TextButton(
              child: Text(
                '12 неделя',
                style: TextStyle(color: Color(0xFFE0E2FF)),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                minimumSize: MaterialStateProperty.all<Size>(Size(116, 45)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
          ]),
        ),
      ],
    );
  }
}
