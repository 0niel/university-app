import 'package:schedule/schedule.dart';

final holidays = <SchedulePart>[
  HolidaySchedulePart(
    title: 'Новогодние праздники',
    dates: [
      DateTime(2023, 12, 31),
      DateTime(2024),
      DateTime(2024, 1, 2),
      DateTime(2024, 1, 3),
      DateTime(2024, 1, 4),
      DateTime(2024, 1, 5),
      DateTime(2024, 1, 6),
      DateTime(2024, 1, 7),
      DateTime(2024, 1, 8),
    ],
  ),
  HolidaySchedulePart(
    title: 'Зимние каникулы',
    dates: [
      DateTime(2023, 2, 2),
      DateTime(2023, 2, 3),
      DateTime(2023, 2, 4),
      DateTime(2023, 2, 5),
      DateTime(2023, 2, 6),
      DateTime(2023, 2, 7),
      DateTime(2023, 2, 8),
    ],
  ),
  HolidaySchedulePart(
    title: 'День защитника Отечества',
    dates: [
      DateTime(2024, 2, 23),
    ],
  ),
  HolidaySchedulePart(
    title: 'Международный женский день',
    dates: [
      DateTime(2024, 3, 8),
    ],
  ),
  HolidaySchedulePart(
    title: 'Праздник Весны и Труда',
    dates: [
      DateTime(2024, 5),
    ],
  ),
  HolidaySchedulePart(
    title: 'День Победы',
    dates: [
      DateTime(2024, 5, 9),
    ],
  ),
  HolidaySchedulePart(
    title: 'День России',
    dates: [
      DateTime(2024, 6, 12),
    ],
  ),
  HolidaySchedulePart(
    title: 'День народного единства',
    dates: [
      DateTime(2024, 11, 4),
    ],
  ),
];
