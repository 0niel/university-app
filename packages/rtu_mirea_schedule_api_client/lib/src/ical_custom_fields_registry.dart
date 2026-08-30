import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';

class ICalCustomFieldsRegistry {
  static void register() {
    registerField('RDATE', (value, params, event, lastEvent) {
      try {
        final datesString = value.split(',');

        final dates = datesString.map((e) {
          final date = IcsDateTime(dt: e);

          return date;
        }).toList();

        lastEvent['RDATE'] = dates;

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-META-AUDITORIUM', (value, params, event, lastEvent) {
      try {
        final baseValue = params['NUMBER'] ?? value;
        final campus = params['CAMPUS'];
        final locationText = campus != null
            ? '$baseValue ($campus)'
            : baseValue;
        lastEvent['X-META-AUDITORIUM'] = <Object?>[
          ...?lastEvent['X-META-AUDITORIUM'] as Iterable?,
          locationText,
        ];
        lastEvent['X-META-AUDITORIUM-RAW'] = <Object?>[
          ...?lastEvent['X-META-AUDITORIUM-RAW'] as Iterable?,
          {
            'uid': params['ID'],
            'name': value,
            'number': params['NUMBER'],
            'campus': params['CAMPUS'],
            'type': params['TYPE'],
          },
        ];
        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-META-DISCIPLINE', (value, params, event, lastEvent) {
      try {
        lastEvent['X-META-DISCIPLINE'] = value;

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-META-GROUP', (value, params, event, lastEvent) {
      try {
        lastEvent['X-META-GROUP'] = <Object?>[
          ...?lastEvent['X-META-GROUP'] as Iterable?,
          value,
        ];
        lastEvent['X-META-GROUP-RAW'] = <Object?>[
          ...?lastEvent['X-META-GROUP-RAW'] as Iterable?,
          {'uid': params['ID'], 'name': value, 'type': params['TYPE']},
        ];

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-META-LESSON_TYPE', (value, params, event, lastEvent) {
      try {
        lastEvent['X-META-LESSON_TYPE'] = value;

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-META-TEACHER', (value, params, event, lastEvent) {
      try {
        lastEvent['X-META-TEACHER'] = <Object?>[
          ...?lastEvent['X-META-TEACHER'] as Iterable?,
          value,
        ];
        lastEvent['X-META-TEACHER-RAW'] = <Object?>[
          ...?lastEvent['X-META-TEACHER-RAW'] as Iterable?,
          {'uid': params['ID'], 'name': value, 'type': params['TYPE']},
        ];

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });

    registerField('X-SCHEDULE_VERSION-ID', (value, params, event, lastEvent) {
      try {
        lastEvent['X-SCHEDULE_VERSION-ID'] = value;

        return lastEvent;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          InvalidICalendarDataException(error: error),
          stackTrace,
        );
      }
    });
  }

  static void registerField(String field, SimpleParamFunction value) {
    if (!ICalendar.objects.containsKey(field)) {
      ICalendar.registerField(field: field, function: value);
    }
  }
}

typedef SimpleParamFunction =
    Map<String, dynamic>? Function(
      String value,
      Map<String, String> params,
      List<Object?> events,
      Map<String, dynamic> lastEvent,
    );
