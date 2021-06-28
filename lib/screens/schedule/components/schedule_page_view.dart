import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/utils/calendar.dart';

class SchedulePageView extends StatefulWidget {
  @override
  _SchedulePageViewState createState() => _SchedulePageViewState();
}

class _SchedulePageViewState extends State<SchedulePageView> {
  int _currentWeek;
  List<int> _currentWeekDays;
  int _currentPage = 0;

  List<Map<String, String>> _daysData;

  AnimatedContainer dayOfWeekButton({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 55,
      width: 47.5,
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: _daysData[index]['day_of_week'] + "\n",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: _currentPage == index ? Colors.white : Color(0xFFBCC1CD),
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: _daysData[index]['num'],
              style: TextStyle(
                  color: _currentPage == index ? Colors.white : Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // initialize data
    _currentWeek = Calendar.getCurrentWeek();
    _currentWeekDays = Calendar.getDaysInWeek(_currentWeek);
    _daysData = [
      {'day_of_week': 'ПН', 'num': _currentWeekDays[0].toString()},
      {'day_of_week': 'ВТ', 'num': _currentWeekDays[1].toString()},
      {'day_of_week': 'СР', 'num': _currentWeekDays[2].toString()},
      {'day_of_week': 'ЧТ', 'num': _currentWeekDays[3].toString()},
      {'day_of_week': 'ПТ', 'num': _currentWeekDays[4].toString()},
      {'day_of_week': 'СБ', 'num': _currentWeekDays[5].toString()},
    ];
  }

  List _buildPageView() {
    return [
      Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _daysData.length,
            (index) => dayOfWeekButton(index: index),
          ),
        ),
      ),
      Divider(height: 1, color: Colors.black.withOpacity(0.1)),
      Container(
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          itemCount: 6, // пн-пт
          itemBuilder: (context, index) => Center(
            child: Text('$index hello!'),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _daysData.length,
              (index) => dayOfWeekButton(index: index),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.black.withOpacity(0.1)),
        Expanded(
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: 6, // пн-пт
            itemBuilder: (context, index) => Center(
              child: Text('$index hello!'),
            ),
          ),
        )
      ],
    );
  }
}
