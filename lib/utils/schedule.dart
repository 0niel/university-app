import 'dart:convert';
import 'package:rtu_mirea_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:rtu_mirea_app/models/lesson.dart';

class Schedule {
  dynamic scheduleData;

  Future<void> request(String groupName) async {
    final response =
        await http.get(Uri.parse(kScheduleApiUrl + '$groupName/full_schedule'));

    if (response.statusCode == 200) {
      scheduleData = json.decode(response.body)['schedule'];
      print(scheduleData);
    } else {
      print(response.statusCode);
    }
  }

  List<List<Lesson>> getWeekLessons(int week) {
    List<List<Lesson>> weekLessonsList = [];

    for (int dayOfWeek = 1; dayOfWeek <= 6; dayOfWeek++) {
      var lessons = scheduleData[dayOfWeek.toString()]['lessons'];
      List<Lesson> dayLessons = [];
      for (var lesson in lessons) {
        for (int i = 0; i < lesson.length; i++) {
          if (lesson[i]['weeks'].contains(week)) {
            dayLessons.add(
              Lesson(
                name: lesson[i]['name'],
                teacher: lesson[i]['teacher'],
                room: lesson[i]['room'],
                timeStart: lesson[i]['time'],
                timeEnd: '',
                type: lesson[i]['type'],
              ),
            );
          }
        }
      }
      weekLessonsList.add(dayLessons);
    }

    return weekLessonsList;
  }
}
