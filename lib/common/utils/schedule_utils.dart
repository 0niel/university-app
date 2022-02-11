/// [ScheduleUtils] - provides different functions for working with MIREA schedule data
class ScheduleUtils {
  static Map<String, int> get collegeTimesStart => const {
        "08:45": 1,
        "10:30": 2,
        "12:40": 3,
        "14:20": 4,
      };

  static Map<String, int> get collegeTimesEnd => const {
        "10:15": 1,
        "12:00": 2,
        "14:10": 3,
        "15:50": 4,
      };

  static Map<String, int> get universityTimesStart => const {
        "9:00": 1,
        "10:40": 2,
        "12:40": 3,
        "14:20": 4,
        "16:20": 5,
        "18:00": 6,
        "19:40": 7,
        "18:30": 7,
        "20:10": 8,
      };

  static Map<String, int> get universityTimesEnd => const {
        "10:30": 1,
        "12:10": 2,
        "14:10": 3,
        "15:50": 4,
        "17:50": 5,
        "19:30": 6,
        "21:00": 7,
        "20:00": 7,
        "21:40": 8,
      };

  static bool isCollegeGroup(String group) {
    return group[0] == 'Щ';
  }
}
