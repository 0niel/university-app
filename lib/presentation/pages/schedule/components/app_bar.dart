import 'package:flutter/material.dart';

class ScheduleAppBar extends StatelessWidget {
  const ScheduleAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FA),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "24",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Text(
                  "Среда\nЯнварь 2021",
                  style: TextStyle(color: Color(0xFFBCC1CD), fontSize: 16),
                ),
              ],
            ),
            ButtonTheme(
              padding: EdgeInsets.all(0.0),
              child: ButtonBar(children: <Widget>[
                TextButton(
                  child: Text(
                    '12 неделя',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(116, 45)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColorLight.withOpacity(0.9)),
                  ),
                  onPressed: () {
                    () => {};
                  },
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
