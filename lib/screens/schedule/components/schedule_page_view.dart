import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/screens/schedule/components/schedule_container.dart';
import '../../../constants.dart';

class SchedulePageView extends StatefulWidget {
  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  int currentPage = 0;

  List<Map<String, String>> daysData = [
    {'day_of_week': 'ПН', 'num': '12'},
    {'day_of_week': 'ВТ', 'num': '13'},
    {'day_of_week': 'СР', 'num': '14'},
    {'day_of_week': 'ЧТ', 'num': '15'},
    {'day_of_week': 'ПТ', 'num': '16'},
    {'day_of_week': 'СБ', 'num': '17'},
  ];

  List<Widget> scheduleContainers = [
    ScheduleContainer(),
    ScheduleContainer(),
    ScheduleContainer(),
  ];

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(
        vertical: 12,
        // horizontal: MediaQuery.of(context).size.width / 20,
      ),
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 55,
      width: 47.5,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: daysData[index]['day_of_week'] + "\n",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: currentPage == index ? Colors.white : Color(0xFFBCC1CD),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: daysData[index]['num'],
              style: TextStyle(
                  color: currentPage == index ? Colors.white : Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              daysData.length,
              (index) => buildDot(index: index),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: daysData.length,
              itemBuilder: (context, index) => ScheduleContainer(),
            ),
          ),
        ),
      ],
    );
  }
}
