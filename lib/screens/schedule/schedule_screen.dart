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
      title: Text('Dashboard'),
      actions: <Widget>[
        TextButton(
          child: Text(
            '12 неделя',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
              padding:
                  MaterialStateProperty.all(EdgeInsets.fromLTRB(30, 0, 30, 0))),
          onPressed: () => {},
        )
      ],
    );
  }
}
